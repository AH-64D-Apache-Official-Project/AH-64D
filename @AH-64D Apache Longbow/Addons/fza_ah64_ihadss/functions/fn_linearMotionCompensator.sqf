/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_linearMotionCompensator

Description:
    Per Frame handler of the LMC

Parameters:
    _heli - The helicopter to act on

Returns:

Examples:

Author:
    BradMick, Snow(Dryden), Ampersand
---------------------------------------------------------------------------- */
#include "\fza_ah64_sfmplus\headers\core.hpp"
params ["_heli", "_deltaTime"];

#define INPUT_MAX 10.0

if !(_heli getVariable "fza_ah64_LmcActive") exitwith {
    _heli setVariable ["fza_ah64_lmcPrevInputs", [0, 0]];
    _heli setVariable ["fza_ah64_lmcStartRange", -1];
    _heli setVariable ["fza_ah64_lmcRange", 3000];
    _heli setVariable ["fza_ah64_lmcPosition", []];
};
private _sight = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
if (_sight != SIGHT_tads || (player != gunner _heli)) exitwith {};

(_heli getVariable "fza_ah64_lmcPrevInputs") params ["_prevInputX", "_prevInputY"];
private _lmcStartRange = _heli getVariable "fza_ah64_lmcStartRange";
private _lmcPosition = _heli getVariable "fza_ah64_lmcPosition";

private _lmcSensitivity = linearConversion [0.0, 1.0, fza_ah64_LMCSensitivity, 1.0, 20.0];
private _fovScalar      = fza_ah64_tadsFOVs select (_heli getTurretOpticsMode [0]);

//Get the velocities of the aircraft on the respective axes
private _velXY = vectorMagnitude [velocityModelSpace _heli # 0, velocityModelSpace _heli # 1];
private _velYZ = vectorMagnitude [velocityModelSpace _heli # 1, velocityModelSpace _heli # 2];

//Get range
private _tadsPosition  = _heli modelToWorldVisualWorld (_heli selectionPosition "laserEnd");
private _tadsAimPos    = _heli modelToWorldVisualWorld (_heli selectionPosition "laserBegin");
private _tadsDirection = (_tadsPosition vectorFromTo _tadsAimPos) vectorMultiply 50000;
_tadsDirection call CBA_fnc_vect2Polar Params ["","","_elevation"];
private _elevation = _elevation min -EPSILON;
private _autorange = [(asltoagl _tadsPosition)#2 /sin(-_elevation),0,50000] call BIS_fnc_clamp;

private _range = -1;
private _laserPos = getPosASL laserTarget _heli;
if (_elevation < -1 && ([_heli] call fza_sfmplus_fnc_getAltitude)#1 < 1428) then {
    _range = _autorange;
};
if (_laserPos isnotEqualTo [0,0,0]) then {
    _range = _tadsPosition distance _laserPos;
};

if (_range == -1) then {
    _range = _heli getVariable "fza_ah64_lmcRange";
};
_range         = _range max 500;
_heli setVariable ["fza_ah64_lmcRange", _range];
if (_lmcStartRange == -1) then {
    _heli setVariable ["fza_ah64_lmcStartRange", _range];
    _lmcStartRange = _range;
};

//Calculate the angular velocity
private _angVelHorizontal = _velXY / _range;
private _angVelVertical   = _velYZ / _range;

//Get horizontal input
private _inputX = ((((inputAction "AimRight" - inputAction "AimLeft") - _angVelHorizontal) * _lmcSensitivity) * _fovScalar) * _deltaTime +  _prevInputX;
_inputX         = [_inputX, -INPUT_MAX, INPUT_MAX] call BIS_fnc_clamp;
//Get vertical input
private _inputY = ((((inputAction "AimUp" - inputAction "AimDown")    + _angVelVertical)   * _lmcSensitivity) * _fovScalar) * _deltaTime + _prevInputY;
_inputY         = [_inputY, -INPUT_MAX, INPUT_MAX] call BIS_fnc_clamp;

_heli setVariable ["fza_ah64_lmcPrevInputs", [_inputX, _inputY]];

private _rangeScale =  _lmcStartRange / _range^2;

// Turn input into rotated unit vector (current direction being [0, 1, 0])
private _deltaY = vectorNormalized [_inputX * _rangeScale, 1, _inputY * _rangeScale];
private _deltaX = _deltaY vectorCrossProduct [0, 0, 1];
private _deltaZ = _deltaX vectorCrossProduct _deltaY;

// Get TADS orientation
if (_lmcPosition isEqualTo []) then {
    _heli selectionVectorDirAndUp ["laserEnd", "memory"] params ["_tadsY", "_tadsZ"];
    private _tadsX = _tadsY vectorCrossProduct _tadsZ;
    [_tadsX, _tadsY, _tadsZ]
} else {
    private _tadsY = _heli vectorWorldToModelVisual (_tadsPosition vectorFromTo _lmcPosition);
    private _tadsX = _tadsY vectorCrossProduct [0, 0, 1];
    private _tadsZ = _tadsX vectorCrossProduct _tadsY;
    [_tadsX, _tadsY, _tadsZ]
} params ["_tadsX", "_tadsY", "_tadsZ"];

// Rotate
private _m = matrixTranspose [_tadsX, _tadsY, _tadsZ];
[[1, 0, 0], [0, 1, 0], [0, 0, 1]] matrixMultiply _m params ["_vX", "_vY", "_vZ"];
_m = matrixTranspose [_vX, _vY, _vZ];
 [_deltaX, _deltaY, _deltaZ] matrixMultiply _m params ["", "_newY"];

_newY = _newY vectorMultiply _range;
_lmcPosition = _tadsPosition vectorAdd (_heli vectorModelToWorldVisual _newY);
_heli setVariable ["fza_ah64_lmcPosition", _lmcPosition];

_heli lockCameraTo [_lmcPosition, [0], true];