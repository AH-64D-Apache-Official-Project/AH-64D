_heli = _this select 0;
if (_heli getVariable "fza_ah64_rfjon" == 0 && !("fza_ah64_rfjamfail" in ((vehicle player) magazinesturret[-1]))) then {
    _heli setVariable ["fza_ah64_rfjon", 1, true];
    while {
        (fza_ah64_rfjammer < 61 && _heli getVariable "fza_ah64_rfjon" == 1)
    }
    do {
        fza_ah64_rfjammer = fza_ah64_rfjammer + 1;
        sleep 1;
    };
    if (fza_ah64_rfjammer > 60) then {
        _heli setVariable ["fza_ah64_rfjon", 0, true];
    };
    while {
        (fza_ah64_rfjammer > 0 && _heli getVariable "fza_ah64_rfjon" == 0)
    }
    do {
        fza_ah64_rfjammer = fza_ah64_rfjammer - 1;
        sleep 1;
    };
} else {
    _heli setVariable ["fza_ah64_rfjon", 0, true];
};