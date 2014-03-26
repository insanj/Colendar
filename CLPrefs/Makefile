TARGET =: clang
ARCHS = armv7 armv7 arm64

include theos/makefiles/common.mk

BUNDLE_NAME = CLPrefs
CLPrefs_FILES = CLPrefs.xm
CLPrefs_INSTALL_PATH = /Library/PreferenceBundles
CLPrefs_FRAMEWORKS = UIKit Twitter CoreGraphics QuartzCore
CLPrefs_PRIVATE_FRAMEWORKS = Preferences BulletinBoard
CLPrefs_LDFLAGS = -lsubstrate
CLPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/CLPrefs.plist$(ECHO_END)
