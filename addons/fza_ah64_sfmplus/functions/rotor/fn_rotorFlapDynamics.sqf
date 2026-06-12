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
#include "\fza_ah64_sfmplus\functions\rotor\rotor.hpp"

params ["_heli", "_rotorIndex", "_type", "_deltaTime", "_numBlades", "_omega", "_bladeMass", "_bladeLength", "_bladeCutout", "_flapTimeConst", "_rVec", "_fVec", "_uVec"];
private _flapTimeConstPitch = _flapTimeConst select 0;
private _flapTimeConstRoll  = _flapTimeConst select 1;

private _Ib       = (1.0 / 3.0) * _bladeMass * (_bladeLength * _bladeLength);
private _bladeCGR = _bladeCutout + ((_bladeLength - _bladeCutout) * 0.5);
private _M_grav   = -_bladeMass * 9.806 * _bladeCGR;
private _denom    = if (_omega > 1.0) then { _Ib * (_omega * _omega) } else { 0.0 };

// Fourier decomposition: project per-blade moments onto body-frame axes
private _flapMoments   = (_heli getVariable "fza_sfmplus_rotorFlapMoment")   select _rotorIndex;
private _bladeAzimuths = (_heli getVariable "fza_sfmplus_rotorBladeAzimuth") select _rotorIndex;
private _M0   = 0.0;
private _Mlat = 0.0;
private _Mlon = 0.0;
for "_bladeIndex" from 0 to (_numBlades - 1) do {
    private _bDir_i = [_rVec, _uVec, (_bladeAzimuths select _bladeIndex)] call fza_sfmplus_fnc_vectorRotateAroundAxis;
    private _m      = _flapMoments select _bladeIndex;
    _M0   = _M0   + _m;
    _Mlat = _Mlat + (_m * (_bDir_i vectorDotProduct _rVec));
    _Mlon = _Mlon + (_m * (_bDir_i vectorDotProduct _fVec));
};
_M0   = _M0   / _numBlades;
_Mlat = _Mlat / (_numBlades / 2.0);
_Mlon = _Mlon / (_numBlades / 2.0);

// Raw equilibrium targets from this frame's moments.
// Gyroscopic precession shifts disc response 90° from the forcing azimuth:
// a moment on the lateral axis (advancing/retreating) tilts the disc longitudinally, and vice versa.
private _beta0Raw = if (_denom > 0.0) then { [(_M0 / _denom + _M_grav / _denom) * (180 / pi), -15.0, 15.0] call BIS_fnc_clamp } else { 0.0 };
private _a1Raw    = if (_denom > 0.0) then { [_Mlat / _denom * (180 / pi), -15.0, 15.0] call BIS_fnc_clamp } else { 0.0 };
private _b1Raw    = if (_denom > 0.0) then { [_Mlon / _denom * (180 / pi), -15.0, 15.0] call BIS_fnc_clamp } else { 0.0 };

private _isTeetering = (_type == MAIN) && (_numBlades == 2);

// Pre-filter: average over one rotor revolution to suppress per-frame moment noise.
// a1 bypasses the pre-filter — it responds to DoL which changes continuously with airspeed,
// and the extra lag from two filters in series causes high-speed roll oscillation.
private _revPeriod   = if (_omega > 1.0) then { (2.0 * pi) / _omega } else { _flapTimeConstPitch };
// Teetering rotor averages over a full revolution — the teeter plane completes one cycle per rev
// Multi-blade rotors average over one blade-passing period
private _bladePeriod = if (_isTeetering) then { _revPeriod } else { if (_numBlades > 0) then { _revPeriod / _numBlades } else { _revPeriod } };
private _bladeAlpha  = if (_bladePeriod > 0.0) then { [_deltaTime / _bladePeriod, 0.0, 1.0] call BIS_fnc_clamp } else { 1.0 };
private _beta0Target = [(_heli getVariable "fza_sfmplus_rotorBeta0Target") select _rotorIndex, _beta0Raw, _bladeAlpha] call BIS_fnc_lerp;
private _a1Target    = [(_heli getVariable "fza_sfmplus_rotorA1Target")    select _rotorIndex, _a1Raw,    _bladeAlpha] call BIS_fnc_lerp;
private _b1Target    = [(_heli getVariable "fza_sfmplus_rotorB1Target")    select _rotorIndex, _b1Raw,    _bladeAlpha] call BIS_fnc_lerp;
[_heli, "fza_sfmplus_rotorBeta0Target", _rotorIndex, _beta0Target] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_rotorA1Target",    _rotorIndex, _a1Target]    call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_rotorB1Target",    _rotorIndex, _b1Target]    call fza_fnc_setArrayVariable;

// Main disc tilt filter — physical lag representing rotor disc inertia
// Tail rotor has no flapping hinge — all flap coefficients are zero
// Teetering rotor (2-blade) has no coning — beta0 is zero, only a1/b1 describe teeter plane
private _beta0 = if (_type == TAIL || _isTeetering) then { 0.0 } else { [(_heli getVariable "fza_sfmplus_rotorBeta0") select _rotorIndex, _beta0Target, (_deltaTime / _flapTimeConstPitch)] call BIS_fnc_lerp };
private _a1    = if (_type == TAIL) then { 0.0 } else { [(_heli getVariable "fza_sfmplus_rotorA1")    select _rotorIndex, _a1Target,    (_deltaTime / _flapTimeConstPitch)] call BIS_fnc_lerp };
private _b1    = if (_type == TAIL) then { 0.0 } else { [(_heli getVariable "fza_sfmplus_rotorB1")    select _rotorIndex, _b1Target,    (_deltaTime / _flapTimeConstRoll)]  call BIS_fnc_lerp };
[_heli, "fza_sfmplus_rotorBeta0", _rotorIndex, _beta0] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_rotorA1",    _rotorIndex, _a1]    call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_rotorB1",    _rotorIndex, _b1]    call fza_fnc_setArrayVariable;

[_beta0, _a1, _b1]
