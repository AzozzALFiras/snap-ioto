ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:13.0
ADDITIONAL_OBJCFLAGS = -fobjc-exceptions
GO_EASY_ON_ME = 1
INSTALL_TARGET_PROCESSES = Snapchat

loader:
	cd loader && $(MAKE) clean package install

LIBRARY_NAME = null
null_FRAMEWORKS = Foundation UIKit
null_FILES = hashmap.mm relic.mm

SUBPROJECTS += loader

null_LIBRARIES = substrate

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/library.mk
