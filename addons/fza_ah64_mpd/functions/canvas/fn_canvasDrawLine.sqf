#include "\fza_ah64_dms\headers\constants.h"
params
    [ "_heli"
    , "_canvas"
    , "_from"
    , "_to"
    , "_color"
    , ["_posMode", MPD_POSMODE_WORLD]
    , "_scale"
    , ["_heliCtr", [0.5, 0.75]]
    , ["_heading", direction (_this # 0)]
    , ["_heliPos", getPosASL (_this # 0)]
    , ["_width", 0.004]
    , ["_clip", []]
    ];

private ["_dir", "_length"];

_canvas params ["_canvasCtrl", "_canvasCenter", "_canvasVect"];
private _ctr = (_from vectorAdd _to) vectorMultiply 0.5;

if (_posMode) then {
    _ctr = [_heliPos, _heading, _scale, _heliCtr, _ctr] call fza_mpd_fnc_tsdWorldToScreen;

    _length = (_from distance2D _to) * _scale;

    _dir = (_from getDir _to) - _heading;
} else {
    _length = _from distance2D _to;
    _dir = (_from getDir _to);
};
// Cut to the clip, [left, top, right, bottom] in MPD units (the TSD's map): the line from its centre along _dir
if (_posMode && {_clip isNotEqualTo []}) then {
    _clip params ["_left", "_top", "_right", "_bottom"];
    private _dx = sin _dir * _length;
    private _dy = -cos _dir * _length;
    private _x0 = (_ctr # 0) - _dx / 2;
    private _y0 = (_ctr # 1) - _dy / 2;
    private _t0 = 0;
    private _t1 = 1;
    {
        _x params ["_p", "_q"];
        if (_p == 0) then {
            if (_q < 0) then {_t0 = 2};
        } else {
            private _t = _q / _p;
            if (_p < 0) then {_t0 = _t0 max _t} else {_t1 = _t1 min _t};
        };
    } forEach [[-_dx, _x0 - _left], [_dx, _right - _x0], [-_dy, _y0 - _top], [_dy, _bottom - _y0]];
    _ctr = [_x0 + _dx * (_t0 + _t1) / 2, _y0 + _dy * (_t0 + _t1) / 2];
    _length = _length * ((_t1 - _t0) max 0);
};
if (_length <= 0) exitWith {};
_ctr = [_canvas, _ctr] call fza_mpd_fnc_canvasAdjust;
// Texture files the MPD display loads with itself (RscFzaAH64MPD)
private _fill = switch (true) do {
    case (_color isEqualTo [0, 1, 0, 1]): {"\fza_ah64_mpd\tex\canvas\line_green_ca.paa"};
    case (_color isEqualTo [1, 1, 1, 1]): {"\fza_ah64_mpd\tex\canvas\line_white_ca.paa"};
    default {format (["#(rgb,8,8,3)color(%1,%2,%3,%4)"] + _color)};
};
_canvasCtrl drawRectangle
    [ _ctr
    , (_width/2)* abs (_canvasVect#0)
    , (_length/2)* abs (_canvasVect#1)
    , _dir
    , [1,1,1,1]
    , _fill
    ];
