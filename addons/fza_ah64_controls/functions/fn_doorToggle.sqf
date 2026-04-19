params ["_heli"];
if (driver _heli == player) then {
    if (_heli animationPhase "pdoor" < 0.5) then {
        _heli animateSource["pdoor", 1];
        playSound "fza_ah64_rh_dooropen1";
    };
    if (_heli animationPhase "pdoor" > 0.5) then {
        _heli animateSource["pdoor", 0];
        waitUntil {
            (_heli animationPhase "pdoor" < 0.1);
        };
        playSound "fza_ah64_rh_doorclose1";
    }; 
};
if (gunner _heli == player) then {
    if (_heli animationPhase "gdoor" < 0.5) then {
        _heli animateSource["gdoor", 1];
        playSound "fza_ah64_rh_dooropen1";
    };
    if (_heli animationPhase "gdoor" > 0.5) then {
        _heli animateSource["gdoor", 0];
        waitUntil {
            (_heli animationPhase "gdoor" < 0.1);
        };
        playSound "fza_ah64_rh_doorclose1";
    }; 
};
