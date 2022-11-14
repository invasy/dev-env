DEBIAN_VERSION := bullseye

name := base

define build_args :=
DEBIAN_VERSION=$(DEBIAN_VERSION)
endef

define tags :=
$(DEBIAN_VERSION)
latest
endef

invalid_targets := run sh shell bash root

include docker.mk

.PHONY: update-debian-versions update-debian-version
update-debian-versions: update-debian-version
	@$(foreach i,cpp clang gcc,$(call update_version_m,DEBIAN_VERSION,$(DEBIAN_VERSION),$i) && $(MAKE) -C ../$i $<;)
update-debian-version:
	@$(call update_version_d,DEBIAN_VERSION,$(DEBIAN_VERSION))
