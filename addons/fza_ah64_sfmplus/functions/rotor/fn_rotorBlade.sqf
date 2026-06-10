params ["_heli", "_bladeIndex", "_rotorIndex", "_deltaTime", "_numElements", "_numBlades", "_pos", "_uVec", "_omega", "_airfoilTable", "_a_rootPos", "_b_tipPos", "_c_rootLeadingEdge", "_d_tipLeadingEdge", "_e_tipTrailingEdge", "_f_rootTrailingEdge"];

private _rho              = _heli getVariable "fza_sfmplus_rho";
private _heliCOM          = getCenterOfMass _heli;
private _dissymetryOfLift = false;
private _totalFlapMoment  = 0.0;

// 4 virtual blades always run; scale forces so total matches the real blade count
private _bladeScale = _numBlades / 4.0;

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

	private _liftFraction = if (_numElements == 1) then { 0.75 } else { 0.5 };
	private _liftPos      = _a vectorAdd ((_b vectorDiff _a) vectorMultiply _liftFraction);

	private _chordLine = (_c vectorAdd ((_d vectorDiff _c) vectorMultiply 0.5)) vectorDiff (_f vectorAdd ((_e vectorDiff _f) vectorMultiply 0.5));
	_chordLine         = vectorNormalized _chordLine;

	#ifdef __A3_DEBUG__
	[_heli, _liftPos, _liftPos vectorAdd _chordLine, "white"] call fza_fnc_debugDrawLine;
	#endif

	private _velModel = _heli getVariable "fza_sfmplus_velModelSpace";
	private _relWind  = if (_dissymetryOfLift) then {
		_velModel vectorMultiply -1.0
	} else {
		[0.0, 0.0, -(_velModel select 2)]
	};

	private _spanDir             = vectorNormalized (_b vectorDiff _a);
	private _fromAeroCenterToCOM = _liftPos vectorDiff _heliCOM;
	private _angularVel          = _heli getVariable "fza_sfmplus_angVelModelSpace";
	private _localRelWind        = _angularVel vectorCrossProduct _fromAeroCenterToCOM;

	private _radialVec  = (_liftPos vectorDiff _pos) vectorDiff (_uVec vectorMultiply ((_liftPos vectorDiff _pos) vectorDotProduct _uVec));
	private _r          = vectorMagnitude _radialVec;
	//systemChat format ["%1 - %2 - %3 - %4", _uVec, _spanDir, _r, _omega];
	private _rotRelWind = (_uVec vectorCrossProduct _spanDir) vectorMultiply (_r * _omega * -1.0);

	private _up = vectorNormalized (_spanDir vectorCrossProduct _chordLine);

	_relWind = _relWind vectorAdd _localRelWind vectorAdd _rotRelWind;

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
	private _drag = _CD * _q;

	_totalFlapMoment = _totalFlapMoment + (_lift * _r);

	private _liftVector = _relWindNormalized vectorCrossProduct _up;
	_liftVector         = _liftVector vectorCrossProduct _relWindNormalized;
	_liftVector         = (vectorNormalized _liftVector) vectorMultiply (_lift * _deltaTime * _bladeScale);

	private _dragVector = (vectorNormalized _relWind) vectorMultiply (_drag * _deltaTime * _bladeScale * -1.0);

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
