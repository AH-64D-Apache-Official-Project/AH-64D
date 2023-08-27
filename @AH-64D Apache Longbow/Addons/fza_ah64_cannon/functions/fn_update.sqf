params ["_heli"];
private _burstLimit = _heli getVariable "fza_ah64_burst_limit";
if (_burstLimit != -1 && fza_ah64_burst >= _burstLimit && currentweapon _heli == "fza_m230") then {
    _heli selectweapon "fza_burstlimiter";
};

if (fza_ah64_gunheat > 0) then {
    fza_ah64_gunheat = fza_ah64_gunheat - 0.05;
};

if (fza_ah64_gunheat < 0) then {
    fza_ah64_gunheat = 0;
    fza_ah64_burst = 0;
};

if (time - fza_ah64_firekeypressed > 1 && currentweapon _heli == "fza_burstlimiter") then {
    fza_ah64_burst = 0;
    _heli selectWeapon "fza_m230";
};

