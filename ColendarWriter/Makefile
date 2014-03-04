TARGET =: clang
ARCHS = armv7 arm64

include theos/makefiles/common.mk

TOOL_NAME = ColendarWriter
ColendarWriter_FILES = main.mm
ColendarWriter_FRAMEWORKS = UIKit
ColendarWriter_INSTALL_PATH = /usr/libexec/

include $(THEOS_MAKE_PATH)/tool.mk

 internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/DEBIAN$(ECHO_END)
	$(ECHO_NOTHING)cp postinst.sh $(THEOS_STAGING_DIR)/DEBIAN$(ECHO_END)

#after-install::
#	install.exec "launchctl load -w /System/Library/LaunchDaemons/com.insanj.ColendarWriter.plist"
