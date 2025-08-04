# Clang version configuration
# Possible supplied integer or string version

CLANG_VERSIONS_DROIDIAN := \
	6=6.0-4691093 \
	9=9.0-r353983c \
	10=10.0-r370808 \
	12=12.0-r416183b \
	14=14.0-r450784d
VERSION_STRING := $(shell echo $(CLANG_VERSIONS_DROIDIAN) \
	| tr ' ' '\n' \
	| grep "^$(CLANG_VERSION)=" \
	| cut -d'=' -f2)
ifneq ($(VERSION_STRING),)
	CLANG_VERSION_STR := $(VERSION_STRING)
	CLANG_VERSION_INT := $(CLANG_VERSION)
else
	CLANG_VERSION_STR := $(CLANG_VERSION)
	CLANG_VERSION_INT := $(shell \
		echo $(CLANG_VERSION) \
		| awk -F'.' '{print $1}')
endif

CLANG_VERSIONS_DEBIAN := 9 11 13 14 15 16 17 18 19
