SHELL := /bin/bash

NAMESPACE := invasy
image := $(NAMESPACE)/dev-env-$(name)
image_github := $(GITHUB_REGISTRY)/$(image)
image_gitlab := $(GITLAB_REGISTRY)/$(image)
container := dev_env_$(name)

tags_dockerhub := $(addprefix $(image):,$(tags))
tags_github    := $(addprefix $(image_github):,$(tags))
tags_gitlab    := $(addprefix $(image_gitlab):,$(tags))
tags_all       := $(tags_dockerhub) $(tags_github) $(tags_gitlab)

define deploy_to_registry =
$(addsuffix -$1,$(TARGETS_DEPLOY)): build
	@$$(foreach t,$$(tags_$1),docker image push '$$t' &&) :
endef

is_valid = $(findstring $1,$(invalid_targets))

update_version_m = sed -E 's/^(\s*$1\s*:=\s*)[0-9a-z.]+$$/\1$2/' -i ../$3/Makefile
update_version_d = sed -E 's/^(ARG\s+$1=")[^"]+(")$$/\1$2\2/' -i Dockerfile

.PHONY: all $(TARGETS)
all: build

build: Dockerfile
	@docker build --progress plain $(if $(no_cache),--no-cache )\
		$(addprefix --build-arg=,$(build_args)) \
		$(addprefix --tag=,$(tags_all)) .

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
	@-docker container ls -f 'name=$(container)'
	@-$(foreach i,$(image) $(image_github) $(image_gitlab),docker image $@ '$i';)

$(foreach r,$(REGISTRIES),$(eval $(call deploy_to_registry,$r)))
$(TARGETS_DEPLOY): $(addprefix push-,$(REGISTRIES))

pull:
	@docker image pull '$(if $(tag),$(tag),$(firstword $(tags_dockerhub)))'

clean:
	@-docker container rm -f $$(docker container ls -q -f 'name=$(container)') &>/dev/null
	@-docker image rm -f $$($(foreach i,$(image) $(image_github) $(image_gitlab),docker image ls -q '$i';)) &>/dev/null

ifdef invalid_targets
$(invalid_targets):
	@$(error invalid target '$@' for image '$(name)')false
endif
