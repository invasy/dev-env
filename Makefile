SHELL := /bin/bash
D := $(patsubst %/,%,$(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

PROJECT := dev-env
DOCKER_REGISTRY ?=
DOCKER_USERNAME ?= invasy
DOCKER_PASSWORD ?=

# Implemented images
IMAGES := $(patsubst docker/%/Makefile,%,$(wildcard docker/*/Makefile))

# Available targets
TARGETS_SHELL   := sh shell bash
TARGETS_FOR_ALL := build run deploy push pull list ls clean
TARGETS         := $(TARGETS_FOR_ALL) $(TARGETS_SHELL) root
TARGETS_INVALID := $(foreach i,base cpp,$(foreach t,run $(TARGETS_SHELL) root,$t-$i))
TARGETS_IMAGE   := $(foreach i,$(IMAGES),$(foreach t,$(TARGETS),$t-$i))
TARGETS_VALID   := $(filter-out $(TARGETS_INVALID),$(TARGETS_IMAGE))

# Utility functions
target  = $(shell echo '$1' | sed -E 's/^([a-z-]+)-[a-z]+$$/\1/')
image   = $(shell echo '$1' | sed -E 's/^[a-z-]+-([a-z]+)$$/\1/')
submake = $$(MAKE) --include-dir='$$D/make' --directory='$$D/docker/$1' --no-print-directory$(if $2, '$2')

# Export variables to submakes
export PROJECT TARGETS_SHELL TARGETS
export DOCKER_REGISTRY DOCKER_USERNAME IMAGE_NAME_PREFIX SOURCE URL_PREFIX URL
export no_cache no_pull tag

.PHONY: all help versions login $(IMAGES) $(TARGETS) $(TARGETS_IMAGE)
.PHONY: $(foreach i,$(IMAGES),$(foreach t,up down,$t-$i)) down

all: build

help:
	@:$(warning TODO: add usage info)

versions:
	@bin/versions.py

# Dynamic targets
$(IMAGES):;@$(call submake,$@)
$(foreach t,$(TARGETS_FOR_ALL),$(eval $t: $(filter-out $(TARGETS_INVALID),$(addprefix $t-,$(IMAGES)))))
$(foreach t,$(TARGETS_VALID),$(eval $t:;@$(call submake,$(call image,$t),$(call target,$t))))
$(foreach i,$(IMAGES),$(eval %-$i:;@$(call submake,$i,$$(call target,$$@))))
$(foreach t,$(TARGETS_INVALID),$(eval $t:;@$$(error invalid target '$(call target,$t)' for image '$(call image,$t)')false))

# Target dependencies
run: build
cpp: base
build-cpp: build-base
clang gcc: cpp
$(addprefix build-,clang gcc): build-cpp

# Container registry
deploy push: build login
login:
	@echo '$(DOCKER_PASSWORD)' | docker login --username='$(DOCKER_USERNAME)' \
		--password-stdin '$(if $(DOCKER_REGISTRY),$(DOCKER_REGISTRY),docker.io)'

# Docker Compose
$(addprefix up-,$(IMAGES)): compose.yml
	@docker compose up -d '$(call image,$@)'

down $(addprefix down-,$(IMAGES)): compose.yml
	@docker compose down
