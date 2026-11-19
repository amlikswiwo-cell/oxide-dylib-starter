ARCHS = arm64
TARGET = iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES =

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = OxideOverlayStarter
OxideOverlayStarter_FILES = Tweak.xm OverlayMenu.m
OxideOverlayStarter_FRAMEWORKS = UIKit
OxideOverlayStarter_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
