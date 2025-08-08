# Clang version configuration snippet
#
# For CLANG_CUSTOM not enabled and amd64/arm64 hosts:
# Set CLANG_VERSION to a supported version using an int.

# For CLANG_CUSTOM enabled and amd64/arm64 hosts:
# For use the predefined repos; set CLANG_CUSTOM_REVISION to
# a supported revision code.
# More info in the kernel-info.mk.example

$(info Loading clang-versions-$(CLANG_OS_DISTRIB) snippet for $(DEB_BUILD_ON) and CLANG_CUSTOM = $(CLANG_CUSTOM))

ifeq ($(CLANG_OS_DISTRIB), droidian)
CLANG_VERSIONS_DROIDIAN_FULL := \
	6=6.0-4691093 \
	9=9.0-r353983c \
	10=10.0-r370808 \
	12=12.0-r416183b \
	14=14.0-r450784d

CLANG_VERSIONS_DROIDIAN_INT := 6 9 10 12 14

ifneq ($(findstring $(CLANG_VERSION), $(CLANG_VERSIONS_DROIDIAN_INT)), $(CLANG_VERSION))
$(error Unsupported clang-droidian version in kernel-info.mk. Supported: $(CLANG_VERSIONS_DROIDIAN_INT))
endif

CLANG_VERSION_STR := $(shell echo $(CLANG_VERSIONS_DROIDIAN_FULL) \
	| tr ' ' '\n' \
	| grep "^$(CLANG_VERSION)=" \
	| cut -d'=' -f2)
$(info CLANG_VERSION = $(CLANG_VERSION))
$(info CLANG_VERSION_STR = $(CLANG_VERSION_STR))

else ifeq ($(CLANG_OS_DISTRIB),debian)
CLANG_VERSIONS_DEBIAN_FULL := 11 13
CLANG_VERSIONS_DEBIAN_INT := $(CLANG_VERSIONS_DEBIAN_FULL)
ifneq ($(findstring $(CLANG_VERSION), $(CLANG_VERSIONS_DEBIAN_INT)), $(CLANG_VERSION))
$(error Unsupported clang-debian version in kernel-info.mk. Supported: $(CLANG_VERSIONS_DEBIAN_INT))
endif
$(info CLANG_VERSION = $(CLANG_VERSION))

endif # CLANG_OS_DISTRIB
