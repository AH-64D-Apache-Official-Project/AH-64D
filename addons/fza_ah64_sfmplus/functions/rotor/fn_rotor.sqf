#include "\fza_ah64_sfmplus\functions\rotor\rotor.hpp"

params ["_heli"];

if (!local _heli) exitWith {};

private _deltaTime     = _heli getVariable "fza_sfmplus_deltaTime";

private _cfg           = configOf _heli;
private _sfmPlusConfig = _cfg >> "Fza_SfmPlus";

private _pivot         = [0.0, 2.06, 0.0];
private _rot		   = [0.0, 0.0, 0.0];
private _type          = MAIN;
private _dir		   = CCW;
private _numBlades     = 4;
private _numElements   = 4;
private _mastLength    = 0.70;
private _gearRatio     = 72.291;
private _flapTimeConst = 2.0;
private _delta3        = 0.5;
private _airfoilTable  = getArray (_sfmPlusConfig >> "airfoilTable02");
private _bladeCutout   = 1.15;
private _bladeLength   = 7.315;
private _bladeChord    = 0.533;
private _bladeTwist    = -9;
private _bladeMass     = 72.108;

private _pitchMin = -10;
private _pitchMid =   0;
private _pitchMax =  20;
private _rollMin  = -10.5;
private _rollMid  =   0;
private _rollMax  =   7;
private _collMin  =  1;
private _collMid  =  0;
private _collMax  = 19;

([ _heli
 , _type
 , _pitchMin
 , _pitchMid
 , _pitchMax
 , _rollMin
 , _rollMid
 , _rollMax
 , _collMin
 , _collMid
 , _collMax
 , _collCone ] call fza_sfmplus_fnc_rotorControl)
	params [ "_pitchFeather"
		   , "_rollFeather"
		   , "_collFeather"];

private _p = _rot select 0;
private _r = _rot select 1;
private _y = _rot select 2;

private _fVec = [[0.0, 1.0, 0.0], _p, _r, _y] call fza_sfmplus_fnc_vectorRotate;
private _rVec = [[1.0, 0.0, 0.0], _p, _r, _y] call fza_sfmplus_fnc_vectorRotate;
private _uVec = [[0.0, 0.0, 1.0], _p, _r, _y] call fza_sfmplus_fnc_vectorRotate;

private _pos          = _pivot vectorAdd (_uVec vectorMultiply _mastLength);
private _xmsnRpm      = _heli getVariable "fza_sfmplus_xmsnOutputRpm";
private _rpm          = _xmsnRpm / _gearRatio;
private _omega        = if (_rpm == 0.0) then { 0.0; } else { (2.0 * pi) * (_rpm / 60.0); };
private _rotorAzimuth = (_heli animationSourcePhase "rotorH") * 360.0 * (if (_dir == CW) then { 1 } else { -1 });

// Blade flapping dynamics
([ _heli
 , _deltaTime
 , _numBlades
 , _omega
 , _bladeMass
 , _bladeLength
 , _bladeCutout
 , _flapTimeConst
 , _rVec
 , _fVec
 , _uVec ] call fza_sfmplus_fnc_rotorFlapDynamics)
	params ["_beta0", "_a1", "_b1"];

for "_i" from 0 to 3 do {
	private _psi = _rotorAzimuth + (90.0 * _i);

	private _bladeDir     = [_rVec, _uVec, _psi] call fza_sfmplus_fnc_vectorRotateAroundAxis;
	private _chordDir     = [_fVec, _uVec, _psi] call fza_sfmplus_fnc_vectorRotateAroundAxis;
	private _dirSign      = if (_dir == CW) then { _chordDir = _chordDir vectorMultiply -1; -1 } else { 1 };

	// Per-blade flap angle from fixed body-frame coefficients.
	// a1 (longitudinal): blade contribution proportional to its forward component
	// b1 (lateral):      blade contribution proportional to its rightward component
	private _flapAngle    = _beta0   + (_a1 * (_bladeDir vectorDotProduct _fVec)) + (_b1 * (_bladeDir vectorDotProduct _rVec));
	private _featherAngle = _dirSign * (_rollFeather * cos(_psi) + _pitchFeather * sin(_psi) + _collFeather - (_flapAngle * _delta3));

	private _tipTwist           = _bladeTwist * _dirSign;

	private _a_rootPos          = _pos       vectorAdd  ([_bladeDir vectorMultiply _bladeCutout, _chordDir, _flapAngle] call fza_sfmplus_fnc_vectorRotateAroundAxis);
	private _b_tipPos           = _pos       vectorAdd  ([_bladeDir vectorMultiply _bladeLength, _chordDir, _flapAngle] call fza_sfmplus_fnc_vectorRotateAroundAxis);
	private _c_rootLeadingEdge  = _a_rootPos vectorAdd  ([_chordDir vectorMultiply (_bladeChord * 0.25), _bladeDir, -_featherAngle]              call fza_sfmplus_fnc_vectorRotateAroundAxis);
	private _d_tipLeadingEdge   = _b_tipPos  vectorAdd  ([_chordDir vectorMultiply (_bladeChord * 0.25), _bladeDir, -(_featherAngle + _tipTwist)] call fza_sfmplus_fnc_vectorRotateAroundAxis);
	private _e_tipTrailingEdge  = _b_tipPos  vectorDiff ([_chordDir vectorMultiply (_bladeChord * 0.75), _bladeDir, -(_featherAngle + _tipTwist)] call fza_sfmplus_fnc_vectorRotateAroundAxis);
	private _f_rootTrailingEdge = _a_rootPos vectorDiff ([_chordDir vectorMultiply (_bladeChord * 0.75), _bladeDir, -_featherAngle]              call fza_sfmplus_fnc_vectorRotateAroundAxis);

	// Store this blade's azimuth so the decomposition next frame uses the correct position
	[_heli, "fza_sfmplus_rotorBladeAzimuth", _i, _psi] call fza_fnc_setArrayVariable;

	[ _heli
	, _i
	, _deltaTime
	, _numElements
	, _numBlades
	, _pos
	, _uVec
	, _omega
	, _airfoilTable
	, _a_rootPos
	, _b_tipPos
	, _c_rootLeadingEdge
	, _d_tipLeadingEdge
	, _e_tipTrailingEdge
	, _f_rootTrailingEdge ] call fza_sfmplus_fnc_rotorBlade;

	#ifdef __A3_DEBUG__
	[_heli, _a_rootPos, _b_tipPos, "blue"] call fza_fnc_debugDrawLine;
	[_heli, _c_rootLeadingEdge, _d_tipLeadingEdge,   "red"]   call fza_fnc_debugDrawLine;
	[_heli, _d_tipLeadingEdge,  _e_tipTrailingEdge,  "white"] call fza_fnc_debugDrawLine;
	[_heli, _e_tipTrailingEdge, _f_rootTrailingEdge, "white"] call fza_fnc_debugDrawLine;
	[_heli, _f_rootTrailingEdge,_c_rootLeadingEdge,  "white"] call fza_fnc_debugDrawLine;
	#endif
};

#ifdef __A3_DEBUG__
//Mast
[_heli, _pivot, _pos, "white"] call fza_fnc_debugDrawLine;
//Hub axes
[_heli, _pos, _pos vectorAdd _fVec, "green"] call fza_fnc_debugDrawLine;
[_heli, _pos, _pos vectorAdd _rVec, "red"]   call fza_fnc_debugDrawLine;
[_heli, _pos, _pos vectorAdd _uVec, "blue"]  call fza_fnc_debugDrawLine;
#endif
