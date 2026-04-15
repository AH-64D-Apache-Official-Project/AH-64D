#include "\fza_ah64_mpd\headers\mpd_defines.hpp"

#define MFD_HANDLE_FUNCTION(var1, var2, var3, fnc) [ARR_3(var1, QUOTE(var2), QUOTE(var3))] call fnc

#define CFG_BUTTON_DOWN(className, Mempoint, Text, Distance, Code, Audio) \
class className {\
    positionType = "static";\
    position = Mempoint;\
    label = Text;\
    radius = Distance;\
    buttonDown = QUOTE(Code);\
    clickSound = Audio;\
}\

#define CFG_BUTTON_UP(className, Mempoint, Text, Distance, Code, Audio) \
class className {\
    positionType = "static";\
    position = Mempoint;\
    label = Text;\
    radius = Distance;\
    buttonUp = QUOTE(Code);\
    clickSound = Audio;\
}\

#define CFG_BUTTON_DOWN_CONDITIONS(className, Condition, Mempoint, Text, Distance, Code, Audio) \
class className {\
    condition = QUOTE(Condition);\
    positionType = "static";\
    position = Mempoint;\
    label = Text;\
    radius = Distance;\
    buttonDown = QUOTE(Code);\
    clickSound = Audio;\
}\

#define CFG_BUTTON_UP_CONDITIONS(className, Condition, Mempoint, Text, Distance, Code, Audio) \
class className {\
    condition = QUOTE(Condition);\
    positionType = "static";\
    position = Mempoint;\
    label = Text;\
    radius = Distance;\
    buttonUp = QUOTE(Code);\
    clickSound = Audio;\
}\


#define CFG_SWITCH(className, Mempoint, Text, animationName, Distance, States, StatesLabel, Code, Code2, Audio) \
class className {\
    positionType = "anim";\
    position = Mempoint;\
    label = Text;\
    animation = animationName;\
    animStates[] = {States};\
    animLabels[] = {StatesLabel};\
    radius = Distance;\
    animend = QUOTE(Code);\
    buttonDown = QUOTE(Code2);\
    clickSound = Audio;\
}\
