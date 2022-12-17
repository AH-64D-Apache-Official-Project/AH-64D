params ["_heli", "_deltaTime", "_rho", "_isTailRotor", "_u_w", "_v_w", "_w_w", "_omegaR", "_theta0_deg", "_rotorParams", "_gndEffScalar", "_thrustScalar"];
#include "\bmk_helisim\headers\core.hpp"

_rotorParams 
    params ["_a", "_type", "_b", "_h", "_R", "_c", "_theta1_deg", "_m", "_eR", "_e", "_gearRatio", "_Ib", "_s", "_polarMOI", "_inputMaps"];

private _nu      = 0.0;
private _lambda  = 0.0;
if (!_isTailRotor) then {
    _nu      = _heli getVariable "bmk_helisim_mainRotor_nu";
    _lambda  = _heli getVariable "bmk_helisim_mainRotor_lambda";
} else {
    _nu      = _heli getVariable "bmk_helisim_tailRotor_nu";
    _lambda  = _heli getVariable "bmk_helisim_tailRotor_lambda";
};
private _thrust  = 0.0;
private _CTSigma = 0.0; 
private _CT      = 0.0;
private ["_ct_0", "_ct_1", "_ct_2", "_ct_3"];

//SH79, eqn 24
private _mu = if (_omegaR == 0) then { 0.0; } else { _u_w / _omegaR; };
if (_mu > 0.7) then { _mu = 0.7; };
if (not finite _mu) then { _mu = 0.0; };

_ct_2 = (1.0 / 3.0 * (B * B * B) + 1.0 / 2.0 * B * (_mu * _mu) - 4.0 / (9.0 * pi) * (_mu * _mu * _mu)) * (rad _theta0_deg);
_ct_3 = (1.0 / 4.0 * (B * B * B * B) + 1.0 / 4.0 * (B * B) * (_mu * _mu)) * (rad _theta1_deg);

_ct_1 = (1.0 / 2.0 * (B * B) + 1.0 / 4.0 * (_mu * _mu)) * _lambda;

_ct_0 = (_a / 2.0) * (_ct_1 + _ct_2 + _ct_3) * _s;
_ct_0 = if (_lambda == 0) then { 0.0; } else { _ct_0 / (2.0 * sqrt ((_mu * _mu) + (_lambda * _lambda))); };

_nu = _gndEffScalar * ((_nu - _ct_0) * exp (-_deltaTime / TAU_LAMBDA) + _ct_0);
if (not finite _nu) then { _nu = 0.0; };

//SH79, eqn 25
_lambda = if (_omegaR == 0) then { 0.0; } else { _w_w / _omegaR - _nu; };
if (not finite _lambda) then { _lambda = 0.0; };

_ct_1 = (1.0 / 2.0 * (B * B) + 1.0 / 4.0 * (_mu * _mu)) * _lambda;

//SH79, eqn 27
_CTSigma = (_a / 2.0) * (_ct_1 + _ct_2 + _ct_3);
_CT      = _CTSigma * _s;

_thrust = _thrustScalar * (_b * _c * _R * _rho * (_omegaR * _omegaR) * _CTSigma);

//systemChat format ["Vi: %1", _nu * _omegaR];

if (!_isTailRotor) then {
    _heli setVariable ["bmk_helisim_mainRotor_nu",     _nu];
    _heli setVariable ["bmk_helisim_mainRotor_lambda", _lambda];
} else {
    _heli setVariable ["bmk_helisim_tailRotor_nu",     _nu];
    _heli setVariable ["bmk_helisim_tailRotor_lambda", _lambda];
};

[_mu, _thrust, _lambda, _CT];