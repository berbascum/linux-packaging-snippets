# Disable not needed toolchains when using clang

# Clean gcc-4.9 packages from the kernel-info DEB_TOOLCHAIN
# Required for non amd64 hosts since the packages are only available for this arch

DEB_TOOLCHAIN_CLEANED := $(shell echo $(DEB_TOOLCHAIN) \
	| tr ' ' '\n' \
	| grep -v '\-4.9-' \
	| tr '\n' ' ')
# Remove possible spaces/tabs from begin and end
DEB_TOOLCHAIN_CLEANED := $(strip $(DEB_TOOLCHAIN_CLEANED))
# Ensure there is not a comma at the end
DEB_TOOLCHAIN_CLEANED := $(shell echo "$(DEB_TOOLCHAIN_CLEANED)" | sed 's/,$$//g')
