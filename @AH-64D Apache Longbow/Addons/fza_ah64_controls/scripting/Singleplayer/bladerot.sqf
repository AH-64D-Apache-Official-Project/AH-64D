#include "\fza_ah64_controls\headers\selections.h"
if (!(isNil "fza_ah64_noblades")) exitwith {};
_estate = 0;
_heli = _this select 0;
_alt = 0;
_adsp = 0;
_adsp2 = 0;
_smoothrand = 0;
_smoothrand2 = 0;
_smoothrand3 = 0;
_smoothrand4 = 0;
_smoothing1 = 0;
_smoothing2 = 0;
_smoothfactor = 0;
_velfactor = 0;
_weight = 90;

while {
    alive _heli
}
do {
    if (local _heli && player in _heli) then {

        if (_adsp == 0) then {
            _smoothrand = random 1;
            _adsp = 1;
            _smoothrand2 = _smoothrand;
        };

        if (_smoothrand >= 0 && _adsp == 1) then {
            _smoothrand2 = _smoothrand2 + random 5;
        };
        if (_smoothrand2 > 30) then {
            _adsp = 2;
        };
        if (_adsp == 2) then {
            _smoothrand2 = _smoothrand2 - random 5;
        };
        if (_smoothrand2 < 0.1) then {
            _adsp = 0;
            _adsp2 = 0;
        };
        if (_adsp2 == 0) then {
            _smoothrand3 = random 1;
            _smoothrand4 = random 1;
            _adsp2 = 1;
        };
        if (_smoothrand3 >= 0.5) then {
            _smoothrand3 = _smoothrand2;
        };
        if (_smoothrand3 < 0.5) then {
            _smoothrand3 = _smoothrand2 * -1;
        };
        if (_smoothrand4 >= 0.5) then {
            _smoothrand4 = _smoothrand2;
        };
        if (_smoothrand4 < 0.5) then {
            _smoothrand4 = _smoothrand2 * -1;
        };

        _velair = [(velocity _heli select 0) + (0.836 * (abs(wind select 0) ^ 1.5)), (velocity _heli select 1) + (0.836 * (abs(wind select 2) ^ 1.5)), (velocity _heli select 2) + (0.836 * (abs(wind select 1) ^ 1.5))];
        _velmag = sqrt(((velocity _heli select 0) + (0.836 * (abs(wind select 0) ^ 1.5))) ^ 2 + ((velocity _heli select 1) + (0.836 * (abs(wind select 2) ^ 1.5))) ^ 2 + ((velocity _heli select 2) + (0.836 * (abs(wind select 1) ^ 1.5))) ^ 2);
        _velfactor = _velmag * 0.05;
        if (_velfactor > 1) then {
            _velfactor = 1;
        };

        _smoothfactor = (20 - _velmag) * 0.05;
        if (_smoothfactor < 0) then {
            _smoothfactor = 0;
        };
        _smoothing1 = _smoothrand3 * _smoothfactor;
        _smoothing2 = _smoothrand4 * _smoothfactor;
        _weight = 90;
        _weight = _weight * _smoothfactor;

        _vertvect = ((_velair select 2) atan2 sqrt(((_velair select 0) * (_velair select 0)) + ((_velair select 1) * (_velair select 1))));
        _vertvect = (_vertvect * _velfactor) + _weight;
        _helipb = _heli call fza_fnc_getPitchBank;
        _vertvect = (_vertvect - (_helipb select 0));
        _horveldir = (velocity _heli select 0) atan2(velocity _heli select 1);
        if (_horveldir < 0) then {
            _horveldir = _horveldir + 360;
        };
        _theta = (360 + (_horveldir - (direction _heli))) Mod 360;
        _targhead = _theta;
        if (_theta >= 180) then {
            _targhead = _theta - 360;
        } else {
            _targhead = _theta;
        };
        _horvect = (_targhead * _velfactor);

        _vertvect1 = (sin(_helipb select 1)) * _horvect;
        _vertvect2 = (cos(_helipb select 1)) * _vertvect;

        _horvect1 = (cos(_helipb select 1)) * _horvect;
        _horvect2 = (sin(_helipb select 1)) * _vertvect;

        //player globalchat format ["VV %1 HV %2",_vertvect,_horvect];
        _heli animateSource["l_ads_p", (_vertvect1 + _vertvect2 + _smoothing1) * 0.002778];
        _heli animateSource["l_ads_y", (_horvect1 + _horvect2 + _smoothing2) * 0.002778];
        _heli animateSource["r_ads_p", (_vertvect1 + _vertvect2 + _smoothing2) * 0.002778];
        _heli animateSource["r_ads_y", (_horvect1 + _horvect2 + _smoothing1) * 0.002778];
    };
    if (player == driver _heli) then {
        //Angling of the rotors
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
        _heli animateSource["trsw", _rudder];
        _heli animateSource["tr_blade1_pitch", (-1 * (_rudder))];
        _heli animateSource["tr_blade2_pitch", _rudder];
        _heli animateSource["tr_blade3_pitch", _rudder];
        _heli animateSource["tr_blade4_pitch", (-1 * (_rudder))];
        //main rotor
        _heli animateSource["swashplate_up_tns", (-2.5 * (_collective))];
        _heli animateSource["swashplate_dn_tns", (-2.5 * (_collective))];
        _heli animateSource["mr_act_tns", (-2.5 * (_collective))];
        _heli animateSource["swashplate_up_pitch", -3 * _forback];
        _heli animateSource["swashplate_up_bank", -3 * _leftright];
        _heli animateSource["swashplate_dn_pitch", -3 * _forback];
        _heli animateSource["swashplate_dn_bank", -3 * _leftright];
        _heli animateSource["swup_arm1", _s1p];
        _heli animateSource["swup_arm1_t", (-1 * (_s1p))];
        _heli animateSource["swup_arm2", _s1p];
        _heli animateSource["swup_arm3", _s2p];
        _heli animateSource["swup_arm3_t", (-1 * (_s2p))];
        _heli animateSource["swup_arm4", _s2p];
        _heli animateSource["blade1_pitch", _b1p];
        _heli animateSource["blade2_pitch", _b2p];
        _heli animateSource["blade3_pitch", _b3p];
        _heli animateSource["blade4_pitch", _b4p];
        _heli animateSource["blade1_flap", (-0.8 * (_estate * (_b1p)))];
        _heli animateSource["blade2_flap", (-0.8 * (_estate * (_b2p)))];
        _heli animateSource["blade3_flap", (-0.8 * (_estate * (_b3p)))];
        _heli animateSource["blade4_flap", (-0.8 * (_estate * (_b4p)))];
    };
    sleep 0.03;
};