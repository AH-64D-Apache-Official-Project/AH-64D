params ["_heli", "_mu", "_lambda", "_theta75_deg", "_q_w", "_gamma", "_omega", "_omegaR", "_CT", "_rotorParams", "_thrust", "_rho", "_a0_deg", "_a1_deg", "_b1_deg"];
#include "\bmk_helisim\headers\core.hpp"

_rotorParams 
    params ["_a", "_type", "_b", "_h", "_R", "_c", "_theta1_deg", "_m", "_eR", "_e", "_gearRatio", "_thrustScalar", "_Ib", "_s", "_polarMOI", "_inputMaps"];

private _aI = 0.0; private _Hdrag = 0.0; 
private _aI_1 = 0.0; private _aI_2 = 0.0; private _aI_3 = 0.0; private _aI_4 = 0.0;

_aI_1 = if (_mu == 0.0) then { 0.0; } else { 1.0 / (1.0 - (_mu^2 / (2.0 * TIP_LOSS^2))); };
_aI_2 = (2.0 * _lambda + (8.0 / 3.0) * (rad _theta75_deg)) * _mu;
_aI_3 = if (_omega == 0.0) then { 0.0; } else { 24.0 * _q_w / (TIP_LOSS^4 * _gamma * _omega); };
_aI_4 = 1.0 - ((0.29 * (rad _theta75_deg)) / (_CT / _s));

_aI = _aI_1 * (_aI_2 - _aI_3 * _aI_4);

_Hdrag  = _thrust * _aI;

private _CYSigma = 0.0; private _Jside = 0.0;
private _CYSigma_1 = 0.0; private _CYSigma_2 = 0.0; private _CYSigma_3 = 0.0; private _CYSigma_4 = 0.0; private _CYSigma_5 = 0.0; private _CYSigma_6 = 0.0;

_CYSigma_1 = (3.0 / 4.0) * (rad _b1_deg) * _lambda;
_CYSigma_2 = (3.0 / 2.0) * (rad _a0_deg) * _mu * _lambda;
_CYSigma_3 = (1.0 / 4.0) * (rad _a1_deg) * (rad _b1_deg) * _mu;
_CYSigma_4 = (rad _a0_deg) * (rad _a1_deg) * _mu^2;
_CYSigma_5 = (1.0 / 6.0) * (rad _a0_deg) * (rad _a1_deg);
_CYSigma_6 = ((3.0 / 4.0) * _mu * (rad _a0_deg) - (1.0 / 3.0) * (rad _b1_deg) - (1.0 / 2.0) * _mu^2 * (rad _b1_deg)) * (rad _theta75_deg);

_CYSigma   = (_a / 2.0) * (_CYSigma_1 - _CYSigma_2 + _CYSigma_3 - _CYSigma_4 + _CYSigma_5 - _CYSigma_6);

_Jside     = _b * _c * _R * _rho * _omegaR^2 * _CYSigma;

[_Hdrag, _Jside];