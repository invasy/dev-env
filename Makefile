SHELL := /bin/bash

PROJECT_NAME := dev-env
PROJECT_DIR  := $(patsubst %/,%,$(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

REGISTRY ?=
REGISTRY_USERNAME ?= invasy
REGISTRY_PASSWORD ?=

# Implemented images
IMAGES := $(patsubst docker/%/Makefile,%,$(wildcard docker/*/Makefile))
DOCKERFILES := $(wildcard docker/*/Dockerfile)
HADOLINT := $(if $(shell type -t hadolint),,docker run --rm -i -v '$(PROJECT_DIR):/src' -w '/src' ghcr.io/hadolint/hadolint )hadolint

# Available targets
TARGETS_SHELL   := sh shell bash
TARGETS_FOR_ALL := build run deploy push pull list ls clean
TARGETS         := lint $(TARGETS_FOR_ALL) $(TARGETS_SHELL) root
TARGETS_INVALID := $(foreach i,base cpp,$(foreach t,run $(TARGETS_SHELL) root,$t-$i))
TARGETS_IMAGE   := $(foreach i,$(IMAGES),$(foreach t,$(TARGETS),$t-$i))
TARGETS_VALID   := $(filter-out $(TARGETS_INVALID),$(TARGETS_IMAGE))

# Utility functions
target  = $(shell echo '$1' | sed -E 's/^([a-z-]+)-[a-z]+$$/\1/')
image   = $(shell echo '$1' | sed -E 's/^[a-z-]+-([a-z]+)$$/\1/')
submake = $$(MAKE) --include-dir='$$(PROJECT_DIR)/make' --directory='$$(PROJECT_DIR)/docker/$1' --no-print-directory$(if $2, '$2')

# Export variables to submakes
export SHELL NO_COLOR
export PROJECT_DIR PROJECT_NAME REGISTRY REGISTRY_USERNAME
export TARGETS_SHELL TARGETS HADOLINT
export IMAGE_NAME_PREFIX IMAGE_SOURCE IMAGE_URL_PREFIX IMAGE_URL IMAGE_REVISION IMAGE_CREATED
export no_cache no_pull tag

.PHONY: all help versions login lint $(IMAGES) $(TARGETS) $(TARGETS_IMAGE)
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

# Lint Dockerfiles with Hadolint
lint: $(DOCKERFILES)
	@$(HADOLINT) $^

# Target dependencies
run: build
cpp: base
build-cpp: build-base
clang gcc: cpp
$(addprefix build-,clang gcc): build-cpp

# Container registry
deploy push: login build
login:
	@echo '$(REGISTRY_PASSWORD)' | docker login --username='$(REGISTRY_USERNAME)' \
		--password-stdin '$(if $(REGISTRY),$(REGISTRY),docker.io)'

# Docker Compose
$(addprefix up-,$(IMAGES)): compose.yml
	@docker compose up -d '$(call image,$@)'
$(foreach i,$(IMAGES),$(eval up-$i: build-$i))

down $(addprefix down-,$(IMAGES)): compose.yml
	@docker compose down
