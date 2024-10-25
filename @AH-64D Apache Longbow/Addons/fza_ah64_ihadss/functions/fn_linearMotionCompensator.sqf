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
#define INPUT_SENS 0.001 // Tweak this for responsiveness? - Ampersand
#define INPUT_MAX 5.0

params ["_heli"];

if !(_heli getVariable "fza_ah64_LmcActive") exitwith {
    _heli setVariable ["fza_ah64_lmcConstant", [0, 0]];
    _heli setVariable ["fza_ah64_lmcStartRange", -1];
    _heli setVariable ["fza_ah64_lmcPosition", []];
};
private _sight = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
if (_sight != SIGHT_TADS || !(local gunner _heli)) exitwith {};

(_heli getVariable "fza_ah64_lmcConstant") params ["_azimuthC", "_elevationC"];
private _lmcStartRange = _heli getVariable "fza_ah64_lmcStartRange";
private _lmcPosition = _heli getVariable "fza_ah64_lmcPosition";

private _fovVal = fza_ah64_tadsFOVs select (_heli getTurretOpticsMode [0]);
private _inputX = [((((inputAction "AimRight" - inputAction "AimLeft")) * INPUT_SENS) * _fovVal + _azimuthC), -INPUT_MAX, INPUT_MAX] call BIS_fnc_clamp;
private _inputY = [(((inputAction "AimUp" - inputAction "AimDown") * INPUT_SENS) * _fovVal + _elevationC), -INPUT_MAX, INPUT_MAX] call BIS_fnc_clamp;

_heli setVariable ["fza_ah64_lmcConstant", [_inputX, _inputY]];

#ifdef __A3_DEBUG__
drawIcon3D [
	"a3\ui_f\data\Map\Markers\Military\circle_CA.paa",
	[1, 1, 1, 1],
	positionCameraToWorld [_inputX, _inputY, 10],
	1, 1, 0
];
#endif

//AUTO RANGING USING ATL ON 2D Model
private _TadsPosition  = _heli modelToWorldVisualWorld (_heli selectionPosition "laserEnd");
private _TadsAimPos    = _heli modelToWorldVisualWorld (_heli selectionPosition "laserBegin");
private _tadsDirection = (_TadsPosition vectorFromTo _TadsAimPos) vectorMultiply 50000;
_tadsDirection call CBA_fnc_vect2Polar Params ["","","_elevation"];
private _autorange = [(_TadsPosition)#2 /sin(-_elevation),0,50000] call BIS_fnc_clamp;

private _range = 1000;
private _laserPos = getPosASL laserTarget _heli;
if (_elevation < -1 && ([_heli] call fza_sfmplus_fnc_getAltitude)#1 < 1428) then {
	_range = _autorange;
};
if (_laserPos isnotEqualTo [0,0,0]) then {
	_range = _TadsPosition distance _laserPos;
};

if (_lmcStartRange == -1) then {
	_heli setVariable ["fza_ah64_lmcStartRange", _range];
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
	private _tadsY = _heli vectorWorldToModelVisual (_TadsPosition vectorFromTo _lmcPosition);
	private _tadsX = _tadsY vectorCrossProduct [0, 0, 1];
	private _tadsZ = _tadsX vectorCrossProduct _tadsY;
	[_tadsX, _tadsY, _tadsZ]
} params ["_tadsX", "_tadsY", "_tadsZ"];

#ifdef __A3_DEBUG__
	private _pos = ASLToAGL _TadsPosition;
	{
		_colour = [0, 0, 0, 1];
		_colour set [_forEachIndex , 1];
		drawLine3D [
			_pos,
			_pos vectorAdd (_heli vectorModelToWorldVisual (_x vectorMultiply _range)),
			_colour
		];
	} forEach [_tadsX, _tadsY, _tadsZ];
#endif

// Rotate
private _m = matrixTranspose [_tadsX, _tadsY, _tadsZ];
[[1, 0, 0], [0, 1, 0], [0, 0, 1]] matrixMultiply _m params ["_vX", "_vY", "_vZ"];
_m = matrixTranspose [_vX, _vY, _vZ];
 [_deltaX, _deltaY, _deltaZ] matrixMultiply _m params ["", "_newY"];

_newY = _newY vectorMultiply _range;
_lmcPosition = _TadsPosition vectorAdd (_heli vectorModelToWorldVisual _newY);
_heli setVariable ["fza_ah64_lmcPosition", _lmcPosition];

#ifdef __A3_DEBUG__
	hintSilent str [_lmcPosition];
	drawIcon3D [
		"\a3\ui_f\data\Map\MarkerBrushes\cross_ca.paa",
		[1, 0, 0, 1],
		ASLToAGL _lmcPosition,
		1, 1, 0
	];
	drawLine3D [
		ASLToAGL _TadsPosition,
		ASLToAGL _lmcPosition,
		[1, 0, 0, 1]
	];
#endif

_heli lockCameraTo [_lmcPosition, [0], true];
