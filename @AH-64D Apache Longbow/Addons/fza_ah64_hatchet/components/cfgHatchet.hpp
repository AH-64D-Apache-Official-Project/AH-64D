#include "\x\cba\addons\main\script_macros_common.hpp"
#include "\fza_ah64_mpd\headers\mpd_defines.hpp"

#define MfdHandleFunction(var1, var2, var3, fnc) [ARR_3(var1, QUOTE(var2), QUOTE(var3))] call fnc

#define CfgButtonDown(className, Mempoint, Text, Distance, Code, Audio) \
class className {\
    positionType = "static";\
    position = Mempoint;\
    label = Text;\
    radius = Distance;\
    buttonDown = Code;\
    clickSound = Audio;\
};\

#define CfgButtonUp(className, Mempoint, Text, Distance, Code, Audio) \
class className {\
    positionType = "static";\
    position = Mempoint;\
    label = Text;\
    radius = Distance;\
    buttonUp = Code;\
    clickSound = Audio;\
};\

#define CfgButtonDownConditions(className, Condition, Mempoint, Text, Distance, Code, Audio) \
class className {\
    condition = Condition;\
    positionType = "static";\
    position = Mempoint;\
    label = Text;\
    radius = Distance;\
    buttonDown = Code;\
    clickSound = Audio;\
};\

#define CfgButtonUpConditions(className, Condition, Mempoint, Text, Distance, Code, Audio) \
class className {\
    condition = Condition;\
    positionType = "static";\
    position = Mempoint;\
    label = Text;\
    radius = Distance;\
    buttonUp = Code;\
    clickSound = Audio;\
};\


#define CfgSwitch(className, Mempoint, Text, animationName, Distance, States, StatesLabel, Code, Code2, Audio) \
class className {\
    positionType = "anim";\
    position = Mempoint;\
    label = Text;\
    animation = animationName;\
    animStates[] = {States};\
    animLabels[] = {StatesLabel};\
    radius = Distance;\
    animend = Code;\
    buttonDown = Code2;\
    clickSound = Audio;\
};\
