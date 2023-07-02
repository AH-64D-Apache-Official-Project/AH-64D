#include "\fza_ah64_ihadss\headers\dimensions.h"
params ["_xTheta", "_yTheta"];

private _xTheta = [_xTheta,-SYMB_DEG_MAX_X,SYMB_DEG_MAX_X] call BIS_fnc_clamp;
private _yTheta = [_yTheta,-SYMB_DEG_MAX_X/4*3,SYMB_DEG_MAX_X/4*3] call BIS_fnc_clamp;

private _pos =
    [ SYMB_DEG_SCALING_FACTOR*_xTheta/4*3
    , SYMB_DEG_SCALING_FACTOR*_yTheta
    ];

[safeZoneX + safeZoneW/2, safeZoneY + safeZoneH/2] vectorAdd _pos;