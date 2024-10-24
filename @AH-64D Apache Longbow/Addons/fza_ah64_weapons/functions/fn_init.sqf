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

    _heli selectweapon "fza_ma_safe";

    _heli setVariable ["fza_ah64_weaponInhibited", "", true];
    _heli setVariable ["fza_ah64_rocketsalvo",      2, true];
    _heli setVariable ["fza_ah64_salvoFired",       0, true];
    _heli setVariable ["fza_ah64_RocketPylonElev",  0, true];

    private _rockets = weapons _heli select {_x isKindOf ["fza_hydra70", configFile >> "CfgWeapons"]};
    _heli setVariable ["fza_ah64_selectedRocket", ["", _rockets # 0] select (count _rockets > 0), true];
    private _missiles = weapons _heli select {_x isKindOf ["fza_hellfire", configFile >> "CfgWeapons"]};
    _heli setVariable ["fza_ah64_selectedMissile", ["", _missiles # 0] select (count _missiles > 0), true];
    _heli setVariable ["fza_ah64_was", WAS_WEAPON_NONE, true];
};

while {player != vehicle player && alive player && alive _heli && local _heli} do {
    //Fixes pylons that went onto the wrong turret (pilot, rather than gunner)
    if (local _heli) then { 
        { 
            _x params ["_pylId", "", "_pylTurr", "_pylMag", "_pylAmmo"]; 
            if (_pylTurr isNotEqualTo [0]) then { 
                _wep = configFile >> "CfgMagazines" >> _pylMag >> "pylonWeapon";
                if (isText _wep) then {
                    [[_heli, getText _wep, _pylTurr], { 
                        params["_heli", "_weapon", "_turret"]; 

                        _heli removeWeaponTurret [_weapon, _turret] 
                    }] remoteExec ["call", [driver _heli, _heli] select (isNull driver _heli)];
                };
                _heli setPylonLoadout [_pylId, _pylMag, true, [0]]; 
                _heli setAmmoOnPylon [_pylId, _pylAmmo]; 
            }; 
        } foreach getAllPylonsInfo _heli; 
    };
    sleep 5;
};