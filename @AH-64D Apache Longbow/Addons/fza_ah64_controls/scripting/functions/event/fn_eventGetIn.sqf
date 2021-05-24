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
params ["_heli", "", "_unit"];

if (fza_ah64_showPopup && !fza_ah64_introShownThisScenario && _unit == player) then {
    createDialog "RscFzaDisplayWelcome";
}