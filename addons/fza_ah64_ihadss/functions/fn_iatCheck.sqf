/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_iatCheck

Description:
    Whether the image auto tracker can hold a target: in range, in the TADS
    field of view and gimbal limits, neither too small nor too big in the
    picture, and not hidden by terrain, objects or smoke. In the FLIR a
    running vehicle or a live man shows white in white hot and black in black
    hot, anything else the reverse; with the polarity switch against it the
    target must be bigger and clearer. The DTV tracks either.

Parameters:
    _heli   - The helicopter
    _obj    - The target object
    _pos    - Its ASL position
    _half   - Its half size [across, up], m
    _vision - The TADS vision mode (fza_ihadss_fnc_getVisionMode)

Returns:
    True when it can be tracked

Examples:
    --- Code
    [_heli, _obj, _pos, _half, _vision] call fza_ihadss_fnc_iatCheck
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_obj", "_pos", "_half", "_vision"];

if (isNull _obj || {_pos isEqualTo []}) exitWith {false};

([_heli] call fza_ihadss_fnc_tadsLos) params ["_losPos", "_losDir"];
private _tadsPos = _heli modelToWorldVisualWorld _losPos;
private _dir     = _heli vectorModelToWorldVisual _losDir;
private _fov     = fza_ah64_tadsFOVs select (_heli getVariable ["fza_ihadss_tadsOpticsMode", _heli getTurretOpticsMode [0]]);

private _v = _pos vectorDiff _tadsPos;
private _f = _v vectorDotProduct _dir;
if (_f < 1 || {vectorMagnitude _v > IAT_RANGE}) exitWith {false};

private _right = vectorNormalized (_dir vectorCrossProduct (_heli vectorModelToWorldVisual [0, 0, 1]));
private _up    = _right vectorCrossProduct _dir;
if (abs ((_v vectorDotProduct _right) / _f) > _fov || {abs ((_v vectorDotProduct _up) / _f) > 0.75 * _fov}) exitWith {false};

(_heli vectorWorldToModelVisual _v) params ["_x", "_y", "_z"];
private _az = _x atan2 _y;
private _el = _z atan2 (sqrt (_x * _x + _y * _y));
if (abs _az > 120 || {_el > 30} || {_el < -60}) exitWith {false};

// The polarity switch against how the target shows in the FLIR
private _mismatch = false;
if (_vision in [1, 2]) then {
    private _polarity = _heli getVariable ["fza_ah64_iatPolarity", IAT_POL_AUTO];
    private _hot      = [isEngineOn _obj, alive _obj] select (_obj isKindOf "CAManBase");
    private _blackHot = if (_vision == 1) then {(call A3TI_fnc_getA3TIVision) isEqualTo "BHOT"} else {((_heli currentVisionMode [0]) # 1) == 1};
    private _shows    = [IAT_POL_WHITE, IAT_POL_BLACK] select (_hot isEqualTo _blackHot);
    _mismatch = _polarity != IAT_POL_AUTO && {_polarity != _shows};
};

private _size = ((_half # 0) max (_half # 1)) / _f / _fov;
if (_size < IAT_MIN_SIZE * ([1, IAT_MISMATCH_SIZE] select _mismatch) || {_size > IAT_GATE_MAX}) exitWith {false};

([_heli, "VIEW", _obj] checkVisibility [_tadsPos, _pos]) >= ([IAT_VISIBLE, IAT_MISMATCH_VISIBLE] select _mismatch)
