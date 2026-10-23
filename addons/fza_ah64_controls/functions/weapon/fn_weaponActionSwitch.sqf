/* ----------------------------------------------------------------------------
Function: fza_fnc_weaponActionSwitch

Description:
    A crew station's weapon action switch (WAS). Each crew station writes only
    its own record, fza_ah64_wasRec_plt/_cpg: [weapon, time, weapon last taken,
    time last taken]. Every machine works out the aircraft's weapon and who
    holds it from the two (fza_fnc_wasUpdate): the last WAS wins, and both
    crew stations hold rockets together. WAS_WEAPON_NONE de-actions the crew
    station's weapon and is only sent when it holds one.

Parameters:
    _heli   - The helicopter to act upon
    _weapon - One of the WAS_WEAPON_xxx options in systemConstants
    _seat   - (optional, default player) The crew station, "plt"/"cpg" or a crew unit

Returns:
    Nothing

Examples:
    --- Code
    [_heli, WAS_WEAPON_GUN] call fza_fnc_weaponActionSwitch
    ---

Author:
    Mattysmith22, BradMick
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_weapon", ["_seat", player]];

_seat = [_heli, _seat] call fza_fnc_getSeat;
if (isNil "_seat") exitWith {};

private _var = "fza_ah64_wasRec_" + _seat;
(_heli getVariable [_var, [WAS_WEAPON_NONE, -1, WAS_WEAPON_NONE, -1]]) params ["_current", "", "_takeWeapon", "_takeTime"];

if (_weapon == WAS_WEAPON_NONE) then {
    if (_current != WAS_WEAPON_NONE) then {
        _heli setVariable [_var, [WAS_WEAPON_NONE, CBA_missionTime, _takeWeapon, _takeTime], true];
    };
} else {
    _heli setVariable [_var, [_weapon, CBA_missionTime, _weapon, CBA_missionTime], true];
};

[_heli] call fza_fnc_wasUpdate;
