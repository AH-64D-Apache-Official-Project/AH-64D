params ["_heli"];
if (driver _heli == player) then {
    if (_heli animationphase "pdoor" < 0.5) then {
        _heli animateSource["pdoor", 1];
        playsound "fza_ah64_rh_dooropen1";
    };
    if (_heli animationphase "pdoor" > 0.5) then {
        _heli animateSource["pdoor", 0];
        waituntil {
            (_heli animationphase "pdoor" < 0.1);
        };
        playsound "fza_ah64_rh_doorclose1";
    }; 
};
if (gunner _heli == player) then {
    if (_heli animationphase "gdoor" < 0.5) then {
        _heli animateSource["gdoor", 1];
        playsound "fza_ah64_rh_dooropen1";
    };
    if (_heli animationphase "gdoor" > 0.5) then {
        _heli animateSource["gdoor", 0];
        waituntil {
            (_heli animationphase "gdoor" < 0.1);
        };
        playsound "fza_ah64_rh_doorclose1";
    }; 
};