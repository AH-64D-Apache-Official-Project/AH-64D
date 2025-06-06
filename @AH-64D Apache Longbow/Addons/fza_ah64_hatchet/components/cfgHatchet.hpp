#include "\fza_ah64_hatchet\includes\script_macros_common.hpp"

#define MfdHandleFunction(var1, var2, var3, fnc) [ARR_3(var1, QUOTE(var2), QUOTE(var3))] call fnc

#define CfgStaticButtonDown(className, Mempoint, Text, Distance, Code, Audio) \
class className {\
    positionType = "static";\
    position = Mempoint;\
    label = Text;\
    radius = Distance;\
    buttonDown = Code;\
    clickSound = Audio;\
};\

#define CfgTwoStateSwitch(className, Mempoint, Text, animationName, State1, State2, State1Label, State2Label, Distance, Code, Audio) \
class className {\
    positionType = "anim";\
    position = Mempoint;\
    label = Text;\
    animation = animationName;\
    animStates[] = {State1, State2};\
    animLabels[] = {State1Label, State2Label};\
    radius = Distance;\
    animend = Code;\
    clickSound = Audio;\
};