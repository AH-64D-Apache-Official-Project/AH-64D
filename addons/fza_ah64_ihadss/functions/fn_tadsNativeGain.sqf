/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_tadsNativeGain

Description:
    Learns how far the game's own turret control moves the TADS heads down for
    a unit of aim input, so input the mod applies itself there (the IAT's LOS
    offset, fza_ihadss_fnc_iatUpdate) moves it the same. Measured each frame
    the CPG slews the TADS by hand through the sight with nothing locking it,
    as the change in its stabilised line of sight against the input times the
    field of view, by least squares over recent frames.

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_ihadss_fnc_tadsNativeGain
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

([_heli] call fza_ihadss_fnc_tadsLos) params ["", "_losDir"];
private _dir  = _heli vectorModelToWorldVisual _losDir;
private _prev = _heli getVariable ["fza_ihadss_nativeGainDir", []];

private _native = player == gunner _heli && {cameraView == "GUNNER"} && {_heli getVariable ["bmkhs_acBusOn", false]}
    && {([_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable) == SIGHT_TADS}
    && {(([_heli] call fza_ihadss_fnc_tadsNvs) # 0) == NVS_MODE_OFF}
    && {!(_heli getVariable ["fza_ah64_LmcActive", false])} && {!(_heli getVariable ["fza_ah64_cpgSlaved", false])}
    && {!(_heli getVariable ["fza_ihadss_lstDriving", false])} && {!(_heli getVariable ["fza_ihadss_iatDriving", false])};
_heli setVariable ["fza_ihadss_nativeGainDir", [[], _dir] select _native];
if (!_native || {_prev isEqualTo []}) exitWith {};

private _uAz = inputAction "AimRight" - inputAction "AimLeft";
private _uEl = inputAction "AimUp" - inputAction "AimDown";
if (abs _uAz < 0.01 && {abs _uEl < 0.01}) exitWith {};

private _fov   = fza_ah64_tadsFOVs select (_heli getVariable ["fza_ihadss_tadsOpticsMode", _heli getTurretOpticsMode [0]]);
private _right = vectorNormalized (_prev vectorCrossProduct [0, 0, 1]);
private _up    = _right vectorCrossProduct _prev;
private _move  = _dir vectorDiff _prev;
private _dAz   = deg (_move vectorDotProduct _right);
private _dEl   = deg (_move vectorDotProduct _up);

(missionNamespace getVariable ["fza_ihadss_tadsNativeGain", [0, 0, 0]]) params ["_sxy", "_sxx", "_n"];
_sxy = _sxy * 0.998 + (_dAz * _uAz + _dEl * _uEl) * _fov;
_sxx = _sxx * 0.998 + (_uAz * _uAz + _uEl * _uEl) * _fov * _fov;
missionNamespace setVariable ["fza_ihadss_tadsNativeGain", [_sxy, _sxx, _n + 1]];
