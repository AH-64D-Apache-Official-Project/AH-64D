/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_tsdPanDraw

Description:
    The PAN page's labels: the pan heading, the last POINT panned to, and the
    route's next and last waypoints from where the map is panned.

Parameters:
    _heli          - The helicopter
    _mpdIndex      - 0 left MPD, 1 right
    _state         - The TSD page's state
    _persistState  - The TSD's persistent state on that MPD

Returns:
    Nothing

Examples:
    --- Code
    _this call fza_mpd_fnc_tsdPanDraw
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_mpd\headers\mfdConstants.h"
params ["_heli", "_mpdIndex", "_state", "_persistState"];

private _heading = ([_heli, _persistState] call fza_mpd_fnc_tsdFrame) # 1;
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_PAN_HDG), [(round _heading) mod 360, 3] call CBA_fnc_formatNumber];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_PAN_POINT), _persistState getOrDefault ["panPoint", "?"]];

([_heli, _persistState] call fza_mpd_fnc_tsdPanRoute) params ["_ids", "", "_distances", "_along"];
private _next = _distances findIf {_x > _along + 1};
private _last = -1;
{
    if (_x < _along - 1) then {_last = _forEachIndex};
} forEach _distances;
private _name = {
    params ["_index"];
    if (_index < 0) exitWith {""};
    (_ids # _index) call fza_dms_fnc_pointToString
};
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_PAN_NEXT_WPT), [_next] call _name];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_PAN_LAST_WPT), [_last] call _name];
