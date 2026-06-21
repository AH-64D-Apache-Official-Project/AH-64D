params ["_heli", "_bladeIndex", "_rotorIndex", "_deltaTime", "_numElements", "_numBlades", "_pos", "_uVec", "_omega", "_airfoilTable", "_bladeCutout", "_bladeLength", "_inflowAlpha", "_a_rootPos", "_b_tipPos", "_c_rootLeadingEdge", "_d_tipLeadingEdge", "_e_tipTrailingEdge", "_f_rootTrailingEdge"];

private _rho              = _heli getVariable "fza_sfmplus_rho";
private _dissymetryOfLift = false;
private _totalFlapMoment  = 0.0;
private _totalPower       = (_heli getVariable "fza_sfmplus_rotorReactionTorque") select _rotorIndex;

private _bladeScale = 1.0;

[_heli, "fza_sfmplus_rotorFlapMoment", _rotorIndex, _bladeIndex, 0.0] call fza_fnc_setMultiArrayVariable;

for "_i" from 0 to (_numElements - 1) do {
	private _spanInboard  =  _i      / _numElements;
	private _spanOutboard = (_i + 1) / _numElements;

	private _a = _a_rootPos          vectorAdd ((_b_tipPos          vectorDiff _a_rootPos)          vectorMultiply _spanInboard);
	private _b = _a_rootPos          vectorAdd ((_b_tipPos          vectorDiff _a_rootPos)          vectorMultiply _spanOutboard);

	private _c = _c_rootLeadingEdge  vectorAdd ((_d_tipLeadingEdge  vectorDiff _c_rootLeadingEdge)  vectorMultiply _spanInboard);
	private _d = _c_rootLeadingEdge  vectorAdd ((_d_tipLeadingEdge  vectorDiff _c_rootLeadingEdge)  vectorMultiply _spanOutboard);
	private _e = _f_rootTrailingEdge vectorAdd ((_e_tipTrailingEdge vectorDiff _f_rootTrailingEdge) vectorMultiply _spanOutboard);
	private _f = _f_rootTrailingEdge vectorAdd ((_e_tipTrailingEdge vectorDiff _f_rootTrailingEdge) vectorMultiply _spanInboard);

	private _liftFraction = [0.5, 0.75] select (_numElements == 1);
	private _liftPos      = _a vectorAdd ((_b vectorDiff _a) vectorMultiply _liftFraction);

	private _chordLine = (_c vectorAdd ((_d vectorDiff _c) vectorMultiply 0.5)) vectorDiff (_f vectorAdd ((_e vectorDiff _f) vectorMultiply 0.5));
	_chordLine         = vectorNormalized _chordLine;

	#ifdef __A3_DEBUG__
	[_heli, _liftPos, _liftPos vectorAdd _chordLine, "white"] call fza_fnc_debugDrawLine;
	#endif

	// Induced inflow from previous frame — breaks the thrust/inflow circular dependency
	private _vi = ((_heli getVariable "fza_sfmplus_rotorInducedFlow") select _rotorIndex) select _i;

	private _velModel = _heli getVariable "fza_sfmplus_velModelSpace";
	private _relWind  = if (_dissymetryOfLift) then {
		_velModel vectorMultiply -1.0
	} else {
		[0.0, 0.0, -(_velModel select 2)]
	};

	private _spanDir    = vectorNormalized (_b vectorDiff _a);

	private _radialVec  = (_liftPos vectorDiff _pos) vectorDiff (_uVec vectorMultiply ((_liftPos vectorDiff _pos) vectorDotProduct _uVec));
	private _r          = vectorMagnitude _radialVec;
	private _rotRelWind = (_uVec vectorCrossProduct _spanDir) vectorMultiply (_r * _omega * -1.0);

	private _up = vectorNormalized (_spanDir vectorCrossProduct _chordLine);
	if ((_up vectorDotProduct _uVec) < 0.0) then { _up = _up vectorMultiply -1.0; };

	private _localWind   = _relWind vectorAdd _rotRelWind;

	// Freestream axial and lateral for Glauert inflow — freestream only, no rotation.
	private _vc          = _uVec vectorDotProduct _relWind;
	private _localAxial  = _uVec vectorMultiply _vc;
	private _localLatVel = vectorMagnitude (_relWind vectorDiff _localAxial);

	// Apply induced inflow downward through disc (opposes lift direction)
	private _inducedWind = _uVec vectorMultiply (-_vi);
	_relWind = _localWind vectorAdd _inducedWind;

	#ifdef __A3_DEBUG__
	[_heli, _liftPos vectorDiff (vectorNormalized _relWind), _liftPos, "red"]   call fza_fnc_debugDrawLine;
	[_heli, _liftPos, _liftPos vectorAdd _up,                          "white"] call fza_fnc_debugDrawLine;
	#endif

	private _relWindY = _chordLine vectorDotProduct _relWind;
	private _relWindZ = _up        vectorDotProduct _relWind;
	_relWind          = (_chordLine vectorMultiply _relWindY) vectorAdd (_up vectorMultiply _relWindZ);

	#ifdef __A3_DEBUG__
	[_heli, _liftPos vectorDiff (vectorNormalized _relWind), _liftPos, "green"] call fza_fnc_debugDrawLine;
	#endif

	private _relWindNormalized = vectorNormalized _relWind;
	private _AoA               = _chordLine vectorDotProduct (_relWindNormalized vectorMultiply -1.0);
	_AoA = [_AoA, -1.0, 1.0] call BIS_fnc_clamp;
	_AoA = acos _AoA;

	if ((_up vectorDotProduct _relWindNormalized) < 0.0) then { _AoA = _AoA * -1.0; };

	private _area = [_c, _d, _e, _f] call fza_fnc_getArea;
	private _v    = vectorMagnitude _relWind;
	private _q    = 0.5 * _rho * _area * (_v * _v);

	private _CL = [_airfoilTable, _AoA] call fza_fnc_linearInterp select 1;
	private _CD = [_airfoilTable, _AoA] call fza_fnc_linearInterp select 2;

	private _lift = _CL * _q;
	private _drag = (_CD min 0.15) * _q;

	// Update induced inflow velocity for this element via Glauert inflow model.
	// Accounts for axial (climb/descent) and lateral (forward flight) freestream,
	// unlike the hover-only sqrt(T/2rhoA) formula.
	private _r_in  = _bladeCutout + (_spanInboard  * (_bladeLength - _bladeCutout));
	private _r_out = _bladeCutout + (_spanOutboard  * (_bladeLength - _bladeCutout));
	private _annularArea = pi * ((_r_out * _r_out) - (_r_in * _r_in));
	// Compute raw inflow for this element and accumulate across blades.
	// The lerp toward viRaw is applied once in fn_rotor after averaging, not here.
	private _viRaw = if ((_annularArea > 0.0) && (_rho > 0.0)) then {
		private _T_elem = _lift * _bladeScale;
		private _denom  = 2.0 * _rho * _annularArea * (sqrt (((_vc + _vi) * (_vc + _vi)) + (_localLatVel * _localLatVel)));
		private _raw    = if (_denom > 0.0) then { _T_elem / _denom } else { 0.0 };
		[_raw, -25.0, 25.0] call BIS_fnc_clamp
	} else { 0.0 };
	private _viAccum = ((_heli getVariable "fza_sfmplus_rotorInducedFlowAccum") select _rotorIndex) select _i;
	[_heli, "fza_sfmplus_rotorInducedFlowAccum", _rotorIndex, _i, (_viAccum + _viRaw)] call fza_fnc_setMultiArrayVariable;

	_totalFlapMoment = _totalFlapMoment + (_lift * _r);

	private _liftVector = _relWindNormalized vectorCrossProduct _up;
	_liftVector         = _liftVector vectorCrossProduct _relWindNormalized;
	private _liftDir    = vectorNormalized _liftVector;
	private _dragDir    = vectorNormalized _relWind;

	// Power-based rotor load:
	// Induced power = thrust element * induced inflow velocity (energy spent accelerating air downward)
	// Profile power = drag force * tangential blade speed (energy spent overcoming blade drag)
	// Both oppose rotation; sum gives total shaft power consumed by this element.
	private _vTangential  = _r * _omega;
	private _P_induced    = _lift * _vi;
	private _P_profile    = _drag * _vTangential;
	_totalPower = _totalPower + (_P_induced + _P_profile) * _bladeScale;


	private _thrustAccum = (_heli getVariable "fza_sfmplus_rotorThrustAccum") select _rotorIndex;
	[_heli, "fza_sfmplus_rotorThrustAccum", _rotorIndex, (_thrustAccum + (_lift * _bladeScale))] call fza_fnc_setArrayVariable;

	_liftVector = _liftDir vectorMultiply (_lift * _deltaTime * _bladeScale);

	private _dragVector = _dragDir vectorMultiply (_drag * _deltaTime * _bladeScale * -1.0);

	_heli addForce [_heli vectorModelToWorld _liftVector, _liftPos];
	_heli addForce [_heli vectorModelToWorld _dragVector, _liftPos];


	#ifdef __A3_DEBUG__
	[_heli, _liftPos, _liftPos vectorAdd (_liftVector vectorMultiply (1.0 / 30.0)), "green"] call fza_fnc_debugDrawLine;
	[_heli, _liftPos, _liftPos vectorAdd (_dragVector vectorMultiply (1.0 / 30.0)), "red"]   call fza_fnc_debugDrawLine;
	[_heli, _c, _f, "red"] call fza_fnc_debugDrawLine;
	[_heli, _d, _e, "red"] call fza_fnc_debugDrawLine;
	#endif
};

[_heli, "fza_sfmplus_rotorFlapMoment", _rotorIndex, _bladeIndex, _totalFlapMoment] call fza_fnc_setMultiArrayVariable;

[_heli, "fza_sfmplus_rotorReactionTorque", _rotorIndex, _totalPower] call fza_fnc_setArrayVariable;
