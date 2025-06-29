/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_TurretAim

Description:
    Points turrets, sensors and weaponry at the correct positions according to acquisition sources.

Parameters:
    _heli - the heli to fix the turret for.

Returns:
    Nothing

Examples:
    [_heli] call fza_weapons_fnc_TurretAim

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_systems\headers\systems.hpp"
#include "\fza_ah64_sfmplus\headers\core.hpp"
params["_heli"];

#define WEP_TYPE(_mag) (if ((_mag) == "") then {""} else {getText (configFile >> "cfgMagazines" >> (_mag) >> "fza_pylonType")})

private _currentTurret = _heli call fza_fnc_currentTurret;
private _gunnnerUnit = _heli turretUnit [0];
if (_currentTurret isnotEqualTo [0] && (isplayer _gunnnerUnit)) exitwith {};

private _azimuth = -deg(_heli animationPhase "tads_tur");
private _elevation = deg(_heli animationPhase "tads");
_heli setVariable ["fza_ah64_tadsAzimuth",   _azimuth];
_heli setVariable ["fza_ah64_tadsElevation", _elevation];

if (isMultiplayer && (_heli getVariable "fza_ah64_lastTimePropagated") + 0.1 < time) then {
    {
        _heli setVariable [_x, _heli getVariable _x, true];
    } forEach [
        "fza_ah64_tadsAzimuth",
        "fza_ah64_tadsElevation"
    ];
_heli setVariable ["fza_ah64_lastTimePropagated", time, true];
};

private _pylonMagazines  = getPylonMagazines _heli;
private _firstPylonMags  = [_pylonMagazines#0,_pylonMagazines#4,_pylonMagazines#8,_pylonMagazines#12];

for "_i" from 0 to 3 do {
    if (WEP_TYPE(_firstPylonMags#_i) == "auxTank") then {
        _pylon = "pylon" + str(_i + 1);
        [_heli, _pylon, +4] call fza_fnc_updateAnimations;
    };
};