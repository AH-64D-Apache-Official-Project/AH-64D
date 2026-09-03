/* ----------------------------------------------------------------------------
Function: fza_systems_fnc_interactBattSwitch

Description:
    Sets button state for the APU sim.

Parameters:
    _heli   - The helicopter to get information from [Unit].

Returns:
    Whether to register a click (boolean).

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

private _state = !(_heli getVariable "fza_systems_battSwitchOn");
_heli setVariable ["fza_systems_battSwitchOn", _state, true];

//- Fire up GlobalEvent
["fza_audio_updateBatt_State", [_heli, _state]] call CBA_fnc_GlobalEvent;
