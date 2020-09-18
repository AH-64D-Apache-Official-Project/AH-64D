/* ----------------------------------------------------------------------------
Function: fza_fnc_eventGetIn

Description:
    Event handler that sets up apache when someone gets inside.

Parameters:
    _heli - the helicopter to modify

Returns:
	Nothing

Examples:

Author:
	unknown
---------------------------------------------------------------------------- */
params ["_heli"];

if (player == driver _heli) then {
    fza_ah64_hfmode = _heli;
};