_heli = _this select 0;
if (fza_ah64_pfzcache select 1 == "all" || fza_ah64_pfzcache select 1 == (name player)) then {
    if (fza_ah64_pfz_count == 1) then {
        fza_ah64_pfz1 = (fza_ah64_pfzcache select 2);
        fza_ah64_currentpfz = fza_ah64_pfz1;
    };
    if (fza_ah64_pfz_count == 2) then {
        fza_ah64_pfz2 = (fza_ah64_pfzcache select 2);
        fza_ah64_currentpfz = fza_ah64_pfz2;
    };
    if (fza_ah64_pfz_count == 3) then {
        fza_ah64_pfz3 = (fza_ah64_pfzcache select 2);
        fza_ah64_currentpfz = fza_ah64_pfz3;
    };
    if (fza_ah64_pfz_count == 4) then {
        fza_ah64_pfz4 = (fza_ah64_pfzcache select 2);
        fza_ah64_currentpfz = fza_ah64_pfz4;
    };
    if (fza_ah64_pfz_count == 5) then {
        fza_ah64_pfz5 = (fza_ah64_pfzcache select 2);
        fza_ah64_currentpfz = fza_ah64_pfz5;
    };
    if (fza_ah64_pfz_count == 6) then {
        fza_ah64_pfz6 = (fza_ah64_pfzcache select 2);
        fza_ah64_currentpfz = fza_ah64_pfz6;
    };
    if (fza_ah64_pfz_count == 7) then {
        fza_ah64_pfz7 = (fza_ah64_pfzcache select 2);
        fza_ah64_currentpfz = fza_ah64_pfz7;
    };
    if (fza_ah64_pfz_count == 8) then {
        fza_ah64_pfz8 = (fza_ah64_pfzcache select 2);
        fza_ah64_currentpfz = fza_ah64_pfz8;
    }; {
        if (!(_x in fza_ah64_targetlist)) then {
            fza_ah64_targetlist = fza_ah64_targetlist + (fza_ah64_pfzcache select 2);
        };
    }
    foreach(fza_ah64_pfzcache select 2);
    _heli vehiclechat format["%1 Targets downloaded from %2.", count(fza_ah64_pfzcache select 2), fza_ah64_pfzcache select 0];
};