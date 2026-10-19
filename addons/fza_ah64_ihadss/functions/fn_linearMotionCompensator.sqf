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
#include "\bmkhs_helisim\functions\core\core.hpp"
params ["_heli", "_deltaTime"];

#define INPUT_MAX 10.0

if !(_heli getVariable "fza_ah64_LmcActive") exitWith {
    _heli setVariable ["fza_ah64_lmcPrevInputs", [0, 0]];
    _heli setVariable ["fza_ah64_lmcStartRange", -1];
    _heli setVariable ["fza_ah64_lmcRange", 3000];
    _heli setVariable ["fza_ah64_lmcPosition", []];
};
private _sight = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
if (_sight != SIGHT_tads || (player != gunner _heli)) exitWith {};

// Slaved, the TADS goes to the acquisition source and holds it, as with LMC off (fza_fnc_weaponTurretAim); LMC carries
// on compensating from there once slave is turned off
if (_heli getVariable ["fza_ah64_cpgSlaved", false]) exitWith {
    private _slavePos = [_heli, [_heli, [0]] call fza_fnc_targetingCurAcq] call fza_fnc_targetingAcqPoint;
    if (_slavePos isEqualTo []) exitWith {};
    _heli setVariable ["fza_ah64_lmcPrevInputs", [0, 0]];
    _heli setVariable ["fza_ah64_lmcStartRange", -1];
    _heli setVariable ["fza_ah64_lmcPosition", _slavePos];
    [_heli, _slavePos, true] call fza_fnc_targetingTadsLockTo;
};

(_heli getVariable "fza_ah64_lmcPrevInputs") params ["_prevInputX", "_prevInputY"];
private _lmcStartRange = _heli getVariable "fza_ah64_lmcStartRange";
private _lmcPosition = _heli getVariable "fza_ah64_lmcPosition";

private _lmcSensitivity = linearConversion [0.0, 1.0, fza_ah64_LMCSensitivity, 1.0, 20.0];
private _fovScalar      = fza_ah64_tadsFOVs select (_heli getTurretOpticsMode [0]);

//Get the velocities of the aircraft on the respective axes
private _velXY = vectorMagnitude [velocityModelSpace _heli # 0, velocityModelSpace _heli # 1];
private _velYZ = vectorMagnitude [velocityModelSpace _heli # 1, velocityModelSpace _heli # 2];

//Get range, from the crew station's range source
private _tadsPosition  = _heli modelToWorldVisualWorld (_heli selectionPosition "laserEnd");
private _range         = (([_heli, player] call fza_fnc_targetingRange) # 0) max 500;
_heli setVariable ["fza_ah64_lmcRange", _range];
if (_lmcStartRange == -1) then {
    _heli setVariable ["fza_ah64_lmcStartRange", _range];
    _lmcStartRange = _range;
};

//Calculate the angular velocity
private _angVelHorizontal = _velXY / _range;
private _angVelVertical   = _velYZ / _range;

//The aim input moves the head in free look, and the cockpit cursor while it is detached
private _noAim = freeLook || {(cameraView == "INTERNAL" && {((missionNamespace getVariable ["hct_interaction_trackIR_interaction_cursor", false]) && {!fza_ah64_tadsIgnoreHatchetCursor}) || {uiNamespace getVariable ["hct_interaction_mouseBlocker", false]}})};
private _aimX = [inputAction "AimRight" - inputAction "AimLeft", 0] select _noAim;
private _aimY = [inputAction "AimUp" - inputAction "AimDown", 0] select _noAim;

//Get horizontal input
private _inputX = (((_aimX - _angVelHorizontal) * _lmcSensitivity) * _fovScalar) * _deltaTime +  _prevInputX;
_inputX         = [_inputX, -INPUT_MAX, INPUT_MAX] call BIS_fnc_clamp;
//Get vertical input
private _inputY = (((_aimY    + _angVelVertical)   * _lmcSensitivity) * _fovScalar) * _deltaTime + _prevInputY;
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

[_heli, _lmcPosition, true] call fza_fnc_targetingTadsLockTo;
