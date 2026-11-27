/* ----------------------------------------------------------------------------
Function: fza_mplanner_fnc_pageEvent

Description:
    Sends an event to the planner page, when the planner is open. The page shows
    the planner's messages itself, as chat can be turned off on a server.

Parameters:
    _event - HashMap with a "type" key and that type's fields

Returns:
    true when the planner is open

Examples:
    [createHashMapFromArray [["type", "notice"], ["text", "Saved."]]] call fza_mplanner_fnc_pageEvent

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
disableSerialization;
params [["_event", createHashMap, [createHashMap]]];

private _display = uiNamespace getVariable ["fza_mplanner_display", displayNull];
if (isNull _display) exitWith {false};

[_display displayCtrl 100, "window.fza_mplanner_event && window.fza_mplanner_event(" + toJSON _event + ");"] call fza_mpd_fnc_execJs;
true
