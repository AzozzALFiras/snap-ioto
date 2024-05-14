ARCHS = arm64
TARGET = iphone:clang:latest:12.0
INSTALL_TARGET_PROCESSES = Snapchat
GO_EASY_ON_ME = 1
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = iota
iota_FILES = Tweak.xm $(wildcard interface/*/*.*m)
iota_CFLAGS += -fobjc-arc -Iinclude -Iinterface/Shadow -Iinterface/LocationPicker -Iinterface/RainbowRoad -Iinterface/XLLogger
iota_CFLAGS += -Wno-arc-performSelector-leaks -Wno-format-security -Wno-unused-function -Wno-unused-variable -Wno-deprecated-declarations
iota_CFLAGS += -DIOTA_VERSION='"2.2"'
iota_CFLAGS += -DIOTA_PROJECT='"iota"'
iota_CFLAGS += -DNULL_PROJECT='"null"'
iota_CFLAGS += -DNULL_VERSION='"1.1"'
iota_EXTRA_FRAMEWORKS := CoreGraphics AssetsLibrary UIKit AVKit CoreFoundation QuartzCore MobileCoreServices AVFoundation CoreLocation MapKit
iota_CODESIGN_FLAGS=-Sentitlements.xml
include $(THEOS_MAKE_PATH)/tweak.mk