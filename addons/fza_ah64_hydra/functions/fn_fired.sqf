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

if !(["fza_275_", _weapon] call BIS_fnc_inString) exitWith {};

// RTOF: the time until the last volley launched arrives, estimated from the solution at its first rocket.
// A volley's rockets leave 0.09 s apart. Set by the crewmember who fired (fza_fnc_eventFired), once for the whole crew.
if (time - (_heli getVariable ["fza_hydra_lastFired", -1]) > 0.3) then {
    _heli setVariable ["fza_ah64_rocketTofEnd", CBA_missionTime + (_heli getVariable ["fza_ah64_rocketSolutionTof", 0]), true];
};
_heli setVariable ["fza_hydra_lastFired", time];

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
            if (currentWeapon _heli != "fza_hydra_limit") exitWith {};
            _heli selectWeaponTurret [_weapon, [0], _weapon];;
        };
    };
    _heli setVariable ["fza_ah64_salvofired", _salvofired];
};
