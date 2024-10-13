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
    ];

private ["_ctr", "_dir", "_length"];

_canvas params ["_canvasCtrl", "_canvasCenter", "_canvasVect"];

if (_posMode == MPD_POSMODE_WORLD) then {
    private _ctrWorld = (_from vectorAdd _to) vectorMultiply 0.5;
    private _theta = [_heli, _heliPos # 0, _heliPos # 1,  _ctrWorld # 0, _ctrWorld # 1, _heading] call fza_fnc_relativeDirection;
    private _r = _heli distance2d _ctrWorld;
    _ctr =
        [ _heliCtr # 0 + sin _theta * (_r * _scale)
        , _heliCtr # 1 + sin _theta * (_r * _scale)];

    _length = (_from distance2D _to) * _scale;

    _dir = (_from getDir _to) - _heading;
} else {
    _ctr = (_from vectorAdd _to) vectorMultiply 0.5;
    _length = _from distance2D _to;
    _dir = (_from getDir _to);
};
_ctr = [_canvas, _ctr] call fza_ihadss_fnc_canvasAdjust;
_canvasCtrl drawRectangle
    [ _ctr
    , _length/2*vectorMagnitude _canvasVect
    , _width/2*vectorMagnitude _canvasVect
    , _dir
    , [1,1,1,1]
    , format (["#(rgb,8,8,3)color(%1,%2,%3,%4)"]+_color)
    ];