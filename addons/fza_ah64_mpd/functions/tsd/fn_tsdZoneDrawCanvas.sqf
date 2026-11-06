#include "\fza_ah64_dms\headers\constants.h"
#include "\fza_ah64_mpd\headers\tsd.hpp"
params ["_heli", "_canvas", "_mpdIndex", "_state", "_persistState", "_framePos", "_frameHeading", "_scale", "_ctr"];

_ctr params ["_cx", "_cy"];
TSD_MAP_CLIP params ["_left", "_top", "_right", "_bottom"];
private _toScreen = {
    private _theta = (_framePos getDir _x) - _frameHeading;
    private _r = (_framePos distance2D _x) * _scale;
    [_cx + sin _theta * _r, _cy - cos _theta * _r]
};
private _draw = {
    params ["_pts", "_closed", "_color", ["_marquee", false]];
    private _screen = _pts apply _toScreen;
    private _xs = _screen apply {_x # 0};
    private _ys = _screen apply {_x # 1};
    if (selectMax _xs < _left || {selectMin _xs > _right} || {selectMax _ys < _top} || {selectMin _ys > _bottom}) exitWith {};
    private _dash = [[], [0.02, 0.012, diag_tickTime * -0.03]] select _marquee;
    [_canvas, _screen, _closed, _color, 0.004, TSD_MAP_CLIP, _dash] call fza_mpd_fnc_canvasDrawPolyline;
};

{
    _x params ["_pts", "_closed", "_color", "_marquee"];
    [_pts, _closed, _color, _marquee] call _draw;
} forEach (_state getOrDefault ["zoneItems", []]);

// The zone being drawn on ZN, out to the MPD cursor
if ((_state get "subPageVarPage") # 0 != 6) exitWith {};
if ((_state get "subPageVarPage") # 1 != 0) exitWith {};
(_state getOrDefault ["znDraft", []]) params [["_entries", []], "", ["_heading", _frameHeading]];
private _nf = _persistState getOrDefault ["znType", ZONE_KIND_PF] == ZONE_KIND_NF;
private _color = [[1, 1, 1, 1], [1, 1, 0, 1]] select _nf;
private _need = _state getOrDefault ["znNeed", 4];

// A drawn NF zone waits for OWN
if (_nf && {count _entries >= _need}) exitWith {
    private _quad = [_entries select [0, _need], _heading] call fza_mpd_fnc_tsdZNQuad;
    if (_quad isNotEqualTo []) then {[_quad, true, _color] call _draw};
};

// The zone being drawn: its corners so far, out to the MPD cursor
private _verts = _entries select [floor (count _entries / _need) * _need, count _entries mod _need];
private _cursor = _heli getVariable ["fza_mpd_cursor", []];
private _cursorPos = [];
if (_cursor param [0, -1] == _mpdIndex && {[_heli, _mpdIndex, _cursor # 1, _cursor # 2] call fza_mpd_fnc_cursorInArea}) then {
    _cursorPos = [_framePos, _frameHeading, _scale, _ctr, [_cursor # 1, _cursor # 2]] call fza_mpd_fnc_tsdScreenToWorld;
};
if (_cursorPos isEqualTo []) exitWith {
    if (count _verts > 1) then {[_verts, false, _color] call _draw};
};
switch (true) do {
    case (_need == 1): {
        {[_x, true, _color] call _draw} forEach ([_cursorPos, (_persistState getOrDefault ["znKm", 2]) * 1000, _heading] call fza_dms_fnc_zoneTrp);
    };
    case (_need == 2 && {count _verts == 1}): {
        [[_verts # 0, _cursorPos, _heading] call fza_dms_fnc_zoneBox, true, _color] call _draw;
    };
    case (count _verts > 0): {
        [_verts + [_cursorPos], count _verts > 1, _color] call _draw;
    };
};
