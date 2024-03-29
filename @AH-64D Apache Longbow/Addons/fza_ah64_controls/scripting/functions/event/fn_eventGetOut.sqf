/* ----------------------------------------------------------------------------
Function: fza_fnc_eventGetOut

Description:
    Event handler that finishes parts of apache logic when someone gets out.

    Closes HUD UI

Parameters:
    _heli - the helicopter to modify

Returns:
    Nothing

Examples:

Author:
    unknown
---------------------------------------------------------------------------- */
params["_heli"];

[_heli] call fza_ihadss_fnc_controller;