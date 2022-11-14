CLANG_VERSION  := 14
CMAKE_VERSION  := 3.23.5
NINJA_VERSION  := 1.11.1
DEBIAN_VERSION := bullseye

name := clang
port := 22001

define build_args :=
CLANG_VERSION=$(CLANG_VERSION)
CMAKE_VERSION=$(CMAKE_VERSION)
DEBIAN_VERSION=$(DEBIAN_VERSION)
endef

define tags :=
$(CLANG_VERSION)-$(CMAKE_VERSION)-$(DEBIAN_VERSION)
$(CLANG_VERSION)-$(DEBIAN_VERSION)
$(CLANG_VERSION)-$(CMAKE_VERSION)
$(CLANG_VERSION)
latest
endef

include docker.mk

.PHONY: update-clang-version
update-clang-version:
	@$(call update_version_d,CLANG_VERSION,$(CLANG_VERSION)) && \
	$(call update_version_r,clang,$(CLANG_VERSION))

.PHONY: update-cmake-version
update-cmake-version:
	@$(call update_version_d,CMAKE_VERSION,$(CMAKE_VERSION)) && \
	$(call update_version_r,cmake,$(CMAKE_VERSION))

.PHONY: update-debian-version
update-debian-version:
	@$(call update_version_d,DEBIAN_VERSION,$(DEBIAN_VERSION))
