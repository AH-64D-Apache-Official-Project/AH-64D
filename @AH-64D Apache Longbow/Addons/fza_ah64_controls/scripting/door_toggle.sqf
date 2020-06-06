_heli = _this select 0;
_door = _this select 1;

if (_heli animationphase _door < 0.1) then {
    _heli animate[_door, 1];
    playsound "fza_ah64_rh_dooropen1";
};
if (_heli animationphase _door > 0.1) then {
    _heli animate[_door, 0];
    waituntil {
        (_heli animationphase _door < 0.1)
    };
    playsound "fza_ah64_rh_doorclose1";
};