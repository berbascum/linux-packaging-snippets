# Clang toolchain configuration

# To enable the snippet, just add in debian/rules below the kernel-snippet.mk include
# include /usr/share/linux-packaging-snippets/kernel-snippet-clang-conf-advanced.mk
# Read some notes in the kernel-info.mk.example

# CLANG LLVM enabled
ifeq ($(BUILD_CC), clang)
# Limit for now to LLVM builds. For older, a deeper analysis is required.
ifeq ($(BUILD_LLVM), 1)

# CLANG_CUSTOM not enabled
# When clang custom is not enabled, Droidian(amd64) or Debian(arm64)
# prebuilts will be used.
ifneq ($(CLANG_CUSTOM), 1)
$(info CLANG_CUSTOM disabled)
# CLANG_VERSION is required
ifndef CLANG_VERSION
$(error CLANG_VERSION is required in kernel.info.mk)
endif

ifeq ($(DEB_BUILD_ON),arm64)
CLANG_OS_DISTRIB := debian
include /usr/share/linux-packaging-snippets/kernel-snippet-clang-versions.mk
# Clean DEB_TOOLCHAIN
include /usr/share/linux-packaging-snippets/kernel-snippet-clang-clean-deb-toolchain.mk
# TODO: What to do bith the BUILD_PATH
BUILD_PATH := /usr/lib/llvm-$(CLANG_VERSION_INT)/bin:$(BUILD_PATH)
else ifeq ($(DEB_BUILD_ON),amd64)
CLANG_OS_DISTRIB := droidian
include /usr/share/linux-packaging-snippets/kernel-snippet-clang-versions.mk
# Clean DEB_TOOLCHAIN
include /usr/share/linux-packaging-snippets/kernel-snippet-clang-clean-deb-toolchain.mk
$(info Configuring BUILD_PATH for amd64...)
# TODO: PULIR PATH SI HI HA COSES DEFINIDES al kernel-info
BUILD_PATH := /usr/lib/llvm-android-$(CLANG_VERSION_STR)/bin:$(BUILD_PATH)
endif # ARCH

# CLANG_CUSTOM enabled
else ifeq ($(CLANG_CUSTOM), 1)
$(info CLANG_CUSTOM enabled)
# TODO: Currently managed by the helper script
# ifeq ($(DOWNLOAD_CLANG_CUSTOM), 1)
# BUILD_PATH will be overriden
# endif
ifndef BUILD_PATH
$(error BUILD_PATH should be DEFINED from the caller script, ex. kernel-info.mk)
endif # BUILD_PATH
ifeq ($(shell test ! -d "$(BUILD_PATH)" && echo notexist),notexist)
$(error Wrong BUILD_PATH. A valid path is required when CLANG_CUSTOM = 1)
endif
# Clean DEB_TOOLCHAIN for clang custom
include /usr/share/linux-packaging-snippets/kernel-snippet-clang-clean-deb-toolchain.mk
#DEB_TOOLCHAIN := $(DEB_TOOLCHAIN_CLEANED)
endif # CLANG_CUSTOM
endif # BUILD_LLVM
endif # BUILD_CC main
