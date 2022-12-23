params ["_heli"];




_heli setVariable ["bmk_helisim_engState",              ["OFF", "OFF"]];
_heli setVariable ["bmk_helisim_engStart",              [false, false]];
_heli setVariable ["bmk_helisim_engOn",                 [false, false]];
_heli setVariable ["bmk_helisim_isSingEng",             [false, false]];

_heli setVariable ["bmk_helisim_engOutputRPM",          [0.0, 0.0]];
_heli setVariable ["bmk_helisim_engOutputTq",           [0.0, 0.0]];
_heli setVariable ["bmk_helisim_engThrottlePos",        ["OFF", "OFF"]];
_heli setVariable ["bmk_helisim_engThrottleSetPoint",   [0.0, 0.0]];