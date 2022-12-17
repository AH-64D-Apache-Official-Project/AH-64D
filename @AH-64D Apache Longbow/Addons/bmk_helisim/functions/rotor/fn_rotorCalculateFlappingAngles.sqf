params ["_heli", "_theta0_deg", "_rotorParams", "_mu", "_lambda", "_p_w", "_q_w", "_omega", "_gamma", "_a0_deg"];
#include "\bmk_helisim\headers\core.hpp"

_rotorParams 
    params ["_a", "_type", "_b", "_h", "_R", "_c", "_theta1_deg", "_m", "_eR", "_e", "_gearRatio", "_Ib", "_s", "_polarMOI", "_input"];

//SH79, eqn 33
private _theta75_deg = _theta0_deg + (0.75 * _theta1_deg);

//SH79, eqn 32
private _a1_1 = if (_mu == 0) then { 0.0; } else { 1.0 / (1.0 - (_mu * _mu) / (2.0 * (B * B))); };
private _a1_2 = (2.0 * _lambda + (8.0 / 3.0) * (rad _theta75_deg)) * _mu;
private _a1_3 = if (_omega == 0) then { 0.0; } else { _p_w / _omega; };
private _a1_4 = if (_omega == 0) then { 0.0; } else { 16.0 * _q_w / ((B * B * B * B) * _gamma * _omega); };

private _a1_deg = _a1_1 * (_a1_2 + _a1_3 + _a1_4);
if (not finite _a1_deg) then { _a1_deg = 0.0; };
_a1_deg = deg _a1_deg;

//SH79, eqn 32
private _b1_1 = if (_mu == 0) then { 0.0; } else { 1 / (1.0 - (_mu * _mu) / (2.0 * (B * B))); };
private _b1_2 = (4.0 / 3.0) * _mu * (rad _a0_deg);
private _b1_3 = if (_omega == 0) then { 0.0; } else { _q_w / _omega; };
private _b1_4 = if (_omega == 0) then { 0.0; } else { 16.0 * _q_w / ((B * B * B * B) * _gamma * _omega); };

private _b1_deg = _b1_1 * (_b1_2 - _b1_3 - _b1_4);
if (not finite _b1_deg) then { _b1_deg = 0.0; };
_b1_deg = deg _b1_deg;

[_a1_deg, _b1_deg, _theta75_deg];