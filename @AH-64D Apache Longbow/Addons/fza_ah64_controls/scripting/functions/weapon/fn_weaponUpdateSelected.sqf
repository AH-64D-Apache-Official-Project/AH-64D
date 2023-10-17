/* ----------------------------------------------------------------------------
Function: fza_fnc_weaponUpdateSelected

Description:
    Sets the current selected weapon on the gunner's turret to match the settings the mod specifies

Parameters:
    _heli - The helicopter to update

Returns:

Examples:
    statement="[_heli] fza_fnc_weaponUpdateSelected

Author:
    
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params["_heli"];

private _curTurret = [_heli] call fza_fnc_currentTurret;
private _seatWas = [_heli] call fza_weapons_fnc_WeaponGetWas;
private _oSeatWas = [_heli] call fza_weapons_fnc_WeaponGetWas;

switch (_seatwas) do {
    case WAS_WEAPON_NONE: {
        _heli selectWeaponTurret ["fza_ma_safe",[_curTurret]];
    };
    case WAS_WEAPON_GUN: {
        if !(_heli getVariable "fza_ah64_armSafeArmed") exitwith {
            _heli selectWeaponTurret ["fza_gun_safe",[0]];
        };
        if !(isplayer gunner _heli) then {
            player action ["ManualFire", vehicle player];
        };
        _heli selectWeaponTurret ["fza_m230",[0]];
    };
    case WAS_WEAPON_RKT: {
        if !(_heli getVariable "fza_ah64_armSafeArmed") exitwith {
            _heli selectWeaponTurret ["fza_ma_safe",[0]];
        };
        if ((_curTurret in [[-1]] && _oSeatWas == WAS_WEAPON_RKT) || (_curTurret in [[0]] && _oSeatWas != WAS_WEAPON_RKT)) then {
            [_heli, _curTurret] call fza_weapons_fnc_pylonSetRocket;
        };
        private _selectedRocket = _heli getVariable "fza_ah64_selectedRocket";
        if (_selectedRocket != "") exitwith {
            _heli selectWeaponTurret [_selectedRocket,[_curTurret]];
        };
        private _rockets = weapons _heli select {_x isKindOf ["fza_hydra70", configFile >> "CfgWeapons"]};
        if (count _rockets > 0) exitwith {
            _heli setVariable ["fza_ah64_selectedRocket", _rockets # 0, true];
            _heli selectWeaponTurret [_rockets # 0,[_curTurret]];
        };
        _heli selectWeaponTurret ["fza_ma_safe",[_curTurret]];
    };
    case WAS_WEAPON_MSL: {
        if !(_heli getVariable "fza_ah64_armSafeArmed") exitwith {
            _heli selectWeaponTurret ["fza_ma_safe",[0]];
        };
        if (_oSeatWas == WAS_WEAPON_MSL) then {
            [_heli, WAS_WEAPON_NONE, true] call fza_fnc_weaponActionSwitch;
        };
        [_heli, _curTurret] call fza_weapons_fnc_pylonSethellfire;
        private _selectedMissile = _heli getVariable "fza_ah64_selectedMissile";
        if (_selectedMissile != "") exitwith {
            vehicle player selectWeaponTurret [_selectedMissile,[0],_selectedMissile];
        };
        private _missiles = weapons _heli select {_x isKindOf ["fza_hellfire", configFile >> "CfgWeapons"]};
        if (count _missiles > 0) exitwith {
            _heli setVariable ["fza_ah64_selectedMissile", _missiles # 0, true];
            vehicle player selectWeaponTurret [_missiles # 0,[0],_missiles # 0];
        };
        _heli selectWeaponTurret ["fza_ma_safe",[0]];
    };
};