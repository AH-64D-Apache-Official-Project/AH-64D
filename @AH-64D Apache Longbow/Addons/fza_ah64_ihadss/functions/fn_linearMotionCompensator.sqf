/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_linearMotionCompensator

Description:
    Per Frame handler of the LMC

Parameters:
    _heli - The helicopter to act on

Returns:

Examples:

Author:
    Snow(Dryden), Ampersand
---------------------------------------------------------------------------- */
#define INPUT_SENS 0.01 // Tweak this for responsiveness? - Ampersand
#define INPUT_MAX 5.0

params ["_heli"];

if !(_heli getVariable "fza_ah64_LmcActive") exitwith {
    _heli setVariable ["fza_ah64_lmcConstant", [0, 0], true];
    _heli setVariable ["fza_ah64_lmcStartRange", -1, true];
    _heli setVariable ["fza_ah64_lmcPosition", [], true];
};

_heli getVariable ["fza_ah64_lmcConstant", [0, 0]] params ["_azimuthC", "_elevationC"];
private _lmcStartRange = _heli getVariable ["fza_ah64_lmcStartRange", -1];
private _lmcPosition = _heli getVariable ["fza_ah64_lmcPosition", []];

private _index = _heli getTurretOpticsMode [0];
private _fovName = ["Flir_Wide", "Flir_Medium", "Flir_Narrow", "Flir_Zoom", "A3ti_Wide", "A3ti_Medium", "A3ti_Narrow", "A3ti_Zoom", "Dtv_wide", "Dtv_dummyFOV", "Dtv_Narrow", "Dtv_Narrow", "Dtv_Zoom"]#_index;
private _fovConfig = configFile >> "CfgVehicles" >> "fza_ah64d_b2e" >> "Turrets" >> "MainTurret" >> "OpticsIn" >> _fovName;
private _fovVal = getNumber (_fovConfig >> "initfov");

private _inputX = -1 * [(((inputAction "AimLeft" - inputAction "AimRight") * INPUT_SENS) * _fovVal + _azimuthC), -INPUT_MAX, INPUT_MAX] call BIS_fnc_clamp;
private _inputY = [(((inputAction "AimUp" - inputAction "AimDown") * INPUT_SENS) * _fovVal + _elevationC), -INPUT_MAX, INPUT_MAX] call BIS_fnc_clamp;

_heli setVariable ["fza_ah64_lmcConstant", [_inputX, _inputY], true];

#ifdef DEBUG_MODE_FULL
drawIcon3D [
	"a3\ui_f\data\Map\Markers\Military\circle_CA.paa",
	[1, 1, 1, 1],
	positionCameraToWorld [_inputX, _inputY, 10],
	1, 1, 0
];
#endif DEBUG_MODE_FULL

private _tadsPos = (_heli modelToWorldVisualWorld (_heli selectionPosition "laserBegin"));
private _laserPos = getPosASL laserTarget _heli;
private _range = _laserPos distance _tadsPos;

if (_lmcStartRange == -1) then {
	_heli setVariable ["fza_ah64_lmcStartRange", _range, true];
	_lmcStartRange = _range;
};

private _rangeScale =  _lmcStartRange / _range;

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
	private _tadsY = _heli vectorWorldToModelVisual (_tadsPos vectorFromTo _lmcPosition);
	private _tadsX = _tadsY vectorCrossProduct [0, 0, 1];
	private _tadsZ = _tadsX vectorCrossProduct _tadsY;
	[_tadsX, _tadsY, _tadsZ]
} params ["_tadsX", "_tadsY", "_tadsZ"];

_pos = ASLToAGL _tadsPos;

#ifdef DEBUG_MODE_FULL
{
_colour = [0, 0, 0, 1];
_colour set [_forEachIndex , 1];
drawLine3D [
	_pos,
	_pos vectorAdd (_heli vectorModelToWorldVisual (_x vectorMultiply _range)),
	_colour
];
} forEach [_tadsX, _tadsY, _tadsZ];
#endif DEBUG_MODE_FULL

// Rotate
private _m = matrixTranspose [_tadsX, _tadsY, _tadsZ];
[[1, 0, 0], [0, 1, 0], [0, 0, 1]] matrixMultiply _m params ["_vX", "_vY", "_vZ"];
_m = matrixTranspose [_vX, _vY, _vZ];
 [_deltaX, _deltaY, _deltaZ] matrixMultiply _m params ["", "_newY"];

_newY = _newY vectorMultiply _range;
_lmcPosition = _tadsPos vectorAdd (_heli vectorModelToWorldVisual _newY);
_heli setVariable ["fza_ah64_lmcPosition", _lmcPosition, true];

#ifdef DEBUG_MODE_FULL
hintSilent str [_lmcPosition];
drawIcon3D [
	"\a3\ui_f\data\Map\MarkerBrushes\cross_ca.paa",
	[1, 0, 0, 1],
	ASLToAGL _lmcPosition,
	1, 1, 0
];
drawLine3D [
ASLToAGL _tadsPos,
ASLToAGL _lmcPosition,
[1, 0, 0, 1]
];
#endif DEBUG_MODE_FULL

_heli lockCameraTo [_lmcPosition, [0], true];
