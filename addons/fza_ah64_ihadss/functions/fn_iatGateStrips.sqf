/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_iatGateStrips

Description:
    The IAT gates as filled strips in format units, from where a display
    projects them (fza_ihadss_fnc_iatGates): the four corners of a box about
    the target, drawn 3 units wide with no sides, small solid rectangles at
    the corners in stop mode, flashing while reacquiring.

Parameters:
    _heli - The helicopter
    _dx   - Gate centre from the reticle, format units, right
    _dy   - Gate centre from the reticle, format units, down
    _hw   - Gate half width, format units
    _hh   - Gate half height, format units

Returns:
    Strips [[x, y, w, h]] from the reticle in format units, [] while flashed off

Examples:
    --- Code
    private _strips = [_heli, _dx, _dy, _hw, _hh] call fza_ihadss_fnc_iatGateStrips;
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_dx", "_dy", "_hw", "_hh"];

private _state = (_heli getVariable ["fza_ah64_iat", IAT_IDLE]) # 0;
if (_state == IAT_COAST && {floor (diag_tickTime * 4) mod 2 == 1}) exitWith {[]};

_hw = (_hw min (IAT_GATE_MAX * 320)) max 8;
_hh = (_hh min (IAT_GATE_MAX * 320)) max 8;

// Corner arms, and the line width
private _arm   = ((_hw min _hh) * 0.5) max 6;
private _t     = 3;
private _solid = _state == IAT_STOP;
private _strips = [];
{
    _x params ["_sx", "_sy"];
    private _cx = _dx + _sx * _hw;
    private _cy = _dy + _sy * _hh;
    // From the corner's outer edge inwards
    private _x0 = if (_sx < 0) then {_cx - _t / 2} else {_cx + _t / 2 - _arm};
    private _y0 = if (_sy < 0) then {_cy - _t / 2} else {_cy + _t / 2 - _arm};
    if (_solid) then {
        private _box = _arm min 10;
        _strips pushBack [[_x0, _x0 + _arm - _box] select (_sx > 0), [_y0, _y0 + _arm - _box] select (_sy > 0), _box, _box];
    } else {
        _strips pushBack [_x0, _cy - _t / 2, _arm, _t];
        _strips pushBack [_cx - _t / 2, _y0, _t, _arm];
    };
} forEach [[-1, -1], [1, -1], [1, 1], [-1, 1]];
_strips
