/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_iatGates

Description:
    The IAT gates as a world point and size, for each display to project
    through its own camera as it does its other world symbols. Tracking, about
    the target, as wide and tall as its bounding box seen along the display's
    right and up; while sized and in stop mode about a point out along the
    TADS LOS, at the size they are being sized to or had. None with the IAT
    off or failed, or in the DVO.

Parameters:
    _heli  - The helicopter
    _right - The display's right, world unit vector
    _up    - The display's up, world unit vector

Returns:
    [ASL position, half size [along right, along up] m], [] for none

Examples:
    --- Code
    ([_heli, _right, _up] call fza_ihadss_fnc_iatGates) params ["_pos", "_half"];
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_right", "_up"];

(_heli getVariable ["fza_ah64_iat", IAT_IDLE]) params ["_state", "", "_obj", "_trackPoint", "", "", "", "_half", "_started", "_stopGate"];
if !(_state in [IAT_TRACK, IAT_COAST, IAT_STOP, IAT_SIZING]) exitWith {[]};
if (([_heli] call fza_ihadss_fnc_getVisionMode) == 3) exitWith {[]};

if (_state == IAT_SIZING) then {
    private _size = [_started] call fza_ihadss_fnc_iatSizing;
    _stopGate = [_size, _size];
};

if (_state in [IAT_STOP, IAT_SIZING]) exitWith {
    ([_heli] call fza_ihadss_fnc_tadsLos) params ["_losPos", "_losDir"];
    private _fov = fza_ah64_tadsFOVs select (_heli getVariable ["fza_ihadss_tadsOpticsMode", _heli getTurretOpticsMode [0]]);
    if (_stopGate isEqualTo []) then {_stopGate = [IAT_GATE_MAX, IAT_GATE_MAX]};
    [
        _heli modelToWorldVisualWorld (_losPos vectorAdd (_losDir vectorMultiply 1000)),
        _stopGate apply {_x * _fov * 1000}
    ]
};

private _pos = [_heli] call fza_ihadss_fnc_iatTargetPos;
if (_pos isEqualTo []) exitWith {[]};
if (isNull _obj) exitWith {[_pos, _half]};

([_obj] call fza_ihadss_fnc_iatBounds) params ["_p1", "_p2"];
private _ext  = (_p2 vectorDiff _p1) apply {abs _x / 2};
private _axes = [[1, 0, 0], [0, 1, 0], [0, 0, 1]] apply {_obj vectorModelToWorldVisual _x};
private _seen = {
    params ["_v"];
    private _h = 0;
    {_h = _h + abs (_v vectorDotProduct _x) * (_ext # _forEachIndex)} forEach _axes;
    _h
};
// A vehicle or man tracked on itself is boxed about its middle
if (_state == IAT_TRACK && {_trackPoint isEqualTo []}) then {
    _pos = AGLToASL (_obj modelToWorldVisual ((_p1 vectorAdd _p2) vectorMultiply 0.5));
};
[_pos, [[_right] call _seen, [_up] call _seen]]
