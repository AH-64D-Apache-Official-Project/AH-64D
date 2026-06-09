/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_rotorFlapDynamics

Description:
    Computes dynamic blade flapping coefficients (beta0, a1, b1) from
    per-blade aerodynamic flap moments accumulated by fn_rotorBlade.
    Returns [beta0, a1, b1] in degrees.

Parameters:
    _heli          - The helicopter [Unit]
    _deltaTime     - Frame delta time [Number]
    _numBlades     - Number of rotor blades [Number]
    _omega         - Rotor angular velocity (rad/s) [Number]
    _bladeMass     - Single blade mass (kg) [Number]
    _bladeLength   - Blade radius (m) [Number]
    _bladeCutout   - Blade root cutout radius (m) [Number]
    _flapTimeConst - Disc tilt time constant (s) [Number]
    _rVec          - Hub right vector [Array]
    _fVec          - Hub forward vector [Array]
    _uVec          - Hub up vector [Array]

Returns:
    [beta0, a1, b1] — collective coning and cyclic tilt angles (degrees)
---------------------------------------------------------------------------- */
params ["_heli", "_deltaTime", "_numBlades", "_omega", "_bladeMass", "_bladeLength", "_bladeCutout", "_flapTimeConst", "_rVec", "_fVec", "_uVec"];

private _Ib       = (1.0 / 3.0) * _bladeMass * (_bladeLength * _bladeLength);
private _bladeCGR = _bladeCutout + ((_bladeLength - _bladeCutout) * 0.5);
private _M_grav   = -_bladeMass * 9.806 * _bladeCGR;
private _denom    = if (_omega > 1.0) then { _Ib * (_omega * _omega) } else { 0.0 };

// Fourier decomposition: project per-blade moments onto body-frame axes
private _flapMoments   = _heli getVariable "fza_sfmplus_rotorFlapMoment";
private _bladeAzimuths = _heli getVariable "fza_sfmplus_rotorBladeAzimuth";
private _M0   = 0.0;
private _Mlat = 0.0;
private _Mlon = 0.0;
for "_i" from 0 to 3 do {
    private _bDir_i = [_rVec, _uVec, (_bladeAzimuths select _i)] call fza_sfmplus_fnc_vectorRotateAroundAxis;
    private _m      = _flapMoments select _i;
    _M0   = _M0   + _m;
    _Mlat = _Mlat + (_m * (_bDir_i vectorDotProduct _rVec));
    _Mlon = _Mlon + (_m * (_bDir_i vectorDotProduct _fVec));
};
_M0   = (_M0   / 4.0) * (_numBlades / 4.0);
_Mlat = (_Mlat / 2.0) * (_numBlades / 4.0);
_Mlon = (_Mlon / 2.0) * (_numBlades / 4.0);

// Raw equilibrium targets from this frame's moments
private _beta0Raw = if (_denom > 0.0) then { [(_M0 / _denom + _M_grav / _denom) * (180 / pi), -15.0, 15.0] call BIS_fnc_clamp } else { 0.0 };
private _a1Raw    = if (_denom > 0.0) then { [_Mlon / _denom * (180 / pi), -15.0, 15.0] call BIS_fnc_clamp } else { 0.0 };
private _b1Raw    = if (_denom > 0.0) then { [_Mlat / _denom * (180 / pi), -15.0, 15.0] call BIS_fnc_clamp } else { 0.0 };

// Pre-filter: average over one rotor revolution to suppress per-frame moment noise
private _revPeriod   = if (_omega > 1.0) then { (2.0 * pi) / _omega } else { _flapTimeConst };
private _beta0Target = [_heli getVariable "fza_sfmplus_rotorBeta0Target", _beta0Raw, (_deltaTime / _revPeriod)] call BIS_fnc_lerp;
private _a1Target    = [_heli getVariable "fza_sfmplus_rotorA1Target",    _a1Raw,    (_deltaTime / _revPeriod)] call BIS_fnc_lerp;
private _b1Target    = [_heli getVariable "fza_sfmplus_rotorB1Target",    _b1Raw,    (_deltaTime / _revPeriod)] call BIS_fnc_lerp;
_heli setVariable ["fza_sfmplus_rotorBeta0Target", _beta0Target];
_heli setVariable ["fza_sfmplus_rotorA1Target",    _a1Target];
_heli setVariable ["fza_sfmplus_rotorB1Target",    _b1Target];

// Main disc tilt filter — physical lag representing rotor disc inertia
private _beta0 = [_heli getVariable "fza_sfmplus_rotorBeta0", _beta0Target, (_deltaTime / _flapTimeConst)] call BIS_fnc_lerp;
private _a1    = [_heli getVariable "fza_sfmplus_rotorA1",    _a1Target,    (_deltaTime / _flapTimeConst)] call BIS_fnc_lerp;
private _b1    = [_heli getVariable "fza_sfmplus_rotorB1",    _b1Target,    (_deltaTime / _flapTimeConst)] call BIS_fnc_lerp;
_heli setVariable ["fza_sfmplus_rotorBeta0", _beta0];
_heli setVariable ["fza_sfmplus_rotorA1",    _a1];
_heli setVariable ["fza_sfmplus_rotorB1",    _b1];

[_beta0, _a1, _b1]
