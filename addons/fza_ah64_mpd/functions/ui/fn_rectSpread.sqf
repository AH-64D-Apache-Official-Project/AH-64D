/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_rectSpread

Description:
    Places symbols on a rectangle round a centre that need not be its middle, each where its bearing from the centre
    meets the rectangle (fza_mpd_fnc_bearingToScreen), spread apart by distance along the rectangle's edge, in bearing
    order, so they are as far apart near the centre as away from it. A distance round the edge is taken as an angle,
    so it spreads as a ring does (fza_mpd_fnc_spreadBearings).

Parameters:
    _bearings - bearings from the centre, deg
    _ctr      - [x, y], the centre
    _rect     - [min x, max x, min y, max y]
    _gap      - least distance between two symbols along the edge, MPD units

Returns:
    [[x, y], ...] in the order given

Examples:
    [[0, 5, 170], [0.5, 0.75], [0.23, 0.77, 0.23, 0.77], 0.07] call fza_mpd_fnc_rectSpread

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_bearings", "_ctr", "_rect", "_gap"];
_ctr params ["_cx", "_cy"];
_rect params ["_x0", "_x1", "_y0", "_y1"];

private _w   = _x1 - _x0;
private _h   = _y1 - _y0;
private _per = 2 * (_w + _h);
// Clockwise from the top edge straight ahead of the centre: its right part, the right edge, the bottom, the left edge,
// the top's left part
private _top = _x1 - _cx;
private _angles = _bearings apply {
    ([_cx, _cy, _x0, _x1, _y0, _y1, _x] call fza_mpd_fnc_bearingToScreen) params ["_px", "_py"];
    private _edges = [abs (_py - _y0), abs (_px - _x1), abs (_py - _y1), abs (_px - _x0)];
    private _edge  = _edges find selectMin _edges;
    private _len = switch (_edge) do {
        case 0: {[_px - _cx, _top + 2 * _h + _w + (_px - _x0)] select (_px < _cx)};
        case 1: {_top + (_py - _y0)};
        case 2: {_top + _h + (_x1 - _px)};
        default {_top + _h + _w + (_y1 - _py)};
    };
    _len / _per * 360
};

([_angles, _gap / _per * 360] call fza_mpd_fnc_spreadBearings) apply {
    private _len = ((_x % 360) + 360) % 360 / 360 * _per;
    switch (true) do {
        case (_len <= _top):                {[_cx + _len, _y0]};
        case (_len <= _top + _h):           {[_x1, _y0 + (_len - _top)]};
        case (_len <= _top + _h + _w):      {[_x1 - (_len - _top - _h), _y1]};
        case (_len <= _top + 2 * _h + _w):  {[_x0, _y1 - (_len - _top - _h - _w)]};
        default                             {[_x0 + (_len - _top - 2 * _h - _w), _y0]};
    }
}
