# Clang toolchain configuration
ifeq ($(BUILD_CC), clang)
include /usr/share/linux-packaging-snippets/kernel-snippet-clang-clean-deb-toolchain.mk
# When clang custom is not enabled, Droidian(amd64) or Debian(arm64)
# toolchains will be used.
ifneq ($(CLANG_CUSTOM), 1)
# Limit for now to LLVM builds. For older, a deeper analysis is required.
ifeq ($(BUILD_LLVM), 1)
# CLANG_VERSION is required
ifdef CLANG_VERSION
include /usr/share/linux-packaging-snippets/kernel-snippet-clang-versions.mk
# Force clang from debian for the specified archs
ifeq ($(DEB_BUILD_ON),arm64)
	CLANG_FROM_DISTRO := debian
# Next else can be used to set a default distro for amd64 hosts.
# Currently amd64 not is not using any distro config
# to not alter the current compatibility
#else ifeq ($(DEB_BUILD_ON),amd64)
#	ifndef CLANG_FROM_DISTRO
#		CLANG_FROM_DISTRO := droidian
#	endif
endif
ifeq ($(CLANG_FROM_DISTRO), debian)
ifneq ($(findstring $(CLANG_VERSION_INT), $(CLANG_VERSIONS_DEBIAN)), $(CLANG_VERSION_INT))
	$(error Specified clang version not supported. Supported versions: $(CLANG_VERSIONS_DEBIAN))
endif
	DEB_TOOLCHAIN := \
		clang-$(CLANG_VERSION_INT), \
		lld-$(CLANG_VERSION_INT), \
		llvm-$(CLANG_VERSION_INT)-dev, \
		$(DEB_TOOLCHAIN_CLEANED)
	BUILD_PATH := /usr/lib/llvm-$(CLANG_VERSION_INT)/bin:$(BUILD_PATH)
# Next else can be enabled for droidian clang specific configs
#else ifeq ($(CLANG_FROM_DISTRO), droidian)
else
	DEB_TOOLCHAIN := \
		clang-android-$(CLANG_VERSION_STR), \
		$(DEB_TOOLCHAIN_CLEANED)
	BUILD_PATH := /usr/lib/llvm-android-$(CLANG_VERSION_STR)/bin:$(BUILD_PATH)
endif # clang DISTRO
endif # CLANG_VERSION
endif # BUILD_LLVM
endif # CLANG_CUSTOM false
# When CLANG_CUSTOM is enabled and manually downloaded, BUILD_PATH should be defined
# If using auto-download, BUILD_PATH will be overriden
ifeq ($(CLANG_CUSTOM), 1)
ifdef CLANG_CUSTOM_URL
ifndef BUILD_PATH
$(error BUILD_PATH should be DEFINED from the caller script, ex. kernel-info.mk)
else
ifeq ($(shell test ! -d "$(BUILD_PATH)" && echo notexist),notexist)
$(error Wrong BUILD_PATH. A valid path is required when CLANG_CUSTOM = 1)
endif
endif # BUILD_PATH
endif # CLANG_CUSTOM_URL
#BUILD_PATH := $(CLANG_CUSTOM_PATH)
# Keep the original DEB_TOOLCHAIN for custom clang
#DEB_TOOLCHAIN := $(DEB_TOOLCHAIN_CLEANED)
endif # CLANG_CUSTOM true
endif # BUILD_CC main
