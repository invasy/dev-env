GCC_VERSION    := 12.2.0
CMAKE_VERSION  := 3.23.5
NINJA_VERSION  := 1.11.1
DEBIAN_VERSION := bullseye

name := gcc
port := 22002

define build_args :=
GCC_VERSION=$(GCC_VERSION)
CMAKE_VERSION=$(CMAKE_VERSION)
DEBIAN_VERSION=$(DEBIAN_VERSION)
endef

define tags :=
$(GCC_VERSION)-$(CMAKE_VERSION)-$(DEBIAN_VERSION)
$(GCC_VERSION)-$(DEBIAN_VERSION)
$(GCC_VERSION)-$(CMAKE_VERSION)
$(GCC_VERSION)
latest
endef

include docker.mk

.PHONY: update-gcc-version
update-gcc-version:
	@$(call update_version_d,GCC_VERSION,$(GCC_VERSION)) && \
	$(call update_version_r,gcc,$(GCC_VERSION))

.PHONY: update-cmake-version
update-cmake-version:
	@$(call update_version_d,CMAKE_VERSION,$(CMAKE_VERSION)) && \
	$(call update_version_r,cmake,$(CMAKE_VERSION))

.PHONY: update-debian-version
update-debian-version:
	@$(call update_version_d,DEBIAN_VERSION,$(DEBIAN_VERSION))
