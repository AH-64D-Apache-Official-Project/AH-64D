_heli = _this select 0;

fza_ah64_guncontrol = fza_ah64_guncontrol + 1;
if (fza_ah64_guncontrol > 3) then {
    fza_ah64_guncontrol = 0;
};

/*
if (fza_ah64_guncontrol == 1) then {_heli vehiclechat "HMD gun mode selected.";};
if (fza_ah64_guncontrol == 2) then {_heli vehiclechat "AUTO gun mode selected.";};
if (fza_ah64_guncontrol == 3) then {_heli vehiclechat "FXD gun mode selected.";};
if (fza_ah64_guncontrol == 0) then {_heli vehiclechat "TADS gun mode selected.";};
*/