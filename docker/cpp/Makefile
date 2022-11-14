CMAKE_VERSION  := 3.23.5
NINJA_VERSION  := 1.11.1
NINJA_CHECKSUM := b901ba96e486dce377f9a070ed4ef3f79deb45f4ffe2938f8e7ddc69cfb3df77
DEBIAN_VERSION := bullseye

NINJA_URL := https://github.com/ninja-build/ninja/releases/download/v$(NINJA_VERSION)/ninja-linux.zip

name := cpp

define build_args :=
DEBIAN_VERSION=$(DEBIAN_VERSION)
NINJA_VERSION=$(NINJA_VERSION)
NINJA_CHECKSUM=$(NINJA_CHECKSUM)
CMAKE_VERSION=$(CMAKE_VERSION)
endef

define tags :=
$(CMAKE_VERSION)-$(DEBIAN_VERSION)
$(CMAKE_VERSION)
latest
endef

invalid_targets := run sh shell bash root

include docker.mk

descendants := clang gcc

.PHONY: update-cmake-versions update-cmake-version
update-cmake-versions: update-cmake-version
	@$(foreach i,$(descendants),$(call update_version_m,CMAKE_VERSION,$(CMAKE_VERSION),$i) && $(MAKE) -C ../$i $<;)
update-cmake-version:
	@$(call update_version_d,CMAKE_VERSION,$(CMAKE_VERSION)) && \
	$(call update_version_r,cmake,$(CMAKE_VERSION))

.PHONY: update-ninja-versions update-ninja-version
update-ninja-versions: update-ninja-version
	@$(foreach i,$(descendants),$(call update_version_m,NINJA_VERSION,$(NINJA_VERSION),$i);)
update-ninja-version:
	@set -eu; \
	checksum=$$(wget --quiet --output-document=- '$(NINJA_URL)' | sha256sum --binary | cut --delimiter=' ' --fields=1); \
	sed -E 's/^(\s*NINJA_CHECKSUM\s*:=\s*)[0-9a-f]+$$/\1'"$$checksum"'/' -i Makefile; \
	sed -E 's/^(ARG\s+NINJA_CHECKSUM=")[^"]+(")$$/\1'"$$checksum"'\2/'   -i Dockerfile; \
	$(call update_version_d,NINJA_VERSION,$(NINJA_VERSION)) && \
	$(call update_version_r,ninja,$(NINJA_VERSION))

.PHONY: update-debian-versions update-debian-version
update-debian-versions: update-debian-version
	@$(foreach i,$(descendants),$(call update_version_m,DEBIAN_VERSION,$(DEBIAN_VERSION),$i) && $(MAKE) -C ../$i $<;)
update-debian-version:
	@$(call update_version_d,DEBIAN_VERSION,$(DEBIAN_VERSION))
