# DEB_TOOLCHAIN checker

# ARCH exceptions
# Some packages used in the Droidian kernel build process, are only available for the amd64 arch
# This causes compilation crashes on other archs, like arm64
# An example are the android gcc/binutils packages, so we will clean then for non amd64 hosts

# Clean DEB_TOOLCHAIN only when not amd64 host
ifneq ($(DEB_BUILD_ON),amd64)
DEB_TOOLCHAIN_CLEANED := $(shell echo $(DEB_TOOLCHAIN) \
	| tr ' ' '\n' \
	| grep -v '\-4.9-' \
	| grep -v '\clang-' \
	| tr '\n' ' ')
#
# Remove possible spaces/tabs from begin and end
DEB_TOOLCHAIN_CLEANED := $(strip $(DEB_TOOLCHAIN_CLEANED))
# Ensure there are not commas at the begin/end
DEB_TOOLCHAIN_CLEANED := $(shell echo $(DEB_TOOLCHAIN_CLEANED) | sed 's/^,//; s/,$$//')
# Remove again possible spaces/tabs from begin and end
DEB_TOOLCHAIN_CLEANED := $(strip $(DEB_TOOLCHAIN_CLEANED))
endif
