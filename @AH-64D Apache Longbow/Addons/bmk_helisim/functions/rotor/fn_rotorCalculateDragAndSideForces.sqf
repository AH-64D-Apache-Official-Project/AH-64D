params ["_heli", "_mu", "_lambda", "_theta75_deg", "_q_w", "_gamma", "_omega", "_omegaR", "_CT", "_rotorParams", "_thrust", "_rho", "_a0_deg", "_a1_deg", "_b1_deg"];
#include "\bmk_helisim\headers\core.hpp"

_rotorParams 
    params ["_a", "_type", "_b", "_h", "_R", "_c", "_theta1_deg", "_m", "_eR", "_e", "_gearRatio", "_thrustScalar", "_Ib", "_s", "_polarMOI", "_inputMaps"];

private _CYSigma = 0.0; private _aI = 0.0; private _H = 0.0; private _J = 0.0;
private ["_aI_1", "_aI_2", "_aI_3", "_aI_4"];
private ["_CYSigma_1", "_CYSigma_2", "_CYSigma_3", "_CYSigma_4", "_CYSigma_5", "_CYSigma_6"];

_aI_1 = if (_mu == 0.0) then { 0.0; } else { 1.0 / (1.0 - ((_mu * _mu) / (2.0 * (B * B)))); };
_aI_2 = if (_mu == 0.0) then { 0.0; } else { (2.0 * _lambda + (8.0 / 3.0) * (rad _theta75_deg)) * _mu; };
_aI_3 = if (_omega == 0.0) then { 0.0; } else { 24.0 * _q_w / ((B * B * B * B) * _gamma * _omega); };
_aI_4 = if (_CT == 0.0) then { 0.0; } else { 1.0 - ((0.29 * (rad _theta75_deg)) / (_CT / _s)); };

_aI = _aI_1 * (_aI_2 - _aI_3 * _aI_4);

_H  = _thrust * _aI;

_CYSigma_1 = (3.0 / 4.0) * (rad _b1_deg) * _lambda;
_CYSigma_2 = if (_mu == 0.0) then { 0.0; } else { (3.0 / 2.0) * (rad _a0_deg) * _mu * _lambda; };
_CYSigma_3 = if (_mu == 0.0) then { 0.0; } else { (1.0 / 4.0) * (rad _a1_deg) * (rad _b1_deg) * _mu; };
_CYSigma_4 = if (_mu == 0.0) then { 0.0; } else { (rad _a0_deg) * (rad _a1_deg) * (_mu * _mu); };
_CYSigma_5 = (1.0 / 6.0) * (rad _a0_deg) * (rad _a1_deg);
_CYSigma_6 = ((3.0 / 4.0) * _mu * (rad _a0_deg) - (1.0 / 3.0) * (rad _b1_deg) - (1.0 / 2.0) * (_mu * _mu) * (rad _b1_deg)) * (rad _theta75_deg);

_CYSigma = (_a / 2.0) * (_CYSigma_1 - _CYSigma_2 + _CYSigma_3 - _CYSigma_4 + _CYSigma_5 - _CYSigma_6);

_J = if (_omegaR == 0.0) then { 0.0; } else { _b * _c * _R * _rho * (_omegaR * _omegaR) * _CYSigma; };

[_H, _J];