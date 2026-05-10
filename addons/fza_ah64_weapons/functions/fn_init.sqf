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

    _heli selectWeaponTurret ["fza_ah64_trigger", [0]];
    _heli selectWeaponTurret ["fza_ah64_trigger", [-1]];

    _heli setVariable ["fza_ah64_gunInhibited",    "", true];
    _heli setVariable ["fza_ah64_rocketInhibit",   "", true];
    _heli setVariable ["fza_ah64_rocketsalvo",      2, true];
    _heli setVariable ["fza_ah64_rocketPylonElev",  0, true];
    _heli setVariable ["fza_ah64_tadsAzimuth",      0, true];
    _heli setVariable ["fza_ah64_tadsElevation",    0, true];
    _heli setVariable ["fza_ah64_sightData_plt", [[0,0,0],[0,0,0],0,""], true];
    _heli setVariable ["fza_ah64_sightData_cpg", [[0,0,0],[0,0,0],0,""], true];
    _heli setVariable ["fza_ah64_lastTimePropagated", 0];
    _heli setVariable ["fza_ah64_isFiringGun",  false, true];
    _heli setVariable ["fza_ah64_isFiringMsl",  false, true];
    _heli setVariable ["fza_ah64_isFiringRkt_plt", false, true];
    _heli setVariable ["fza_ah64_isFiringRkt_cpg", false, true];
    _heli setVariable ["fza_ah64_was_plt", WAS_WEAPON_NONE, true];
    _heli setVariable ["fza_ah64_was_cpg", WAS_WEAPON_NONE, true];
    _heli setVariable ["fza_ah64_burst_limit", 10, true];


    private _rockets = weapons _heli select {_x isKindOf ["fza_hydra70", configFile >> "CfgWeapons"]};
    _heli setVariable ["fza_ah64_selectedRocket", ["", _rockets # 0] select (_rockets isNotEqualTo []), true];
    private _missiles = weapons _heli select {_x isKindOf ["fza_hellfire", configFile >> "CfgWeapons"]};
    _heli setVariable ["fza_ah64_selectedMissile", ["", _missiles # 0] select (_missiles isNotEqualTo []), true];
    _heli setVariable ["fza_ah64_hellfireTrajectory", "DIR", true];
};
