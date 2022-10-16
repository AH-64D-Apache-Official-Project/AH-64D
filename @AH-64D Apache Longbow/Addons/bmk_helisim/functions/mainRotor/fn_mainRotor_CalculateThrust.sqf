params ["_heli", "_u_w", "_omegaR", "_B"];

private _mu      = 0.0;
private _CTSigma = 0.0;
private ["_ct_0", "_ct_1", "_ct_2", "_ct_3"];

_mu = _u_w / _omegaR;
if (_mu > 0.7) then { _mu = 0.7; };




[_mu];