_heli = _this select 0;
if (_heli getVariable "fza_ah64_irjon" == 0 && !("fza_ah64_irjamfail" in ((vehicle player) magazinesturret[-1]))) then {
    _heli setVariable ["fza_ah64_irjon", 1, true];
    while {
        (fza_ah64_irjammer < 61 && _heli getVariable "fza_ah64_irjon" == 1)
    }
    do {
        fza_ah64_irjammer = fza_ah64_irjammer + 1;
        sleep 1;
    };
    if (fza_ah64_irjammer > 60) then {
        _heli setVariable ["fza_ah64_irjon", 0, true];
    };
    while {
        (fza_ah64_irjammer > 0 && _heli getVariable "fza_ah64_irjon" == 0)
    }
    do {
        fza_ah64_irjammer = fza_ah64_irjammer - 1;
        sleep 1;
    };
} else {

    if (!(_heli getVariable "fza_ah64_irjon" == -1)) then {
        _heli setVariable ["fza_ah64_irjon", 0, true];
    };
};