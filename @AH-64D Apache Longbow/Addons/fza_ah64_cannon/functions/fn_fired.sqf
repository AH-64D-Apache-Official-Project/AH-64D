/* ----------------------------------------------------------------------------
Function: fza_fnc_eventFired

Description:
    Event handler that handles any ammunition fired by the apache

    - Ensures correct number of rockets fired in salvo
    - Damages people holding on external stores if pylons fired
    - Checks for gun overheat

Parameters:
    Schema of the "fired" event handler.

Returns:
    Nothing

Examples:

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params["_heli", "_weapon", "_muzzle", "_mode", "_ammotype", "_magazine", "_missobj"];

if !(_weapon == "fza_m230") exitwith {};

//burstLimit
private _burstLimit = _heli getVariable "fza_ah64_burst_limit";
private _CannonFired = (_heli getVariable "fza_ah64_burst_fired") + 1;
private _trigger = _heli getVariable "fza_ah64_trigger";

if (_burstLimit != -1) then {
    if (_CannonFired >= _burstLimit) then {
        _heli selectweapon "fza_burstlimiter";
        [_heli] spawn {
            params["_heli"];
            waitUntil {(_heli getVariable "fza_ah64_trigger") == false};
            if (currentweapon _heli != "fza_burstlimiter") exitwith {};
            _heli selectWeapon "fza_m230";
        };
        _CannonFired = 0;
    };
    _heli setVariable ["fza_ah64_burst_fired", _CannonFired];
};