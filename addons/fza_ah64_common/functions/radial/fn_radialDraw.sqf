/* ----------------------------------------------------------------------------
Function: fza_fnc_radialDraw

Description:
    onDraw of the radial menu's canvas: the sectors left by
    fza_fnc_radialUpdate, the one pointed at brighter, the selected ones green,
    and the stick's dwell filling its sector from the inside out.

Parameters:
    _ctrl - The canvas map control (covers the screen)

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "radial.hpp"
params ["_ctrl"];

// Kept far off the map, so it draws none of it
_ctrl ctrlMapAnimAdd [0, 0.001, [-999999, -999999]];
ctrlMapAnimCommit _ctrl;

private _display = ctrlParent _ctrl;
private _items = _display getVariable ["fza_radialItems", []];
if (_items isEqualTo []) exitWith {};
private _hover = _display getVariable ["fza_radialHover", RADIAL_NONE];
(_display getVariable ["fza_radialDwell", [RADIAL_NONE, 0, 0]]) params ["_dwellIdx", "", "_progress"];

// Screen to map is linear; a point is a radius in screen heights and a bearing, 3D as drawPolygon needs
private _mc = _ctrl ctrlMapScreenToWorld [0.5, 0.5];
private _mb = _ctrl ctrlMapScreenToWorld [1, 1];
private _sx = ((_mb # 0) - (_mc # 0)) / 0.5;
private _sy = ((_mb # 1) - (_mc # 1)) / 0.5;
if (abs _sx < 1e-9 || {abs _sy < 1e-9}) exitWith {};
private _k = pixelW / pixelH;
private _point = {
    params ["_r", "_b"];
    [(_mc # 0) + _sx * _k * _r * sin _b, (_mc # 1) - _sy * _r * cos _b, 0]
};

// Triangles of a ring between two radii and bearings, and its outline
private _band = {
    params ["_r0", "_r1", "_from", "_to"];
    private _steps = ceil ((_to - _from) / 5) max 1;
    private _tris = [];
    private _outer = [];
    private _inner = [];
    for "_i" from 0 to _steps do {
        private _b = _from + (_to - _from) * _i / _steps;
        _outer pushBack ([_r1, _b] call _point);
        _inner pushBack ([_r0, _b] call _point);
    };
    for "_i" from 1 to _steps do {
        _tris append [_inner # (_i - 1), _outer # (_i - 1), _outer # _i, _inner # (_i - 1), _outer # _i, _inner # _i];
    };
    reverse _inner;
    [_tris, _outer + _inner]
};

// Half the gap between sectors (deg); where a sector meets one of another group, 2.5 times it
private _gap = 1.5;
private _kindAt = {
    params ["_bearing", "_edge", "_self"];
    private _i = _items findIf {_x isNotEqualTo _self && {abs ((((_x # _edge) - _bearing) mod 360 + 540) mod 360 - 180) < 0.01}};
    if (_i == -1) then {""} else {(_items # _i) param [6, "sensor"]}
};
{
    _x params ["", "_from", "_to", "_enabled", "_active", "", ["_kind", "sensor"]];
    private _kindBefore = [_from, 2, _x] call _kindAt;
    private _kindAfter  = [_to, 1, _x] call _kindAt;
    private _gapFrom = [_gap, 2.5 * _gap] select (_kindBefore != "" && {_kindBefore != _kind});
    private _gapTo   = [_gap, 2.5 * _gap] select (_kindAfter != "" && {_kindAfter != _kind});
    private _hovered = _forEachIndex == _hover && _enabled;
    ([RADIAL_R_IN, RADIAL_R_OUT, _from + _gapFrom, _to - _gapTo] call _band) params ["_tris", "_outline"];
    private _fill = switch (true) do {
        case (!_enabled): {[0.05, 0.05, 0.05, 0.45]};
        case (_hovered && _active): {[0.2, 0.6, 0.2, 0.85]};
        case (_hovered): {[0.15, 0.25, 0.15, 0.85]};
        case (_active): {[0.1, 0.4, 0.1, 0.8]};
        default {[0.03, 0.06, 0.03, 0.7]};
    };
    _ctrl drawTriangle [_tris, _fill, RADIAL_FILL];
    if (_forEachIndex == _dwellIdx && {_progress > 0}) then {
        ([RADIAL_R_IN, RADIAL_R_IN + (RADIAL_R_OUT - RADIAL_R_IN) * _progress, _from + _gapFrom, _to - _gapTo] call _band) params ["_dwellTris"];
        _ctrl drawTriangle [_dwellTris, [0.3, 1, 0.3, 0.6], RADIAL_FILL];
    };
    _ctrl drawPolygon [_outline, [[0.3, 0.6, 0.3, 0.6], [0.4, 1, 0.4, 1]] select _hovered];
} forEach _items;

// Hub
private _hubTris = [];
private _hubOutline = [];
private _centre = [0, 0] call _point;
for "_b" from 0 to 360 step 15 do {_hubOutline pushBack ([RADIAL_R_HUB, _b] call _point)};
for "_i" from 1 to (count _hubOutline - 1) do {_hubTris append [_centre, _hubOutline # (_i - 1), _hubOutline # _i]};
_ctrl drawTriangle [_hubTris, [[0.03, 0.06, 0.03, 0.7], [0.15, 0.25, 0.15, 0.85]] select (_hover == RADIAL_HUB), RADIAL_FILL];
_ctrl drawPolygon [_hubOutline, [[0.3, 0.6, 0.3, 0.6], [0.4, 1, 0.4, 1]] select (_hover == RADIAL_HUB)];
// In a sub menu, the line between its name and BACK (fza_fnc_radialSetMenu)
if ((_display getVariable ["fza_radialMenu", "top"]) != "top") then {
    _ctrl drawLine [[0.8 * RADIAL_R_HUB, 270] call _point, [0.8 * RADIAL_R_HUB, 90] call _point, [0.4, 1, 0.4, 1]];
};
