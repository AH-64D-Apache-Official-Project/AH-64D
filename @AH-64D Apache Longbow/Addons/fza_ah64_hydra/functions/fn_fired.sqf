/* ----------------------------------------------------------------------------
Function: fza_hydra_fnc_fired

Description:

Parameters:
    _heli - the helicopter

Returns:
    Nothing

Examples:

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params["_heli", "_weapon", "_muzzle", "_mode", "_ammotype", "_magazine", "_missobj"];

private _currentWeaponRkt = (_weapon isKindOf ["fza_hydra70", configFile >> "CfgWeapons"]);
private _salvofired = (_heli getVariable "fza_ah64_salvofired") + 1;
private _rocketsalvo = _heli getVariable "fza_ah64_rocketsalvo";

if !_currentWeaponRkt exitwith {};

if (_rocketsalvo != 1) then {
    if (_salvofired >= _rocketsalvo || _heli ammo _weapon <= 0) exitwith {
        _salvofired = 0;
    };
    if (currentWeapon _heli == _weapon) then {
        [_heli] spawn {
            params["_heli"];
            sleep 0.09;
            private _trigger = _heli getVariable "fza_ah64_trigger";
            if !_trigger exitwith {
                _heli setVariable ["fza_ah64_salvofired", 0];
            };
            [_heli, "fza_275_m151_wep"] call BIS_fnc_fire
        };
    };
};

_heli setVariable ["fza_ah64_salvofired", _salvofired];