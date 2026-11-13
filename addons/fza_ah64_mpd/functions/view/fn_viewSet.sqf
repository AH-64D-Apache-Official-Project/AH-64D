/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_viewSet

Description:
    Sets one of the local crew station's MPD BRT or DAY/NIGHT/MONO knobs.
    Shared, as MONO on either crew station's MPD turns that side of both
    green.

Parameters:
    _heli  - The helicopter
    _side  - The MPD, 0 left or 1 right
    _index - MPD_VIEW_BRT or MPD_VIEW_MODE
    _value - BRT 0-1, or MPD_MODE_DAY, MPD_MODE_NIGHT or MPD_MODE_MONO

Returns:
    Nothing

Examples:
    --- Code
    [_heli, 0, MPD_VIEW_MODE, MPD_MODE_NIGHT] call fza_mpd_fnc_viewSet
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_mpd\headers\mfdConstants.h"
params ["_heli", "_side", "_index", "_value"];

private _seat = [_heli] call fza_fnc_getSeat;
if (isNil "_seat" || {!(_index in [MPD_VIEW_BRT, MPD_VIEW_MODE])}) exitWith {};

_value = if (_index == MPD_VIEW_BRT) then {_value max 0 min 1} else {(round _value) max MPD_MODE_DAY min MPD_MODE_MONO};
private _view = [_heli, _seat, _side] call fza_mpd_fnc_viewState;
if ((_view # _index) == _value) exitWith {};
_view set [_index, _value];
_heli setVariable [format ["fza_mpd_view_%1_%2", _seat, _side], _view, true];
