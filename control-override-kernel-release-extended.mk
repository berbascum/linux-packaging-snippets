# control override rule for kernel release extended info

#@HOST_ARCH=$$(uname -m); \
#if [ "$$HOST_ARCH" = "aarch64" ]; then \
#fi

override debian/control:
	sed \
		-e '/Source: / s|@VARIANT@-@DEVICE_VENDOR@-@DEVICE_MODEL@|@VARIANT@-@KERNEL_DEVELOPER_NAME@-@DEVICE_VENDOR@-@DEVICE_MODEL@|g' \
		-e '/Vcs-Browser: / s|@VARIANT@-@DEVICE_VENDOR@-@DEVICE_MODEL@|@VARIANT@-@KERNEL_DEVELOPER_NAME@-@DEVICE_VENDOR@-@DEVICE_MODEL@|g' \
		-e '/Vcs-Git: / s|@VARIANT@-@DEVICE_VENDOR@-@DEVICE_MODEL@|@VARIANT@-@KERNEL_DEVELOPER_NAME@-@DEVICE_VENDOR@-@DEVICE_MODEL@|g' \
		-e 's|^Package: linux-headers-@DEVICE_VENDOR@-@DEVICE_MODEL@|Package: linux-headers-@VARIANT@-@KERNEL_DEVELOPER_NAME@-@DEVICE_VENDOR@-@DEVICE_MODEL@|g' \
		-e 's|^Package: linux-bootimage-@DEVICE_VENDOR@-@DEVICE_MODEL@|Package: linux-bootimage-@VARIANT@-@KERNEL_DEVELOPER_NAME@-@DEVICE_VENDOR@-@DEVICE_MODEL@|g' \
		-e 's|^Package: linux-image-@DEVICE_VENDOR@-@DEVICE_MODEL@|Package: linux-image-@VARIANT@-@KERNEL_DEVELOPER_NAME@-@DEVICE_VENDOR@-@DEVICE_MODEL@|g' \
		-e 's|@KERNEL_BASE_VERSION@-@DEVICE_VENDOR@-@DEVICE_MODEL@|@KERNEL_BASE_VERSION@-@VARIANT@-@KERNEL_DEVELOPER_NAME@-@DEVICE_VENDOR@-@DEVICE_MODEL@|g' \
		-e "s|@KERNEL_BASE_VERSION@|$(KERNEL_BASE_VERSION)|g" \
		-e "s|@VARIANT@|$(VARIANT)|g" \
		-e "s|@KERNEL_DEVELOPER_NAME@|$(KERNEL_DEVELOPER_NAME)|g" \
		-e "s|@KBUILD_DROIDIAN_VERSION@|$(KBUILD_DROIDIAN_VERSION)|g" \
		-e "s|@DEVICE_VENDOR@|$(DEVICE_VENDOR)|g" \
		-e "s|@DEVICE_MODEL@|$(DEVICE_MODEL)|g" \
		-e "s|@DEVICE_FULL_NAME@|$(DEVICE_FULL_NAME)|g" \
		-e "s|@DEB_TOOLCHAIN@|$(DEB_TOOLCHAIN)|g" \
		-e "s|@DEB_BUILD_ON@|$(DEB_BUILD_ON)|g" \
		-e "s|@DEB_BUILD_FOR@|$(DEB_BUILD_FOR)|g" \
	/usr/share/linux-packaging-snippets/control.in > debian/control \
	&& sed \
	-i 's/^KERNEL_RELEASE = .*/KERNEL_RELEASE = $$(KERNEL_BASE_VERSION)-$$(VARIANT)-$$(KERNEL_DEVELOPER_NAME)-$$(DEVICE_VENDOR)-$$(DEVICE_MODEL)-$$(KBUILD_DROIDIAN_VERSION)/g' \
	/usr/share/linux-packaging-snippets/kernel-snippet.mk \
	&& sed \
		-i '/^kernel_snippet_install:/i kernel_snippet_install: KERNEL_RELEASE = $$(KERNEL_BASE_VERSION)-$$(VARIANT)-$$(KERNEL_DEVELOPER_NAME)-$$(DEVICE_VENDOR)-$$(DEVICE_MODEL)' \
	/usr/share/linux-packaging-snippets/kernel-snippet.mk
