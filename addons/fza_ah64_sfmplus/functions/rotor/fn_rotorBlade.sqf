params ["_heli", "_index", "_deltaTime", "_numElements", "_pos", "_uVec", "_omega", "_airfoilTable", "_a_rootPos", "_b_tipPos", "_c_rootLeadingEdge", "_d_tipLeadingEdge", "_e_tipTrailingEdge", "_f_rootTrailingEdge"];

private _rho     = _heli getVariable "fza_sfmplus_rho";
private _heliCOM = getCenterOfMass _heli;

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

	private _chordLine   = (_c vectorAdd ((_d vectorDiff _c) vectorMultiply 0.5)) vectorDiff (_f vectorAdd ((_e vectorDiff _f) vectorMultiply 0.5));
	private _chordLength = vectorMagnitude  _chordLine;
	_chordLine           = vectorNormalized _chordLine;

	#ifdef __A3_DEBUG__
	//Chordline
	[_heli, _liftPos, _liftPos vectorAdd _chordLine, "white"] call fza_fnc_debugDrawLine;
	#endif

    private _relativeWind = (_heli getVariable "fza_sfmplus_velModelSpace") vectorMultiply -1.0;

    private _spanDir             = vectorNormalized (_b vectorDiff _a);
    private _fromAeroCenterToCOM = _liftPos vectorDiff _heliCOM;
    private _angularVel          = (_heli getVariable "fza_sfmplus_angVelModelSpace");

    private _localRelWind = _angularVel vectorCrossProduct _fromAeroCenterToCOM;

	private _radialVec  = (_liftPos vectorDiff _pos) vectorDiff (_uVec vectorMultiply ((_liftPos vectorDiff _pos) vectorDotProduct _uVec));
	private _r          = vectorMagnitude _radialVec;
	private _rotRelWind = (_uVec vectorCrossProduct _spanDir) vectorMultiply (_r * _omega * -1.0);
    
	_relativeWind       = _relativeWind vectorAdd _localRelWind vectorAdd _rotRelWind;

    #ifdef __A3_DEBUG__
    [_heli, _liftPos vectorDiff (vectorNormalized _relativeWind), _liftPos, "red"] call fza_fnc_debugDrawLine;
    #endif

    private _up = vectorNormalized (_spanDir vectorCrossProduct _chordLine);

    #ifdef __A3_DEBUG__
    [_heli, _liftPos, _liftPos vectorAdd _up, "white"] call fza_fnc_debugDrawLine;
    #endif

    private _relWindY = _chordLine vectorDotProduct _relativeWind;
    private _relWindZ = _up        vectorDotProduct _relativeWind;
    _relativeWind     = (_chordLine vectorMultiply _relWindY) vectorAdd (_up vectorMultiply _relWindZ);

    #ifdef __A3_DEBUG__
    [_heli, _liftPos vectorDiff (vectorNormalized _relativeWind), _liftPos, "green"] call fza_fnc_debugDrawLine;
    #endif

    private _relativeWindNormalized = vectorNormalized _relativeWind;
    private _AoA                    = _chordLine vectorDotProduct (_relativeWindNormalized vectorMultiply -1.0);
    _AoA = [_AoA, -1.0, 1.0] call BIS_fnc_clamp;
    _AoA = acos _AoA;

    private _yAxisDotRelativeWind = _up vectorDotProduct _relativeWindNormalized;
    if (_yAxisDotRelativeWind < 0.0) then {
        _AoA = _AoA * -1.0;
    };

	systemChat format ["Rotor %1 blade %2 AoA = %3", _index, _i, _AoA];

	private _area = [_c, _d, _e, _f] call fza_fnc_getArea;
    private _v      = vectorMagnitude _relativeWind;
    private _CL_0   = [_airfoilTable, _AoA] call fza_fnc_linearInterp select 1;
    private _CD_0   = [_airfoilTable, _AoA] call fza_fnc_linearInterp select 2;
    private _lift_0 = _CL_0 * 0.5 * _rho * _area * (_v * _v);
    private _drag_0 = _CD_0 * 0.5 * _rho * _area * (_v * _v);

	private _CL   = _lift_0 / (0.5 * _rho * _area * _v * _v);
	private _CD   = _drag_0 / (0.5 * _rho * _area * _v * _v);

    private _lift = _CL * 0.5 * _rho * _area * (_v * _v);
    private _drag = _CD * 0.5 * _rho * _area * (_v * _v);

    private _liftVector = _relativeWindNormalized vectorCrossProduct _up;
    _liftVector         = _liftVector vectorCrossProduct _relativeWindNormalized;
    _liftVector         = vectorNormalized _liftVector;
    _liftVector         = _liftVector vectorMultiply (_lift * _deltaTime);

    private _dragVector = (vectorNormalized _relativeWind) vectorMultiply -1.0;
    _dragVector         = _dragVector vectorMultiply (_drag * _deltaTime);

    _heli addForce [_heli vectorModelToWorld _liftVector, _liftPos];
    _heli addForce [_heli vectorModelToWorld _dragVector, _liftPos];

	#ifdef __A3_DEBUG__
	[_heli, _liftPos, _liftPos vectorAdd (_liftVector vectorMultiply (1.0 / 30.0)), "green"] call fza_fnc_debugDrawLine;
	[_heli, _liftPos, _liftPos vectorAdd (_dragVector vectorMultiply (1.0 / 30.0)), "red"]   call fza_fnc_debugDrawLine;
	//Blade
	[_heli, _c, _f, "red"] call fza_fnc_debugDrawLine;
	[_heli, _d, _e, "red"] call fza_fnc_debugDrawLine;
	#endif
};
