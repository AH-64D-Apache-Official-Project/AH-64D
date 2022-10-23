params ["_heli", "_deltaTime", "_rho", "_u_w", "_v_w", "_w_w", "_omegaR", "_theta0_deg", "_rotorParams", "_gndEffScalar", "_thrustScalar"];
#include "\bmk_helisim\headers\core.hpp"

_rotorParams params ["_a", "_b", "_R", "_c", "_theta1_deg", "_m", "_eR", "_e", "_gearRatio", "_Ib", "_s"];

private _nu      = _heli getVariable "bmk_helisim_mainRotor_nu";
private _lambda  = _heli getVariable "bmk_helisim_mainRotor_lambda";
private _thrust  = 0.0;
private _CTSigma = 0.0; 
private _CT      = 0.0;
private ["_ct_0", "_ct_1", "_ct_2", "_ct_3"];

//SH79, eqn 24
private _mu = if (_omegaR == 0) then { 0.0; } else { _u_w / _omegaR; };
if (_mu > 0.7) then { _mu = 0.7; };

_ct_2 = (1.0 / 3.0 * (B * B * B) + 1.0 / 2.0 * B * (_mu * _mu) - 4.0 / (9.0 * pi) * (_mu * _mu * _mu)) * (rad _theta0_deg);
_ct_3 = (1.0 / 4.0 * (B * B * B * B) + 1.0 / 4.0 * (B * B) * (_mu * _mu)) * (rad _theta1_deg);

_ct_1 = (1.0 / 2.0 * (B * B) + 1.0 / 4.0 * (_mu * _mu)) * _lambda;

_ct_0 = (_a / 2.0) * (_ct_1 + _ct_2 + _ct_3) * _s;
_ct_0 = if (_lambda == 0) then { 0.0; } else { _ct_0 / (2.0 * sqrt ((_mu * _mu) + (_lambda * _lambda))); };

_nu = _gndEffScalar * ((_nu - _ct_0) * exp (-_deltaTime / TAU_LAMBDA) + _ct_0);

//SH79, eqn 25
_lambda = if (_omegaR == 0) then { 0.0; } else { _w_w / _omegaR - _nu; };

_ct_1 = (1.0 / 2.0 * (B * B) + 1.0 / 4.0 * (_mu * _mu)) * _lambda;

//SH79, eqn 27
_CTSigma = (_a / 2.0) * (_ct_1 + _ct_2 + _ct_3);
_CT      = _CTSigma * _s;

_thrust = _thrustScalar * (_b * _c * _R * _rho * (_omegaR * _omegaR) * _CTSigma);

//systemChat format ["Vi: %1", _nu * _omegaR];

_heli setVariable ["bmk_helisim_mainrotor_nu",     _nu];
_heli setVariable ["bmk_helisim_mainrotor_lambda", _lambda];

[_mu, _thrust, _lambda, _CT];