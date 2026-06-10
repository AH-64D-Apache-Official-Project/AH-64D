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

systemChat format ["flapDyn enter ri=%1 mass=%2 len=%3 cut=%4", _rotorIndex, _bladeMass, _bladeLength, _bladeCutout];
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
for "_bladeIndex" from 0 to 3 do {
    private _bDir_i = [_rVec, _uVec, (_bladeAzimuths select _bladeIndex)] call fza_sfmplus_fnc_vectorRotateAroundAxis;
    private _m      = _flapMoments select _bladeIndex;
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
private _beta0Target = [(_heli getVariable "fza_sfmplus_rotorBeta0Target") select _rotorIndex, _beta0Raw, (_deltaTime / _revPeriod)] call BIS_fnc_lerp;
private _a1Target    = [(_heli getVariable "fza_sfmplus_rotorA1Target")    select _rotorIndex, _a1Raw,    (_deltaTime / _revPeriod)] call BIS_fnc_lerp;
private _b1Target    = [(_heli getVariable "fza_sfmplus_rotorB1Target")    select _rotorIndex, _b1Raw,    (_deltaTime / _revPeriod)] call BIS_fnc_lerp;
[_heli, "fza_sfmplus_rotorBeta0Target", _rotorIndex, _beta0Target] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_rotorA1Target",    _rotorIndex, _a1Target]    call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_rotorB1Target",    _rotorIndex, _b1Target]    call fza_fnc_setArrayVariable;

// Main disc tilt filter — physical lag representing rotor disc inertia
// Tail rotor has no coning hinge so beta0 is always zero
private _beta0 = if (_type == TAIL) then { 0.0 } else { [(_heli getVariable "fza_sfmplus_rotorBeta0") select _rotorIndex, _beta0Target, (_deltaTime / _flapTimeConst)] call BIS_fnc_lerp };
private _a1    = [(_heli getVariable "fza_sfmplus_rotorA1") select _rotorIndex, _a1Target, (_deltaTime / _flapTimeConst)] call BIS_fnc_lerp;
private _b1    = [(_heli getVariable "fza_sfmplus_rotorB1") select _rotorIndex, _b1Target, (_deltaTime / _flapTimeConst)] call BIS_fnc_lerp;
[_heli, "fza_sfmplus_rotorBeta0", _rotorIndex, _beta0] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_rotorA1",    _rotorIndex, _a1]    call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_rotorB1",    _rotorIndex, _b1]    call fza_fnc_setArrayVariable;

systemChat format ["flapDyn ri=%1 beta0=%2 a1=%3 b1=%4", _rotorIndex, _beta0, _a1, _b1];
[_beta0, _a1, _b1]
