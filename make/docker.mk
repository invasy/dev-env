IMAGE_NAME := $(if $(IMAGE_NAME_PREFIX),$(IMAGE_NAME_PREFIX),$(if $(REGISTRY),$(REGISTRY)/)$(REGISTRY_USERNAME)/$(PROJECT_NAME)-)$(name)
tags := $(addprefix $(IMAGE_NAME):,$(tags))
container := dev_env_$(name)
now != date -u '+%Y-%m-%dT%T%z'

# Image labels
# See https://github.com/opencontainers/image-spec/blob/main/annotations.md#pre-defined-annotation-keys
ifneq ($(IMAGE_URL_PREFIX),)
IMAGE_URL := $(IMAGE_URL_PREFIX)$(name)
endif
define labels :=
org.opencontainers.image.created='$(now)'
$(if $(IMAGE_REVISION),org.opencontainers.image.revision='$(IMAGE_REVISION)')
$(if $(IMAGE_SOURCE),org.opencontainers.image.source='$(IMAGE_SOURCE)')
$(if $(IMAGE_URL),org.opencontainers.image.url='$(IMAGE_URL)')
endef

# Functions
relpath = $(subst $(PROJECT_DIR)/,,$(realpath $1))
is_valid = $(findstring $1,$(invalid_targets))
update_version_m = sed -E 's/^(\s*$1\s*:=\s*)[0-9a-z.]+$$/\1$2/' -i ../$3/Makefile
update_version_d = sed -E 's/^(ARG\s+$1=")[^"]+(")$$/\1$2\2/' -i Dockerfile
update_version_r = sed -E 's/^(\|\s+(\*\*|)\[$1\].*\2\s+\|\s+)\S+(\s+\|)$$/\1$2\3/i' -i README.md

# Colors
# See https://no-color.org/
fg_blue  := $(if $(NO_COLOR),,\e[34m)
fg_green := $(if $(NO_COLOR),,\e[1;32m)
fg_white := $(if $(NO_COLOR),,\e[1;37m)
sgr0     := $(if $(NO_COLOR),,\e[m)

.PHONY: all $(TARGETS)
all: build

lint: Dockerfile
	@cd ../.. && $(HADOLINT) $(call relpath,$<)

build: lint
	@docker build --progress plain \
		$(if $(no_cache),--no-cache) \
		$(if $(no_pull),,--pull) \
		$(addprefix --build-arg=,$(build_args)) \
		$(addprefix --tag=,$(tags)) \
		$(addprefix --label=,$(labels)) .

ifeq ($(call is_valid,run),)
run: build
	@docker run --detach --cap-add=sys_admin --name='$(container)' \
		--publish='127.0.0.1:$(port):22' --restart=unless-stopped \
		'$(if $(tag),$(tag),$(firstword $(tags_dockerhub)))'
endif

ifeq ($(foreach t,$(TARGETS_SHELL),$(call is_valid,$t)),)
$(TARGETS_SHELL):
	@docker exec --interactive --tty --user builder --workdir /home/builder \
	'$(container)' /bin/bash
endif

ifeq ($(call is_valid,root),)
root:
	@docker exec --interactive --tty --workdir /root '$(container)' /bin/bash
endif

list ls:
	@echo -e "$(fg_blue)>>$(sgr0) $(fg_green)$(PROJECT_NAME)-$(name)$(sgr0) $(fg_white)containers$(sgr0):" && \
	docker container ls -f 'name=$(container)' | tail --lines=+2
	@echo -e "$(fg_blue)>>$(sgr0) $(fg_green)$(PROJECT_NAME)-$(name)$(sgr0) $(fg_white)images$(sgr0):" && \
	docker image ls '$(IMAGE_NAME)' | tail --lines=+2

deploy push: build
	@$(foreach t,$(tags),docker push '$t';)

pull:
	@docker image pull '$(if $(tag),$(tag),$(IMAGE_NAME):latest)'

clean:
	@-docker container rm -f $$(docker container ls -q -f 'name=$(container)') &>/dev/null
	@-docker image rm -f $$(docker image ls -q '$(IMAGE_NAME)') &>/dev/null

ifneq ($(invalid_targets),)
$(invalid_targets):
	@$(error invalid target '$@' for image '$(name)')false
endif
