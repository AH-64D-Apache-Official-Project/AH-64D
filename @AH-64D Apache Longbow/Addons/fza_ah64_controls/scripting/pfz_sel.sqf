_heli = _this select 0;

fza_ah64_pfz_count = fza_ah64_pfz_count + 1;

if (fza_ah64_pfz_count == 1) exitwith {
    fza_ah64_currentpfz = fza_ah64_pfz1;
};
if (fza_ah64_pfz_count == 2) exitwith {
    fza_ah64_currentpfz = fza_ah64_pfz2;
};
if (fza_ah64_pfz_count == 3) exitwith {
    fza_ah64_currentpfz = fza_ah64_pfz3;
};
if (fza_ah64_pfz_count == 4) exitwith {
    fza_ah64_currentpfz = fza_ah64_pfz4;
};
if (fza_ah64_pfz_count == 5) exitwith {
    fza_ah64_currentpfz = fza_ah64_pfz5;
};
if (fza_ah64_pfz_count == 6) exitwith {
    fza_ah64_currentpfz = fza_ah64_pfz6;
};
if (fza_ah64_pfz_count == 7) exitwith {
    fza_ah64_currentpfz = fza_ah64_pfz7;
};
if (fza_ah64_pfz_count == 8) exitwith {
    fza_ah64_currentpfz = fza_ah64_pfz8;
};
if (fza_ah64_pfz_count == 9) exitwith {
    fza_ah64_pfz_count = 0;
    fza_ah64_currentpfz = [];
};