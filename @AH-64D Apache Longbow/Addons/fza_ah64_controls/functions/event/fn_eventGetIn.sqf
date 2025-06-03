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
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "", "_unit"];

if (player != _unit) exitwith {};
if (fza_ah64_showPopupv2_2 && !fza_ah64_introShownThisScenario && _unit == player && cba_missiontime != 0) then {
    createDialog "RscFzaDisplayWelcome";
};

[_heli,[], 0, 1] call fza_mpd_fnc_drawIcons;
[_heli,[], 1, 1] call fza_mpd_fnc_drawIcons;

[_heli] call fza_mpd_fnc_propagatePage;

//reset values
[_heli, "fza_ah64_sight", SIGHT_HMD] call fza_fnc_setSeatVariable;
_heli setVariable ["fza_ah64_ihadss_pnvs_cam", false];
_heli setVariable ["fza_ah64_monocleinbox", true];

fza_ah64_previousTime   = diag_tickTime;
fza_ah64_lastFrameGetIn = true;

_heli setVariable ["fza_sfmplus_previousTime", diag_tickTime];