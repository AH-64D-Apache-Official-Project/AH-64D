params["_heli"];
if (fza_ah64_rfjon == 0 && !(_heli getVariable "fza_ah64_rfjamfail")) then {
    fza_ah64_rfjon = 1;
    _jammerscript = [(vehicle player)] execvm "\fza_ah64_controls\scripting\jammer.sqf";
    while {
        (fza_ah64_rfjammer < 61 && fza_ah64_rfjon == 1)
    }
    do {
        fza_ah64_rfjammer = fza_ah64_rfjammer + 1;
        sleep 1;
    };
    if (fza_ah64_rfjammer > 60) then {
        fza_ah64_rfjon = 0;
    };
    while {
        (fza_ah64_rfjammer > 0 && fza_ah64_rfjon == 0)
    }
    do {
        fza_ah64_rfjammer = fza_ah64_rfjammer - 1;
        sleep 1;
    };
} else {
    fza_ah64_rfjon = 0;
};