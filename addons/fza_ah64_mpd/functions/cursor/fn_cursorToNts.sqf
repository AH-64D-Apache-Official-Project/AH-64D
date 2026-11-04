/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_cursorToNts

Description:
    Places the crew station's MPD cursor on an FCR format's NTS button, so cursor
    enter selects the next target, when the first scan of a scan burst has
    completed and the crew station owns the FCR with it as its sight. Once a
    burst; the MPD the cursor is on is used if it shows an FCR format.

Parameters:
    _heli     - The helicopter
    _mpdIndex - The MPD showing the FCR format, 0 left, 1 right

Returns:
    Nothing

Examples:
    --- Code
    [_heli, _mpdIndex] call fza_mpd_fnc_cursorToNts
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_mpd\headers\mpd_defines.hpp"
params ["_heli", "_mpdIndex"];

if (FCR_OWNER(_heli) != ([_heli] call fza_fnc_getSeat) || {([_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable) != SIGHT_FCR}) exitWith {};

// The first scan of the burst has completed once the scan published is newer than the burst's start
(_heli getVariable ["fza_ah64_fcrState", [FCR_MODE_OFF, 0]]) params ["_mode", "_startTime"];
private _scanTime = (_heli getVariable ["fza_ah64_fcrLastScan", []]) param [2, -1];
if (_mode == FCR_MODE_OFF || {_scanTime < _startTime} || {_heli getVariable ["fza_mpd_ntsCueBurst", -1] == _startTime}) exitWith {};
_heli setVariable ["fza_mpd_ntsCueBurst", _startTime];

private _cursor = _heli getVariable "fza_mpd_cursor";
if (isNil "_cursor") exitWith {};
private _side = _mpdIndex;
if ((toLower ([_heli, _cursor # 0] call fza_mpd_fnc_currentPage)) in ["fcr", "fcrrmap"]) then {_side = _cursor # 0};
// Inside the NTS label at L1
_cursor set [0, _side];
_cursor set [1, MPD_POS_BUTTON_L_X + 0.01];
_cursor set [2, MPD_POS_BUTTON_LR_1_Y + 0.02];
_cursor set [3, time];
_cursor set [7, -1];
