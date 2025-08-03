# control override rule for custom kernel name

override debian/control:
	#@HOST_ARCH=$$(uname -m); \
	#if [ "$$HOST_ARCH" = "aarch64" ]; then \
	#fi
	sed \
		-e "s|@VARIANT@-@DEVICE_VENDOR@-@DEVICE_MODEL@|@VARIANT@-@KERNEL_DEVELOPER_NAME@-@DEVICE_VENDOR@-@DEVICE_MODEL@|g" \
		-e "s|@KERNEL_BASE_VERSION@-@DEVICE_VENDOR@-@DEVICE_MODEL@|@VARIANT@-@KERNEL_DEVELOPER_NAME@-@DEVICE_VENDOR@-@DEVICE_MODEL@|g" \
		-e "s|@KERNEL_BASE_VERSION@|$(KERNEL_BASE_VERSION)|g" \
		-e "s|@VARIANT@|$(VARIANT)|g" \
		-e "s|@KERNEL_DEVELOPER_NAME@|$(KERNEL_DEVELOPER_NAME)|g" \
		-e "s|@DEVICE_VENDOR@|$(DEVICE_VENDOR)|g" \
		-e "s|@DEVICE_MODEL@|$(DEVICE_MODEL)|g" \
		-e "s|@DEVICE_FULL_NAME@|$(DEVICE_FULL_NAME)|g" \
		-e "s|@DEB_TOOLCHAIN@|$(DEB_TOOLCHAIN)|g" \
		-e "s|@DEB_BUILD_ON@|$(DEB_BUILD_ON)|g" \
		-e "s|@DEB_BUILD_FOR@|$(DEB_BUILD_FOR)|g" \
	/usr/share/linux-packaging-snippets/control.in > debian/control
