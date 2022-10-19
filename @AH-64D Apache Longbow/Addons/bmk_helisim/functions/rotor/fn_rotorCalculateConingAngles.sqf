params ["_heli", "_mu", "_lambda", "_theta0_deg", "_rotorParams", "_gamma"];

_rotorParams params ["_a", "_b", "_R", "_c", "_theta1_deg", "_m", "_eR", "_e", "_gearRatio", "_Ib", "_s"];

private _a0_deg = 0.0;
private ["_a0_1", "_a0_2", "_a0_3"];

_a0_1 = (1.0 / 6.0 + 0.04 * (_mu * _mu * _mu))  * _lambda;
_a0_2 = (1.0 / 8.0 + 1.0 / 8.0 * (_mu * _mu))   * (rad _theta0_deg);
_a0_3 = (1.0 / 10.0 + 1.0 / 12.0 * (_mu * _mu)) * (rad _theta1_deg);

_a0_deg = _gamma * (_a0_1 + _a0_2 + _a0_3);
_a0_deg = deg _a0_deg;

[_a0_deg];