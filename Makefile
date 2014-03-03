THEOS_PACKAGE_DIR_NAME = debs
TARGET =: clang
ARCHS = armv7 arm64
include theos/makefiles/common.mk

BUNDLE_NAME = Colendar
Colendar_FILES = Colendar.xm
Colendar_INSTALL_PATH = /Library/PreferenceBundles
Colendar_FRAMEWORKS = UIKit Twitter CoreGraphics MessageUI
Colendar_PRIVATE_FRAMEWORKS = Preferences BulletinBoard

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/CLPrefs.plist$(ECHO_END)

internal-after-install::
	install.exec "killall -9 backboardd"
