TARGET =: clang
ARCHS = armv7 arm64

include theos/makefiles/common.mk

TOOL_NAME = ColendarWriter
ColendarWriter_FILES = main.mm
ColendarWriter_INSTALL_PATH = /usr/libexec/

include $(THEOS_MAKE_PATH)/tool.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/DEBIAN$(ECHO_END)
	$(ECHO_NOTHING)cp preinst $(THEOS_STAGING_DIR)/DEBIAN$(ECHO_END)
	$(ECHO_NOTHING)cp postinst $(THEOS_STAGING_DIR)/DEBIAN$(ECHO_END)
	$(ECHO_NOTHING)cp postrm $(THEOS_STAGING_DIR)/DEBIAN$(ECHO_END)
