params["_heli", ["_increase", true]];

if _increase then {
    if (_heli getVariable "fza_ah64_curwpnum" < (count (_heli getVariable "fza_ah64_waypointdata") - 1)) then {
        _heli setVariable ["fza_ah64_curwpnum", (_heli getVariable "fza_ah64_curwpnum") + 1, true];
    };
} else {
    if((_heli getVariable "fza_ah64_curwpnum") > 0) then {
        _heli setVariable ["fza_ah64_curwpnum", (_heli getVariable "fza_ah64_curwpnum") - 1, true];
    };
};