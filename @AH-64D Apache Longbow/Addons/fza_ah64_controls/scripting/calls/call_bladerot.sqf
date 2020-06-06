private["_heli", "_estate"];
_heli = _this select 0;
_estate = 0.9 * (_heli animationphase "blade1_rise1");

if (!(player in _heli || local _heli)) exitwith {};

//inputs
_forback = ((inputAction "HeliForward") + (-1 * (inputAction "HeliBack")));
_leftright = (inputAction "HeliCyclicRight") + (inputAction "HeliRight") + (-1 * (inputAction "HeliLeft")) + (-1 * (inputAction "HeliCyclicLeft"));
_collective = (-0.125 * (2 - (inputAction "HeliCollectiveLowerCont" + inputAction "heliThrottleNeg" + inputAction "heliDown"))) + (-0.125 * (inputAction "HeliCollectiveRaiseCont" + inputAction "heliUp" + inputAction "heliThrottlePos"));
if (_collective > 0.1) then {
    _collective = 0.1;
};
if (_collective < -0.6) then {
    _collective = -0.6;
};
_rudder = (-0.5 * (inputAction "HeliRudderLeft")) + (0.5 * (inputAction "HeliRudderRight"));
_cyclicdir = _leftright atan2 _forback;
if (_cyclicdir < 0) then {
    _cyclicdir = _cyclicdir + 360;
};
_cyclicdir = (1 / 360) * _cyclicdir;
_magnitude = (inputAction "HeliForward") + (inputAction "HeliBack") + (inputAction "HeliLeft") + (inputAction "HeliCyclicLeft") + (inputAction "HeliRight") + (inputAction "HeliCyclicRight");
_magnitude = _magnitude * 5;
if (_magnitude > 1) then {
    _magnitude = 1;
};
_addval = 0.09 * (_heli animationphase "blade1_rise1");
//bladepitch
_b1phase = (_heli animationphase "mainRotor") + (_addval + _cyclicdir);
if (_b1phase > 1) then {
    _b1phase = _b1phase - 1;
};
_b1phase = (cos(360 * _b1phase)) * _magnitude;
_b2phase = (_heli animationphase "mainRotor") + (_addval + 0.25 + _cyclicdir);
if (_b2phase > 1) then {
    _b2phase = _b2phase - 1;
};
_b2phase = (cos(360 * _b2phase)) * _magnitude;
_b3phase = (_heli animationphase "mainRotor") + (_addval + 0.5 + _cyclicdir);
if (_b3phase > 1) then {
    _b3phase = _b3phase - 1;
};
_b3phase = (cos(360 * _b3phase)) * _magnitude;
_b4phase = (_heli animationphase "mainRotor") + (_addval + 0.75 + _cyclicdir);
if (_b4phase > 1) then {
    _b4phase = _b4phase - 1;
};
_b4phase = (cos(360 * _b4phase)) * _magnitude;
//scissorarm1
_s1phase = (_heli animationphase "mainRotor") + (_addval + 0.875 + _cyclicdir);
if (_s1phase > 1) then {
    _s1phase = _s1phase - 1;
};
_s1phase = (cos(360 * _s1phase)) * _magnitude;
//scissorarm2
_s2phase = (_heli animationphase "mainRotor") + (_addval + 0.375 + _cyclicdir);
if (_s2phase > 1) then {
    _s2phase = _s2phase - 1;
};
_s2phase = (cos(360 * _s2phase)) * _magnitude;
_b1p = (0.5 * (_b1phase)) + _collective;
_b2p = (0.5 * (_b2phase)) + _collective;
_b3p = (0.5 * (_b3phase)) + _collective;
_b4p = (0.5 * (_b4phase)) + _collective;
_s1p = 1.5 * ((_s1phase) + _collective);
_s2p = 1.5 * ((_s2phase) + _collective);
//player globalchat format ["%1",_b1phase];
//tail rotor
_heli animate["trsw", _rudder];
_heli animate["tr_blade1_pitch", (-1 * (_rudder))];
_heli animate["tr_blade2_pitch", _rudder];
_heli animate["tr_blade3_pitch", _rudder];
_heli animate["tr_blade4_pitch", (-1 * (_rudder))];
//main rotor
_heli animate["swashplate_up_tns", (-2.5 * (_collective))];
_heli animate["swashplate_dn_tns", (-2.5 * (_collective))];
_heli animate["mr_act_tns", (-2.5 * (_collective))];
_heli animate["swashplate_up_pitch", -3 * _forback];
_heli animate["swashplate_up_bank", -3 * _leftright];
_heli animate["swashplate_dn_pitch", -3 * _forback];
_heli animate["swashplate_dn_bank", -3 * _leftright];
_heli animate["swup_arm1", _s1p];
_heli animate["swup_arm1_t", (-1 * (_s1p))];
_heli animate["swup_arm2", _s1p];
_heli animate["swup_arm3", _s2p];
_heli animate["swup_arm3_t", (-1 * (_s2p))];
_heli animate["swup_arm4", _s2p];
_heli animate["blade1_pitch", _b1p];
_heli animate["blade2_pitch", _b2p];
_heli animate["blade3_pitch", _b3p];
_heli animate["blade4_pitch", _b4p];
_heli animate["blade1_flap", (-0.8 * (_estate * (_b1p)))];
_heli animate["blade2_flap", (-0.8 * (_estate * (_b2p)))];
_heli animate["blade3_flap", (-0.8 * (_estate * (_b3p)))];
_heli animate["blade4_flap", (-0.8 * (_estate * (_b4p)))];