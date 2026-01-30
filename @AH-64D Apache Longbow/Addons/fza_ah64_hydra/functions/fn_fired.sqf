/* ----------------------------------------------------------------------------
Function: fza_hydra_fnc_fired

Description:

Parameters:
    Schema of the "fired" event handler.

Returns:
    Nothing

Examples:

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params["_heli", "_weapon", "_muzzle", "_mode", "_ammotype", "_magazine", "_missobj"];

if !(["fza_275_", _weapon] call BIS_fnc_inString) exitwith {};
private _salvofired = (_heli getVariable "fza_ah64_salvofired") + 1;
private _rocketsalvo = _heli getVariable "fza_ah64_rocketsalvo";

if (_rocketsalvo != 99) then {
    if (_salvofired >= _rocketsalvo) then {
        [_heli,_weapon] spawn {
            params["_heli","_weapon"];
            waitUntil {
                _heli selectWeaponTurret ["fza_hydra_limit", [0], "fza_hydra_limit"];
                inputAction "defaultAction" < 0.5
            };
            if (currentweapon _heli != "fza_hydra_limit") exitwith {};
            _heli selectWeaponTurret [_weapon, [0], _weapon];;
        };
    };
    _heli setVariable ["fza_ah64_salvofired", _salvofired];
};