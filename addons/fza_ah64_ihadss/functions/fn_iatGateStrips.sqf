/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_iatGateStrips

Description:
    The IAT gates as filled strips in format units, from where a display
    projects them (fza_ihadss_fnc_iatGates): four bars about the target,
    outlined 3 units wide, solid in stop mode, flashing while reacquiring,
    growing out from the reticle as they capture.

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

(_heli getVariable ["fza_ah64_iat", IAT_IDLE]) params ["_state", "", "", "", "", "", "", "", "_started"];
if (_state == IAT_COAST && {floor (diag_tickTime * 4) mod 2 == 1}) exitWith {[]};

private _grow = (((CBA_missionTime - _started) / IAT_GROW_TIME) max 0) min 1;
_hw = (10 + ((_hw min (IAT_GATE_MAX * 320)) - 10) * _grow) max 10;
_hh = (10 + ((_hh min (IAT_GATE_MAX * 320)) - 10) * _grow) max 10;
_dx = _dx * _grow;
_dy = _dy * _grow;

private _gates = [
    [_dx - _hw / 2, _dy - _hh - 2.5, _hw, 5],
    [_dx - _hw / 2, _dy + _hh - 2.5, _hw, 5],
    [_dx - _hw - 2.5, _dy - _hh / 2, 5, _hh],
    [_dx + _hw - 2.5, _dy - _hh / 2, 5, _hh]
];
if (_state == IAT_STOP) exitWith {_gates};

private _strips = [];
{
    _x params ["_bx", "_by", "_bw", "_bh"];
    _strips append [
        [_bx - 1.5, _by - 1.5, _bw + 3, 3],
        [_bx - 1.5, _by + _bh - 1.5, _bw + 3, 3],
        [_bx - 1.5, _by - 1.5, 3, _bh + 3],
        [_bx + _bw - 1.5, _by - 1.5, 3, _bh + 3]
    ];
} forEach _gates;
_strips
