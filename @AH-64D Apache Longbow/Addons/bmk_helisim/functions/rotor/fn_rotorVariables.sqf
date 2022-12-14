params ["_heli"];

_heli setVariable ["bmk_helisim_mainRotor_RPM",     0.0];
_heli setVariable ["bmk_helisim_tailRotor_RPM",     0.0];

_heli setVariable ["bmk_helisim_pitchPrev",         [0.0, 0.0]];
_heli setVariable ["bmk_helisim_rollPrev",          [0.0, 0.0]];
_heli setVariable ["bmk_helisim_yawPrev",           [0.0, 0.0]];

_heli setVariable ["bmk_helisim_mainRotor_nu",      0.0];
_heli setVariable ["bmk_helisim_tailRotor_nu",      0.0];

_heli setVariable ["bmk_helisim_mainRotor_lambda",  0.0];
_heli setVariable ["bmk_helisim_tailRotor_lambda",  0.0];