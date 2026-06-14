#include "\fza_ah64_sfmplus\functions\rotor\rotor.hpp"
#include "\fza_ah64_systems\headers\systems.hpp"

params ["_heli", "_rotorIndex", "_pivot", "_rot", "_type", "_dir", "_numBlades", "_numElements", "_mastLength", "_gearRatio", "_flapTimeConst", "_inflowAlpha", "_delta3", "_airfoilTable", "_bladeCutout", "_bladeLength", "_bladeChord", "_bladeTwist", "_bladeMass", "_pitchMin", "_pitchMid", "_pitchMax", "_rollMin", "_rollMid", "_rollMax", "_collMin", "_collMid", "_collMax", "_animSource", "_hitPoint", "_dmgThreshold"];

if (!local _heli) exitWith {};

private _deltaTime = _heli getVariable "fza_sfmplus_deltaTime";

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
 , _collMax ] call fza_sfmplus_fnc_rotorControl)
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
private _omega        = if (_rpm == 0.0) then { 0.0 } else { (2.0 * pi) * (_rpm / 60.0) };
private _rotorAzimuth = (_heli animationSourcePhase _animSource) * 360.0 * (if (_dir == CW) then { 1 } else { -1 });

if (_heli getHitPointDamage _hitPoint < _dmgThreshold && currentPilot _heli == player) then {

// Reset accumulators before blade loop
[_heli, "fza_sfmplus_rotorReactionTorque", _rotorIndex, 0.0] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_rotorThrustAccum",    _rotorIndex, 0.0] call fza_fnc_setArrayVariable;
for "_ei" from 0 to (_numElements - 1) do {
    [_heli, "fza_sfmplus_rotorInducedFlowAccum", _rotorIndex, _ei, 0.0] call fza_fnc_setMultiArrayVariable;
};

// Blade flapping dynamics
([ _heli
 , _rotorIndex
 , _type
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

// Tail rotor has no flapping hinge — force all flap coefficients to zero
if (_type == TAIL) then { _beta0 = 0.0; _a1 = 0.0; _b1 = 0.0; };


private _bladeSpacing = 360.0 / _numBlades;
for "_bladeIndex" from 0 to (_numBlades - 1) do {
	private _psi = _rotorAzimuth + (_bladeSpacing * _bladeIndex);

	private _bladeDir = [_rVec, _uVec, _psi] call fza_sfmplus_fnc_vectorRotateAroundAxis;
	private _chordDir = [_fVec, _uVec, _psi] call fza_sfmplus_fnc_vectorRotateAroundAxis;
	private _dirSign  = if (_dir == CW) then { _chordDir = _chordDir vectorMultiply -1; -1 } else { 1 };

	// Per-blade flap angle from fixed body-frame coefficients.
	// a1 (longitudinal): blade contribution proportional to its forward component
	// b1 (lateral):      blade contribution proportional to its rightward component
	private _flapAngle    = _beta0 + (_a1 * (_bladeDir vectorDotProduct _fVec)) + (_b1 * (_bladeDir vectorDotProduct _rVec));
	private _featherAngle = _dirSign * (_rollFeather * cos(_psi) + _pitchFeather * sin(_psi) + _collFeather - (_flapAngle * _delta3));

	private _tipTwist = _bladeTwist * _dirSign;

	private _a_rootPos          = _pos       vectorAdd  ([_bladeDir vectorMultiply _bladeCutout,          _chordDir, _flapAngle]              call fza_sfmplus_fnc_vectorRotateAroundAxis);
	private _b_tipPos           = _pos       vectorAdd  ([_bladeDir vectorMultiply _bladeLength,          _chordDir, _flapAngle]              call fza_sfmplus_fnc_vectorRotateAroundAxis);
	private _c_rootLeadingEdge  = _a_rootPos vectorAdd  ([_chordDir vectorMultiply (_bladeChord * 0.25), _bladeDir, -_featherAngle]              call fza_sfmplus_fnc_vectorRotateAroundAxis);
	private _d_tipLeadingEdge   = _b_tipPos  vectorAdd  ([_chordDir vectorMultiply (_bladeChord * 0.25), _bladeDir, -(_featherAngle + _tipTwist)] call fza_sfmplus_fnc_vectorRotateAroundAxis);
	private _e_tipTrailingEdge  = _b_tipPos  vectorDiff ([_chordDir vectorMultiply (_bladeChord * 0.75), _bladeDir, -(_featherAngle + _tipTwist)] call fza_sfmplus_fnc_vectorRotateAroundAxis);
	private _f_rootTrailingEdge = _a_rootPos vectorDiff ([_chordDir vectorMultiply (_bladeChord * 0.75), _bladeDir, -_featherAngle]              call fza_sfmplus_fnc_vectorRotateAroundAxis);

	// Store this blade's azimuth so the decomposition next frame uses the correct position
	[_heli, "fza_sfmplus_rotorBladeAzimuth", _rotorIndex, _bladeIndex, _psi] call fza_fnc_setMultiArrayVariable;

	[ _heli
	, _bladeIndex
	, _rotorIndex
	, _deltaTime
	, _numElements
	, _numBlades
	, _pos
	, _uVec
	, _omega
	, _airfoilTable
	, _bladeCutout
	, _bladeLength
	, _inflowAlpha
	, _a_rootPos
	, _b_tipPos
	, _c_rootLeadingEdge
	, _d_tipLeadingEdge
	, _e_tipTrailingEdge
	, _f_rootTrailingEdge ] call fza_sfmplus_fnc_rotorBlade;

	#ifdef __A3_DEBUG__
	[_heli, _a_rootPos,          _b_tipPos,            "blue"]  call fza_fnc_debugDrawLine;
	[_heli, _c_rootLeadingEdge,  _d_tipLeadingEdge,    "red"]   call fza_fnc_debugDrawLine;
	[_heli, _d_tipLeadingEdge,   _e_tipTrailingEdge,   "white"] call fza_fnc_debugDrawLine;
	[_heli, _e_tipTrailingEdge,  _f_rootTrailingEdge,  "white"] call fza_fnc_debugDrawLine;
	[_heli, _f_rootTrailingEdge, _c_rootLeadingEdge,   "white"] call fza_fnc_debugDrawLine;
	#endif
};

// Average raw viRaw across blades, lerp toward it once, publish for next frame.
private _viAccum = (_heli getVariable "fza_sfmplus_rotorInducedFlowAccum") select _rotorIndex;
for "_ei" from 0 to (_numElements - 1) do {
    private _viRawAvg = (_viAccum select _ei) / _numBlades;
    private _viPrev   = ((_heli getVariable "fza_sfmplus_rotorInducedFlow") select _rotorIndex) select _ei;
    private _viNext   = [_viPrev, _viRawAvg, _inflowAlpha] call BIS_fnc_lerp;
    [_heli, "fza_sfmplus_rotorInducedFlow", _rotorIndex, _ei, _viNext] call fza_fnc_setMultiArrayVariable;
};

// Convert accumulated blade power to rotor shaft torque (Q = P / omega),
// then refer to engine shaft via gear ratio.
private _totalPower     = (_heli getVariable "fza_sfmplus_rotorReactionTorque") select _rotorIndex;
private _reactionTorque = if (_omega > 0.0) then { _totalPower / _omega } else { 0.0 };
private _reqEngTorque   = if (_gearRatio > 0.0) then { _reactionTorque / _gearRatio } else { 0.0 };
[_heli, "fza_sfmplus_reqEngTorque", _rotorIndex, _reqEngTorque, true] call fza_fnc_setArrayVariable;

private _rotorThrust = (_heli getVariable "fza_sfmplus_rotorThrustAccum") select _rotorIndex;
[_heli, "fza_sfmplus_rtrThrust", _rotorIndex, _rotorThrust, true] call fza_fnc_setArrayVariable;

private _Icm  = (1.0 / 3.0) * _bladeMass * (_bladeLength * _bladeLength);
private _Iy   = (1.0 / 12.0) * _bladeMass * (_bladeChord * _bladeChord);
private _Itot = _Icm;
private _Jtot = (_Iy + _Itot) * _numBlades;
[_heli, "fza_sfmplus_rtrMoi", _rotorIndex, _Jtot, true] call fza_fnc_setArrayVariable;

// Apply rotor drag torque reaction to fuselage — main rotor only, opposes rotation direction
if (_type == MAIN) then {
    private _torqueSign = if (_dir == CW) then { 1.0 } else { -1.0 };
    _heli addTorque (_heli vectorModelToWorld (_uVec vectorMultiply (_reactionTorque * _torqueSign * _deltaTime)));
};

}; // end damage check

#ifdef __A3_DEBUG__
[_heli, _pivot, _pos,                 "white"] call fza_fnc_debugDrawLine;
[_heli, _pos,   _pos vectorAdd _fVec, "green"] call fza_fnc_debugDrawLine;
[_heli, _pos,   _pos vectorAdd _rVec, "red"]   call fza_fnc_debugDrawLine;
[_heli, _pos,   _pos vectorAdd _uVec, "blue"]  call fza_fnc_debugDrawLine;
#endif
