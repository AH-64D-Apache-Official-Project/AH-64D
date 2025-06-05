/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_interactStartSwitch

Description:
    Sets start switch state for the engine sim.

Parameters:
    _heli   - The helicopter to get information from [Unit].
    _engNum - The desired engine.

Returns:
    Whether to register a click (boolean).

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_engNum", "_action"];

if (_heli getVariable "fza_ah64_rtrbrake") exitWith {};

		[_heli, "fza_sfmplus_engState", _engNum, _engState, true] call fza_fnc_setArrayVariable;
private _engState = _heli getVariable "fza_sfmplus_engState" select _engNum;

switch (_action) do {
    case "START": {
        if (_engState isEqualTo "OFF") exitWith {
            [_heli, "fza_sfmplus_engState", _engNum, "STARTING", true] call fza_fnc_setArrayVariable;
        };
        true;
    };
    case "IGN ORDIE": {
        if (_engState isEqualTo "STARTING") exitWith {
            [_heli, "fza_sfmplus_engState", _engNum, "OFF", true] call fza_fnc_setArrayVariable;
        };
        true;
    };
    default {
        false;
    };
};
