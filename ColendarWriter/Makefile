TARGET =: clang
ARCHS = armv7 arm64

include theos/makefiles/common.mk

TOOL_NAME = ColendarWriter
ColendarWriter_FILES = main.mm
ColendarWriter_INSTALL_PATH = /usr/libexec/

include $(THEOS_MAKE_PATH)/tool.mk

# Causes frustrating: dpkg-deb: building package `com.insanj.colendar' in `./debs/com.insanj.colendar_0.1-4_iphoneos-arm.deb'.
# make: *** [internal-package] Error 2
# internal-stage::
#	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/DEBIAN$(ECHO_END)
#	$(ECHO_NOTHING)cp postinst $(THEOS_STAGING_DIR)/DEBIAN$(ECHO_END)

after-install::
	install.exec "launchctl load -w /System/Library/LaunchDaemons/com.insanj.ColendarWriter.plist"
