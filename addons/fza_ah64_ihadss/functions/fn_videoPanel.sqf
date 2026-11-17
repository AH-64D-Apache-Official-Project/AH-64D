/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_videoPanel

Description:
    A crew station's video controls: the pilot's VIDEO panel, the CPG's
    equivalent. [IHADSS BRT, IHADSS CON, SYM BRT, FLIR LVL, FLIR GAIN, ACM]
    (VIDEO_PANEL_* indices), knobs 0-1, ACM 1 on.

Parameters:
    _heli - The helicopter
    _seat - "plt" or "cpg", the local crew station's (the pilot's when not crew) when omitted

Returns:
    The settings, a copy

Examples:
    --- Code
    ([_heli] call fza_ihadss_fnc_videoPanel) # VIDEO_PANEL_SYM_BRT
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", ["_seat", ""]];

if (_seat == "") then {
    _seat = [_heli] call fza_fnc_getSeat;
    if (isNil "_seat") then {_seat = "plt"};
};
private _panel = _heli getVariable ["fza_ihadss_videoPanel_" + _seat, []];
if !(_panel isEqualTypeArray VIDEO_PANEL_DEFAULT) exitWith {+VIDEO_PANEL_DEFAULT};
+_panel
