params ["_heli", "_deltaTime", "_rtrNum", "_rho", "_u_w", "_v_w", "_w_w", "_omegaR", "_theta0_deg", "_rotorParams", "_gndEffScalar"];
#include "\bmk_helisim\headers\core.hpp"

_rotorParams 
    params ["_a", "_type", "_b", "_h", "_R", "_c", "_theta1_deg", "_m", "_eR", "_e", "_gearRatio", "_thrustScalar", "_Ib", "_s", "_polarMOI", "_inputMaps"];

private _mu      = _heli getVariable "bmk_helisim_rotor_mu"     select _rtrNum;
private _nu      = _heli getVariable "bmk_helisim_rotor_nu"     select _rtrNum;
private _lambda  = _heli getVariable "bmk_helisim_rotor_lambda" select _rtrNum;
private _thrust  = _heli getVariable "bmk_helisim_rotor_thrust" select _rtrNum;
private _CTSigma = 0.0; 
private _CT      = _heli getVariable "bmk_helisim_rotor_CT"     select _rtrNum;
private _ct_0 = 0.0; private _ct_1 = 0.0; private _ct_2 = 0.0; private _ct_3 = 0.0;

//SH79, eqn 24
_mu = if (_omegaR == 0) then { 0.0; } else { _u_w / _omegaR; };
if (_mu > 0.7) then { _mu = 0.7; };

_ct_2 = (1.0 / 3.0 * TIP_LOSS^3 + 1.0 / 2.0 * TIP_LOSS * _mu^2 - 4.0 / (9.0 * pi) * _mu^3) * (rad _theta0_deg);
_ct_3 = (1.0 / 4.0 * TIP_LOSS^4 + 1.0 / 4.0 * TIP_LOSS^2 * _mu^2) * (rad _theta1_deg);

_ct_1 = (1.0 / 2.0 * TIP_LOSS^2 + 1.0 / 4.0 * _mu^2) * _lambda;

_ct_0 = (_a / 2.0) * (_ct_1 + _ct_2 + _ct_3) * _s;
_ct_0 = if (_mu == 0) then { 0.0; } else { _ct_0 / (2.0 * sqrt (_mu^2 + _lambda^2)); };

_nu = _gndEffScalar * ((_nu - _ct_0) * exp (-_deltaTime / TAU_LAMBDA) + _ct_0);

//SH79, eqn 25
_lambda = if (_omegaR == 0) then { 0.0; } else { (_w_w / _omegaR) - _nu; };

_ct_1 = (1.0 / 2.0 * TIP_LOSS^2 + 1.0 / 4.0 * _mu^2) * _lambda;

//SH79, eqn 27
_CTSigma = (_a / 2.0) * (_ct_1 + _ct_2 + _ct_3);
_CT      = _CTSigma * _s;

_thrust = _thrustScalar * (_b * _c * _R * _rho * _omegaR^2 * _CTSigma);

[_heli, "bmk_helisim_rotor_mu",     _rtrNum, _mu]     call fza_sfmplus_fnc_setArrayVariable;
[_heli, "bmk_helisim_rotor_nu",     _rtrNum, _nu]     call fza_sfmplus_fnc_setArrayVariable;
[_heli, "bmk_helisim_rotor_lambda", _rtrNum, _lambda] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "bmk_helisim_rotor_thrust", _rtrNum, _thrust] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "bmk_helisim_rotor_CT",     _rtrNum, _CT] call fza_sfmplus_fnc_setArrayVariable;

//systemChat format ["nu = % 1 --- Vi = %2  --  CT = %3  -- lambda %4", _nu,  _nu * _omegaR, _CT, _lambda];

[_mu, _thrust, _lambda, _CT];