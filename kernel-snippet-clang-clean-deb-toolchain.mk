# DEB_TOOLCHAIN checker

# ARCH exceptions
# Some packages used in the Droidian kernel build process, are only available for the amd64 arch
# This causes compilation crashes on other archs, like arm64
# An example are the android gcc/binutils packages, so we will clean then for non amd64 hosts

# Currently only amd64 and arm64 hosts are supported

# For CLANG_CUSTOM = 1, we need to remove clang- from DEB_TOOLCHAIN for all hosts.

# For CLANG_CUSTOM = "not 1", DEB_TOOLCHAIN is redefined based on the CLANG_VERSION value

# For arm64 hosts, gcc 4.9 packages needs to be removed

$(info Loading clang-clean-deb-toolchain snippet for $(DEB_BUILD_ON) and CLANG_CUSTOM = $(CLANG_CUSTOM))

# Clean DEB_TOOLCHAIN for any host when CLANG_CUSTOM is enabled
ifeq ($(CLANG_CUSTOM),1)
ifneq ($(DEB_BUILD_ON),amd64)
$(info Configuring DEB_TOOLCHAIN)
DEB_TOOLCHAIN_CLEANED := $(shell echo $(DEB_TOOLCHAIN) \
	| tr ' ' '\n' \
	| grep -v '\-4.9-' \
	| grep -v '\clang-' \
	| tr '\n' ' ')
#
else ifeq ($(DEB_BUILD_ON),amd64)
$(info Configuring DEB_TOOLCHAIN)
DEB_TOOLCHAIN_CLEANED := $(shell echo $(DEB_TOOLCHAIN) \
	| tr ' ' '\n' \
	| grep -v '\clang-' \
	| tr '\n' ' ')
#
endif # ARCH
else ifneq ($(CLANG_CUSTOM),1)
# Clean DEB_TOOLCHAIN when arm64 host
ifeq ($(DEB_BUILD_ON),arm64)
$(info Configuring DEB_TOOLCHAIN)
DEB_TOOLCHAIN_CLEANED := $(shell echo $(DEB_TOOLCHAIN) \
	| tr ' ' '\n' \
	| grep -v '\-4.9-' \
	| grep -v '\clang-' \
	| tr '\n' ' ')
DEB_TOOLCHAIN_CLEANED := \
	clang-$(CLANG_VERSION), \
	lld-$(CLANG_VERSION), \
	llvm-$(CLANG_VERSION)-dev, \
	$(DEB_TOOLCHAIN_CLEANED)
else ifeq ($(DEB_BUILD_ON),amd64)
$(info DEB_TOOLCHAIN initial: $(DEB_TOOLCHAIN))
DEB_TOOLCHAIN_CLEANED := $(shell echo $(DEB_TOOLCHAIN) \
	| tr ' ' '\n' \
	| grep -v '\clang-' \
	| tr '\n' ' ')
$(info DEB_TOOLCHAIN_CLEANED after step 1: $(DEB_TOOLCHAIN_CLEANED))
DEB_TOOLCHAIN_CLEANED := \
	clang-android-$(CLANG_VERSION_STR), \
	$(DEB_TOOLCHAIN_CLEANED)
$(info DEB_TOOLCHAIN_CLEANED after step 2: $(DEB_TOOLCHAIN_CLEANED))
endif # ARCH
endif # CLANG_CUSTOM
#
# Remove possible spaces/tabs from begin and end
DEB_TOOLCHAIN_CLEANED := $(strip $(DEB_TOOLCHAIN_CLEANED))
# Ensure there are not commas at the begin/end
DEB_TOOLCHAIN_CLEANED := $(shell echo $(DEB_TOOLCHAIN_CLEANED) | sed 's/^,//; s/,$$//')
# Remove again possible spaces/tabs from begin and end
DEB_TOOLCHAIN_CLEANED := $(strip $(DEB_TOOLCHAIN_CLEANED))

DEB_TOOLCHAIN = $(DEB_TOOLCHAIN_CLEANED)
