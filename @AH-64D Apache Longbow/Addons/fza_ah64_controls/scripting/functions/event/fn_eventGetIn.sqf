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

if (fza_ah64_showPopup && !fza_ah64_introShownThisScenario && _unit == player && cba_missiontime != 0) then {
    createDialog "RscFzaDisplayWelcome";
};

[_heli,[], 0, 1] call fza_mpd_fnc_drawIcons;
[_heli,[], 1, 1] call fza_mpd_fnc_drawIcons;