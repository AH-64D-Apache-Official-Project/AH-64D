#include "\x\cba\addons\main\script_macros_common.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE

#ifdef DEBUG_ENABLED_MAIN
    #define DEBUG_MODE_FULL
#endif
#ifdef DEBUG_SETTINGS_MAIN
    #define DEBUG_SETTINGS DEBUG_SETTINGS_MAIN
#endif

// #LINK - https://community.bistudio.com/wiki/Simple_Expression
//- Custom MACRO
#define FACTOR(A,X,Y) (A factor [X, Y])
#define INTERPOLATE(A,xFrom,xTo,resFrom,resTo) (A interpolate [xFrom,xTo,resFrom,resTo])

//- Volume Controller (Controller used for "Aaren's Volume Controller")
#define EXT_VOL_CONTROLLER (CustomSoundController14+1)
#define INT_VOL_CONTROLLER (CustomSoundController16+1)

// Controller15: Used when both power level is on IDLE/FLY. The value reflects proximity (IDLE: 0.66..., FLY: 0.72...).
// #define NG_CONTROLLER (1 min FACTOR(CustomSoundController15,0.67,0.7))
#define NG_CONTROLLER (CustomSoundController15)
#define NP_CONTROLLER (CustomSoundController17)
