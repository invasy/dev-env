SHELL := /bin/bash

IMAGE_NAME := $(if $(IMAGE_NAME_PREFIX),$(IMAGE_NAME_PREFIX),$(if $(DOCKER_REGISTRY),$(DOCKER_REGISTRY)/)$(DOCKER_USERNAME)/$(PROJECT)-)$(name)
tags := $(addprefix $(IMAGE_NAME):,$(tags))
container := dev_env_$(name)

ifneq ($(URL_PREFIX),)
URL := $(URL_PREFIX)$(name)
endif

define labels :=
$(if $(SOURCE),org.opencontainers.image.source='$(SOURCE)')
$(if $(URL),org.opencontainers.image.url='$(URL)')
endef

is_valid = $(findstring $1,$(invalid_targets))
update_version_m = sed -E 's/^(\s*$1\s*:=\s*)[0-9a-z.]+$$/\1$2/' -i ../$3/Makefile
update_version_d = sed -E 's/^(ARG\s+$1=")[^"]+(")$$/\1$2\2/' -i Dockerfile
update_version_r = sed -E 's/^(\|\s+(\*\*|)\[$1\].*\2\s+\|\s+)\S+(\s+\|)$$/\1$2\3/i' -i README.md

.PHONY: all $(TARGETS)
all: build

build: Dockerfile
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
	@echo -e "\e[34m>>\e[m \e[1;32m$(PROJECT)-$(name)\e[m \e[1;37mcontainers\e[m:" && \
	docker container ls -f 'name=$(container)' | tail --lines=+2
	@echo -e "\e[34m>>\e[m \e[1;32m$(PROJECT)-$(name)\e[m \e[1;37mimages\e[m:" && \
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
