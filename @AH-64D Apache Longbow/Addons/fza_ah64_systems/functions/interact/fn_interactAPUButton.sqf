/* ----------------------------------------------------------------------------
Function: fza_systems_fnc_interactAPUButton

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

_heli setVariable ["fza_systems_apuBtnOn", !(_heli getVariable "fza_systems_apuBtnOn"), true];