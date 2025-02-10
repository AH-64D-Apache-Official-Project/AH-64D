/* ----------------------------------------------------------------------------
Function: fza_cannon_fnc_eventFired

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

if !(["fza_m230", _weapon] call BIS_fnc_inString) exitwith {};
private _burstLimit = _heli getVariable "fza_ah64_burst_limit";
private _CannonFired = (_heli getVariable "fza_ah64_burst_fired") + 1;

if (_burstLimit != -1) then {
    if (_CannonFired >= _burstLimit) then {
        [_heli] spawn {
            params["_heli"];
            waitUntil {
                _heli selectWeaponTurret ["fza_cannon_limit", [0], "fza_cannon_limit"];
                inputAction "defaultAction" < 0.5
            };
            if (currentweapon _heli != "fza_cannon_limit") exitwith {};
            _heli selectWeaponTurret ["fza_m230", [0], "fza_m230"];
        };
    };
    _heli setVariable ["fza_ah64_burst_fired", _CannonFired];
};

//ACE3 OVERHEATING
//Author: Commy2 and esteldunedain
[_heli, "fza_m230", 3500] call ace_overheating_fnc_updateTemperature;
[_heli] call fza_cannon_fnc_update;