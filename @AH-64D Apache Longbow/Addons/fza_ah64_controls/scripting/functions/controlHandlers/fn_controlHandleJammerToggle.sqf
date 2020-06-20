params ["_heli"]

if (fza_ah64_rfjstate == 1) exitwith {
    fza_ah64_rfjstate = 0;
};
if (fza_ah64_irjstate == 1) exitwith {
    fza_ah64_irjstate = 0;
};

fza_ah64_rfjstate = fza_ah64_rfjstate + 1;
fza_ah64_irjstate = fza_ah64_irjstate + 1;