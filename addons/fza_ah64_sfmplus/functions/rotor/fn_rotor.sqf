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
private _numElements   = 4;
private _mastLength    = 0.70;
private _designRpm     = 289.0;
private _airfoilTable  = getArray (_sfmPlusConfig >> "airfoilTable01");
private _bladeCutout   = 1.15;
private _bladeLength   = 7.315;
private _bladeChord    = 0.533;
private _bladeTwist    = -9;

private _pitchMin = -10;
private _pitchMid =  0;
private _pitchMax =  20;
private _rollMin  = -10;
private _rollMid  =  0;
private _rollMax  =  20;
private _collMin  =  1;
private _collMid  =  0;
private _collMax  = 19;
private _collCone =  8;
private _featherMax = 4;

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
 , _collCone
 , _featherMax ] call fza_sfmplus_fnc_rotorControl)
	params [ "_pitchFeather"
		   , "_pitchFlap"
		   , "_rollFeather"
		   , "_rollFlap"
		   , "_collFeather"
		   , "_collConing"];

private _p = _rot select 0;
private _r = _rot select 1;
private _y = _rot select 2;

private _fVec = [[0.0, 1.0, 0.0], _p, _r, _y] call fza_sfmplus_fnc_vectorRotate;
private _rVec = [[1.0, 0.0, 0.0], _p, _r, _y] call fza_sfmplus_fnc_vectorRotate;
private _uVec = [[0.0, 0.0, 1.0], _p, _r, _y] call fza_sfmplus_fnc_vectorRotate;

private _pos       = _pivot vectorAdd (_uVec vectorMultiply _mastLength);
private _xmsnRpm   = _heli getVariable "fza_sfmplus_xmsnOutputRpm";
private _gearRatio = 72.291;
private _rpm       = _xmsnRpm / _gearRatio;
private _omega     = if (_rpm == 0.0) then { 0.0; } else { (2.0 * pi) * (_rpm / 60.0); };

for "_i" from 0 to 3 do {
	private _psi = 90 * _i;

	private _bladeDir     = [_rVec, _uVec, _psi] call fza_sfmplus_fnc_vectorRotateAroundAxis;
	private _chordDir     = [_fVec, _uVec, _psi] call fza_sfmplus_fnc_vectorRotateAroundAxis;
	private _dirSign      = if (_dir == CW) then { _chordDir = _chordDir vectorMultiply -1; -1 } else { 1 };

	private _flapAngle    = _dirSign * (_rollFlap    * cos(_psi) + _pitchFlap    * sin(_psi) + _collConing);
	private _featherAngle = _dirSign * (_rollFeather * cos(_psi) + _pitchFeather * sin(_psi) + _collFeather);

	private _tipTwist           = _bladeTwist * _dirSign;

	private _a_rootPos          = _pos       vectorAdd  ([_bladeDir vectorMultiply _bladeCutout, _chordDir, _flapAngle] call fza_sfmplus_fnc_vectorRotateAroundAxis);
	private _b_tipPos           = _pos       vectorAdd  ([_bladeDir vectorMultiply _bladeLength, _chordDir, _flapAngle] call fza_sfmplus_fnc_vectorRotateAroundAxis);
	private _c_rootLeadingEdge  = _a_rootPos vectorAdd  ([_chordDir vectorMultiply (_bladeChord * 0.25), _bladeDir, -_featherAngle]              call fza_sfmplus_fnc_vectorRotateAroundAxis);
	private _d_tipLeadingEdge   = _b_tipPos  vectorAdd  ([_chordDir vectorMultiply (_bladeChord * 0.25), _bladeDir, -(_featherAngle + _tipTwist)] call fza_sfmplus_fnc_vectorRotateAroundAxis);
	private _e_tipTrailingEdge  = _b_tipPos  vectorDiff ([_chordDir vectorMultiply (_bladeChord * 0.75), _bladeDir, -(_featherAngle + _tipTwist)] call fza_sfmplus_fnc_vectorRotateAroundAxis);
	private _f_rootTrailingEdge = _a_rootPos vectorDiff ([_chordDir vectorMultiply (_bladeChord * 0.75), _bladeDir, -_featherAngle]              call fza_sfmplus_fnc_vectorRotateAroundAxis);

	[ _heli
	, _i
	, _deltaTime
	, _numElements
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
	//Blade lift line
	[_heli, _a_rootPos, _b_tipPos, "blue"] call fza_fnc_debugDrawLine;
	//Blade
	[_heli, _c_rootLeadingEdge,  _d_tipLeadingEdge,   "red"]   call fza_fnc_debugDrawLine;
	[_heli, _d_tipLeadingEdge,   _e_tipTrailingEdge,  "white"] call fza_fnc_debugDrawLine;
	[_heli, _e_tipTrailingEdge,  _f_rootTrailingEdge, "white"] call fza_fnc_debugDrawLine;
	[_heli, _f_rootTrailingEdge, _c_rootLeadingEdge,  "white"] call fza_fnc_debugDrawLine;
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