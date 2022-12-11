params ["_heli"];

_heli setVariable ["bmk_helisim_engState",              ["OFF", "OFF"]];
_heli setVariable ["bmk_helisim_engStart",              [false, false]];
_heli setVariable ["bmk_helisim_engOn",                 [false, false]];

_heli setVariable ["bmk_helisim_engineOutputRPM",       [0.0, 0.0]];
_heli setVariable ["bmk_helisim_engineOutputTq",        [0.0, 0.0]];
_heli setVariable ["bmk_helisim_engThrottlePos",        ["OFF", "OFF"]];
_heli setVariable ["bmk_helisim_engThrottleSetPoint",   [0.0, 0.0]];