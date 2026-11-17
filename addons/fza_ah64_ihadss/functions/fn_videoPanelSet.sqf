/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_videoPanelSet

Description:
    Sets one of the local crew station's video controls
    (fza_ihadss_fnc_videoPanel).

Parameters:
    _heli  - The helicopter
    _index - A VIDEO_PANEL_* index
    _value - A knob 0-1, or ACM 0/1

Returns:
    Nothing

Examples:
    --- Code
    [_heli, VIDEO_PANEL_ACM, 0] call fza_ihadss_fnc_videoPanelSet
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_index", "_value"];

private _seat = [_heli] call fza_fnc_getSeat;
if (isNil "_seat" || {_index < VIDEO_PANEL_IHADSS_BRT || {_index > VIDEO_PANEL_ACM}}) exitWith {};

_value = if (_index == VIDEO_PANEL_ACM) then {[0, 1] select (_value > 0)} else {_value max 0 min 1};
private _panel = [_heli, _seat] call fza_ihadss_fnc_videoPanel;
if ((_panel # _index) == _value) exitWith {};
_panel set [_index, _value];
_heli setVariable ["fza_ihadss_videoPanel_" + _seat, _panel, true];
