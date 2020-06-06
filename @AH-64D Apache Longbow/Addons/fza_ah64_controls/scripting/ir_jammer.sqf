if (fza_ah64_irjon == 0 && !("fza_ah64_irjamfail" in ((vehicle player) magazinesturret[-1]))) then {
    fza_ah64_irjon = 1;
    while {
        (fza_ah64_irjammer < 61 && fza_ah64_irjon == 1)
    }
    do {
        fza_ah64_irjammer = fza_ah64_irjammer + 1;
        sleep 1;
    };
    if (fza_ah64_irjammer > 60) then {
        fza_ah64_irjon = 0;
    };
    while {
        (fza_ah64_irjammer > 0 && fza_ah64_irjon == 0)
    }
    do {
        fza_ah64_irjammer = fza_ah64_irjammer - 1;
        sleep 1;
    };
} else {

    if (!(fza_ah64_irjon == -1)) then {
        fza_ah64_irjon = 0;
    };
};