params ["_heli"];

private _R         = _heli getVariable "bmk_helisim_mainRotor_bladeRadius";
private _RPM       = _heli getVariable "bmk_helisim_mainRotorRPM";
private _gearRatio = _heli getVariable "bmk_helisim_mainRotor_gearRatio";

private _omega  = ((2.0 * pi) * _RPM) / 60.0;
private _omegaR = _omega * _R;

//21109 needs to pull from the current transmission RPM
_RPM = 21109 / _gearRatio;
_heli setVariable ["bmk_helisim_mainRotorRPM", _RPM];

[_omega, _omegaR]