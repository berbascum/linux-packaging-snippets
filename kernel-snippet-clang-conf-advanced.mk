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
#
ifeq ($(DEB_BUILD_ON),arm64)
CLANG_OS_DISTRIB := debian
include /usr/share/linux-packaging-snippets/kernel-snippet-clang-versions.mk
# Clean DEB_TOOLCHAIN
include /usr/share/linux-packaging-snippets/kernel-snippet-clang-clean-deb-toolchain.mk
BUILD_PATH := /usr/lib/llvm-$(CLANG_VERSION_INT)/bin:$(BUILD_PATH)
else ifeq ($(DEB_BUILD_ON),amd64)
CLANG_OS_DISTRIB := droidian
include /usr/share/linux-packaging-snippets/kernel-snippet-clang-versions.mk
# Clean DEB_TOOLCHAIN
include /usr/share/linux-packaging-snippets/kernel-snippet-clang-clean-deb-toolchain.mk
$(info Configuring BUILD_PATH for amd64...)
BUILD_PATH := /usr/lib/llvm-android-$(CLANG_VERSION_STR)/bin:$(BUILD_PATH)
endif # ARCH

# CLANG_CUSTOM enabled
else ifeq ($(CLANG_CUSTOM), 1)
$(info CLANG_CUSTOM enabled)
#
# Check BUILD_PATH_CLANG_CUSTOM
# When download clang custom is enabled, the var should
# be autoconfigured in kernel-info.mk
# But we check it anyway.
# When download clang custom is is disabled,
# BUILD_PATH_CLANG_CUSTOM must be manually defined in kernel-snippet.mk
ifeq ($(DOWNLOAD_CLANG_CUSTOM), 1)
ifndef BUILD_PATH_CLANG_CUSTOM
$(error BUILD_PATH_CLANG_CUSTOM not defined. Prepend it to the releng-build-package command)
endif # BUILD_PATH_CLANG_CUSTOM
else # DOWNLOAD_CLANG_CUSTOM
ifndef BUILD_PATH_CLANG_CUSTOM
$(error BUILD_PATH_CLANG_CUSTOM not defined. Check in kernel-info.mk)
endif # BUILD_PATH_CLANG_CUSTOM
ifeq ($(shell test ! -d "$(BUILD_PATH_CLANG_CUSTOM)" && echo notexist),notexist)
$(error Wrong BUILD_PATH_CLANG_CUSTOM. A valid path is required for clang custom. Check in kernel-info.mk)
endif # shell test dir
endif # DOWNLOAD_CLANG_CUSTOM
#
$(info BUILD_PATH_CLANG_CUSTOM = $(BUILD_PATH_CLANG_CUSTOM))
BUILD_PATH := $(BUILD_PATH_CLANG_CUSTOM):$(BUILD_PATH)
#
# Clean DEB_TOOLCHAIN for clang custom
include /usr/share/linux-packaging-snippets/kernel-snippet-clang-clean-deb-toolchain.mk
#DEB_TOOLCHAIN := $(DEB_TOOLCHAIN_CLEANED)
endif # CLANG_CUSTOM
endif # BUILD_LLVM
endif # BUILD_CC main
