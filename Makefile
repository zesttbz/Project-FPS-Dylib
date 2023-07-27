export THEOS=/home/luc1ner/theos


ARCHS = arm64 

DEBUG = 0
FINALPACKAGE = 1
FOR_RELEASE = 1



PROJ_COMMON_FRAMEWORKS = JRMemory UIKit Foundation


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = fps

fps_CFLAGS = -fobjc-arc
fps_CCFLAGS = -std=c++11 -fno-rtti -fno-exceptions -DNDEBUG

fps_FILES = FPSDisplay.m


fps_FRAMEWORKS = $(PROJ_COMMON_FRAMEWORKS)

include $(THEOS_MAKE_PATH)/tweak.mk