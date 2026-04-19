/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_init

Description:
    Initialize public variables on mission startup
    To set up information accessible by all crew members

Parameters:
    _heli - the helicopter upon which to execute the code

Returns:
    Nothing

Examples:
    [_heli] call fza_weapons_fnc_init

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

if (!(_heli getVariable ["fza_ah64_weaponsInitialised", false]) && local _heli) then {
    _heli setVariable ["fza_ah64_weaponsInitialised", true, true];

    _heli selectWeaponTurret ["fza_ma_safe", [0], "fza_ma_safe"];

    _heli setVariable ["fza_ah64_weaponInhibited", "", true];
    _heli setVariable ["fza_ah64_rocketsalvo",      2, true];
    _heli setVariable ["fza_ah64_salvoFired",       0, true];
    _heli setVariable ["fza_ah64_rocketPylonElev",  0, true];

    private _rockets = weapons _heli select {_x isKindOf ["fza_hydra70", configFile >> "CfgWeapons"]};
    _heli setVariable ["fza_ah64_selectedRocket", ["", _rockets # 0] select (_rockets isNotEqualTo []), true];
    private _missiles = weapons _heli select {_x isKindOf ["fza_hellfire", configFile >> "CfgWeapons"]};
    _heli setVariable ["fza_ah64_selectedMissile", ["", _missiles # 0] select (_missiles isNotEqualTo []), true];
    _heli setVariable ["fza_ah64_was", WAS_WEAPON_NONE, true];
};
