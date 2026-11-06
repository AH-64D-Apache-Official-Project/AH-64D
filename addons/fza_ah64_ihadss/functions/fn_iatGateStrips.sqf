/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_iatGateStrips

Description:
    The IAT gates as filled strips in format units, from where a display
    projects them (fza_ihadss_fnc_iatGates): the four corners of a box about
    the target, drawn 3 units wide with no sides; inverted in stop mode and
    with OFS selected, thick solid lines in the gaps between the corners;
    flashing while reacquiring.

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

(_heli getVariable ["fza_ah64_iat", IAT_IDLE]) params ["_state", "", "", "", "", "", "", "", "", "", "_ofs"];
if (_state == IAT_COAST && {floor (diag_tickTime * 4) mod 2 == 1}) exitWith {[]};

_hw = (_hw min (IAT_GATE_MAX * 320)) max 8;
_hh = (_hh min (IAT_GATE_MAX * 320)) max 8;

// Corner arms, and the line width
private _arm   = ((_hw min _hh) * 0.5) max 6;
private _t     = 3;

// Inverted, the gaps between the corners
if (_state == IAT_STOP || {_ofs}) exitWith {
    private _thick = 4;
    [
        [_dx - _hw + _arm, _dy - _hh - _thick / 2, 2 * (_hw - _arm), _thick],
        [_dx - _hw + _arm, _dy + _hh - _thick / 2, 2 * (_hw - _arm), _thick],
        [_dx - _hw - _thick / 2, _dy - _hh + _arm, _thick, 2 * (_hh - _arm)],
        [_dx + _hw - _thick / 2, _dy - _hh + _arm, _thick, 2 * (_hh - _arm)]
    ]
};

private _strips = [];
{
    _x params ["_sx", "_sy"];
    private _cx = _dx + _sx * _hw;
    private _cy = _dy + _sy * _hh;
    // From the corner's outer edge inwards
    private _x0 = if (_sx < 0) then {_cx - _t / 2} else {_cx + _t / 2 - _arm};
    private _y0 = if (_sy < 0) then {_cy - _t / 2} else {_cy + _t / 2 - _arm};
    _strips pushBack [_x0, _cy - _t / 2, _arm, _t];
    _strips pushBack [_cx - _t / 2, _y0, _t, _arm];
} forEach [[-1, -1], [1, -1], [1, 1], [-1, 1]];
_strips
