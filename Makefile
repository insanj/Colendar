THEOS_PACKAGE_DIR_NAME = debs
TARGET =: clang
ARCHS = armv7 armv7s arm64

include theos/makefiles/common.mk

TWEAK_NAME = Colendar
Colendar_FILES = Colendar.xm
Colendar_FRAMEWORKS = UIKit CoreGraphics
Colendar_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += CLPrefs
include $(THEOS_MAKE_PATH)/aggregate.mk

after-stage::
	find $(THEOS_STAGING_DIR) -iname \*.plist -exec plutil -convert binary1 {} \;

internal-after-install::
	install.exec "killall -9 backboardd"
