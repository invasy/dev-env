SHELL := /bin/bash

# Makefile directory
D := $(patsubst %/,%,$(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

# Container registries
GITHUB_REGISTRY   := ghcr.io
GITLAB_REGISTRY   := registry.gitlab.com
REGISTRIES        := dockerhub github gitlab

# Implemented images
IMAGES            := $(patsubst docker/%/Makefile,%,$(wildcard docker/*/Makefile))

# Available targets
TARGETS_SHELL     := bash sh shell
TARGETS_DEPLOY    := deploy push
TARGETS_REGISTRY  := $(foreach t,$(TARGETS_DEPLOY),$(foreach r,$(REGISTRIES),$t-$r))
TARGETS_FOR_ALL   := build run $(TARGETS_DEPLOY) $(TARGETS_REGISTRY) pull list ls clean
TARGETS           := $(TARGETS_FOR_ALL) $(TARGETS_SHELL) root
TARGETS_INVALID   := $(foreach i,base cpp,$(foreach t,run $(TARGETS_SHELL) root,$i-$t))
TARGETS_IMAGE     := $(foreach i,$(IMAGES),$(foreach t,$(TARGETS),$i-$t))
TARGETS_VALID     := $(filter-out $(TARGETS_INVALID),$(TARGETS_IMAGE))

null  :=
space := $(null) $(null)
image  = $(firstword $(subst -, ,$1))
target = $(subst $(space),-,$(wordlist 2,100,$(subst -, ,$1)))

# Export variables to submakes
export GITHUB_REGISTRY GITLAB_REGISTRY REGISTRIES
export TARGETS_DEPLOY TARGETS_REGISTRY TARGETS_SHELL TARGETS
export no_cache tag

.PHONY: all help versions login $(IMAGES) $(TARGETS) $(TARGETS_IMAGE)
.PHONY: $(foreach i,$(IMAGES),$(foreach t,up down,$i-$t)) down

all: build

help:
	@:$(info TODO)

versions:
	@bin/versions.py | sort --key=2 | column --table

# Dynamic targets
$(foreach t,$(TARGETS_FOR_ALL),$(eval $t: $(filter-out $(TARGETS_INVALID),$(addsuffix -$t,$(IMAGES)))))
$(foreach t,$(TARGETS_VALID),$(eval $t:;@$$(MAKE) -I '$$D/make' -C '$$D/docker/$(call image,$t)' '$(call target,$t)'))
$(foreach i,$(IMAGES),$(eval $i-%:;@$$(MAKE) -I '$$D/make' -C '$$D/docker/$i' '$$(call target,$$@)'))
$(foreach t,$(TARGETS_INVALID),$(eval $t:;@$$(error invalid target '$(call target,$t)' for image '$(call image,$t)')false))
$(IMAGES):;@$(MAKE) --include-dir='$D/make' --directory='$D/docker/$@'

# Dependencies
$(filter-out base,$(IMAGES)): base
$(addsuffix -build,$(filter-out base,$(IMAGES))): base-build

# Push to registries
login-dockerhub:
	@echo "$${DOCKER_PASSWORD:?}" | docker login --username="$${DOCKER_USERNAME:?}" --password-stdin "$${DOCKER_REGISTRY}"

login-github:
	@echo "$${GITHUB_TOKEN:?}" | docker login --username="$${GITHUB_USER:?}" --password-stdin "$(GITHUB_REGISTRY)"

login-gitlab:
	@echo "$${CI_REGISTRY_PASSWORD:?}" | docker login --username="$${CI_REGISTRY_USER:?}" --password-stdin "$${CI_REGISTRY:?}"

$(foreach r,$(REGISTRIES),$(eval $(addsuffix -push-$r,$(IMAGES)): login-$r))

# Compose
$(addsuffix -up,$(IMAGES)): compose.yml
	@docker compose up -d '$(call image,$@)'

down $(addsuffix -down,$(IMAGES)): compose.yml
	@docker compose down
