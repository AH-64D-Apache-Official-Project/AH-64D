/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_pylonController

Description:
    Handles TADS sensor position propagation in MP, and aux tank pylon
    animations. Runs every draw3D frame. Only the authoritative seat
    (CPG when present, PLT when alone) updates shared variables.

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

#define WEP_TYPE(_mag) (if ((_mag) == "") then {""} else {getText (configFile >> "cfgMagazines" >> (_mag) >> "fza_pylonType")})

// Only the machine that owns the vehicle updates shared state
if !(local _heli) exitWith {};

// Read TADS animation phases and store as heli variables
private _azimuth   = -deg (_heli animationPhase "tads_tur");
private _elevation =  deg (_heli animationPhase "tads");
_heli setVariable ["fza_ah64_tadsAzimuth",   _azimuth];
_heli setVariable ["fza_ah64_tadsElevation", _elevation];

// Broadcast TADS sensor position to other machines in MP every 100 ms
if (isMultiplayer && (_heli getVariable "fza_ah64_lastTimePropagated") + 0.1 < time) then {
    {
        _heli setVariable [_x, _heli getVariable _x, true];
    } forEach ["fza_ah64_tadsAzimuth", "fza_ah64_tadsElevation"];
    _heli setVariable ["fza_ah64_lastTimePropagated", time, true];
};

// Aux tank pylon animations - keep at +4 deg stow angle
private _pylonMagazines = getPylonMagazines _heli;
private _firstPylonMags = [_pylonMagazines # 0, _pylonMagazines # 4, _pylonMagazines # 8, _pylonMagazines # 12];
for "_i" from 0 to 3 do {
    if (WEP_TYPE(_firstPylonMags # _i) == "auxTank") then {
        private _pylon = "pylon" + str (_i + 1);
        [_heli, _pylon, +4] call fza_fnc_updateAnimations;
    };
};
