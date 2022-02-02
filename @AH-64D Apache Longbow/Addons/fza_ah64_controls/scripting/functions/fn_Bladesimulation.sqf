/* ----------------------------------------------------------------------------
Function: fza_fnc_BladeSimulation

Description:
    to simulate the cyclinc and collective input into animations visible on 
    the tail rotor, main rotor and squash plates
Parameters:
    _heli = The apache
Returns:
    Nothing
Examples:
    [_heli] call fza_fnc_BladeSimulation;
Author:
	Rosd6(Dryden), BradMick
---------------------------------------------------------------------------- */
params["_heli"];
if !(fza_ah64_BladeSimulation) exitwith {};

if (player == currentPilot _heli) then {
    _velfactor = 0;
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
    _weight = 90;
    _weight = _weight * _smoothfactor;

    _vertvect = ((_velair select 2) atan2 sqrt(((_velair select 0) * (_velair select 0)) + ((_velair select 1) * (_velair select 1))));
    _vertvect = (_vertvect * _velfactor) + _weight;
    _helipb = _heli call fza_fnc_getPitchBank;
    _vertvect = (_vertvect - (_helipb select 0));
    _horveldir = abs((velocity _heli select 0) atan2(velocity _heli select 1));
    _theta = (360 + (_horveldir - (direction _heli))) Mod 360;
    _targhead = _theta;
    if (_theta >= 180) then {
        _targhead = _theta - 360;
    };
    _horvect = (_targhead * _velfactor);

    _vertvect1 = (sin(_helipb select 1)) * _horvect;
    _vertvect2 = (cos(_helipb select 1)) * _vertvect;

    _horvect1 = (cos(_helipb select 1)) * _horvect;
    _horvect2 = (sin(_helipb select 1)) * _vertvect;

    _1 = random 1;
    _2 = random 1;
    if (random 1 >= 0.5) then {
        _1 = _1 - 1;
    };
    if (random 1 >= 0.5) then {
        _2 = _2 - 1;
    };

    _heli animateSource["l_ads_p", (_vertvect1 + _vertvect2 + _1) * 0.002778];
    _heli animateSource["l_ads_y", (_horvect1 + _horvect2 + _2) * 0.002778];
    _heli animateSource["r_ads_p", (_vertvect1 + _vertvect2 + _2) * 0.002778];
    _heli animateSource["r_ads_y", (_horvect1 + _horvect2 + _1) * 0.002778];

    //////////////////////////////////////////////Blade Simulation//////////////////////////////////////////////
    //mouse input in freelook to cancel
    private _foward = 0;
    private _backward = 0;
    private _right = 0;
    private _left = 0;
    if (freeLook == true) then {
        if (inputAction "HeliCyclicForward" == inputAction "aimup") then {_foward = inputAction "aimup";};
        if (inputAction "HeliCyclicForward" == inputAction "aimdown") then {_foward = inputAction "aimdown";};
        if (inputAction "HeliCyclicBack" == inputAction "aimdown") then {_backward = inputAction "aimdown";};
        if (inputAction "HeliCyclicBack" == inputAction "aimup") then {_backward = inputAction "aimup";};
        if (inputAction "HeliCyclicRight" == inputAction "Aimleft") then {_right = inputAction "Aimleft";};
        if (inputAction "HeliCyclicRight" == inputAction "AimRight") then {_right = inputAction "AimRight";};
        if (inputAction "HeliCyclicLeft" == inputAction "AimRight") then {_left = inputAction "AimRight";};
        if (inputAction "HeliCyclicLeft" == inputAction "Aimleft") then {_left = inputAction "Aimleft";};
    };
    
    // Cyclic Input
    private _bladePitchFwd   = (inputAction "HeliCyclicForward") - _foward;
    private _bladePitchAft   = (inputAction "HeliCyclicBack") - _backward;
    private _bladePitch      = _bladePitchAft - _bladePitchFwd; // -1 to 1
    if (_bladePitch > 1)  then {_bladePitch = 1;};
    if (_bladePitch < -1) then {_bladePitch = -1;};

    private _bladePitchLeft  = (inputAction "HeliCyclicLeft")  - _left;
    private _bladePitchRight = (inputAction "HeliCyclicRight") - _right;
    private _bladeRoll       = _bladePitchRight - _bladePitchLeft; // -1 to 1
    if (_bladeRoll > 1)  then {_bladeRoll = 1;};
    if (_bladeRoll < -1) then {_bladeRoll = -1;};

    //Rudder input
    Private _RudderYaw = (-1 * ((inputAction "HeliRudderLeft") - (inputAction "HeliRudderRight"))); // -1 to 1

    //Blade posiiton
    private _mainRtrPctRot     = (_heli animationphase "mainRotor") * 360;  // 0 to 1, going counterclockwise, 0  is the nose.
    private _blade1AzAngle_deg = _mainRtrPctRot + 0;
    private _blade2AzAngle_deg = _mainRtrPctRot + 90;
    private _blade3AzAngle_deg = _mainRtrPctRot + 180;
    private _blade4AzAngle_deg = _mainRtrPctRot + 270;
    private _SPA1AzAngle_deg = _mainRtrPctRot + 315;
    private _SPA2AzAngle_deg = _mainRtrPctRot + 135;
    if (_blade1AzAngle_deg > 360) then {_blade1AzAngle_deg = _blade1AzAngle_deg - 360;};
    if (_blade2AzAngle_deg > 360) then {_blade2AzAngle_deg = _blade2AzAngle_deg - 360;};
    if (_blade3AzAngle_deg > 360) then {_blade3AzAngle_deg = _blade3AzAngle_deg - 360;};
    if (_blade4AzAngle_deg > 360) then {_blade4AzAngle_deg = _blade4AzAngle_deg - 360;};
    if (_blade4AzAngle_deg > 360) then {_blade4AzAngle_deg = _blade4AzAngle_deg - 360;};
    if (_SPA1AzAngle_deg > 360) then {_SPA1AzAngle_deg = _SPA1AzAngle_deg - 360;};
    if (_SPA2AzAngle_deg > 360) then {_SPA2AzAngle_deg = _SPA2AzAngle_deg - 360;};

    //blade output
    private _blade1Output = (_bladePitch * (cos _blade1AzAngle_deg)) + (_bladeRoll * (sin _blade1AzAngle_deg));
    private _blade2Output = (_bladePitch * (cos _blade2AzAngle_deg)) + (_bladeRoll * (sin _blade2AzAngle_deg));
    private _blade3Output = (_bladePitch * (cos _blade3AzAngle_deg)) + (_bladeRoll * (sin _blade3AzAngle_deg));
    private _blade4Output = (_bladePitch * (cos _blade4AzAngle_deg)) + (_bladeRoll * (sin _blade4AzAngle_deg));
    private _SParm1Pitch = (_bladePitch * (cos _SPA1AzAngle_deg)) + (_bladeRoll * (sin _SPA1AzAngle_deg));
    private _SParm2Pitch = (_bladePitch * (cos _SPA2AzAngle_deg)) + (_bladeRoll * (sin _SPA2AzAngle_deg));

    //Tables
    private _bladeFlapTable = [[0.0,   0.00],
                              [0.57,  0.50],
                              [1.01,  1.00]];
                              
    private _bladeConeTable = [[0.00, 0.00],
                              [0.50, 0.35],
                              [1.00, 0.70]];
    //blade Coneing
    private _rpm = (_heli getVariable "fza_sfmplus_engPctNP" select 0) max (_heli getVariable "fza_sfmplus_engPctNP" select 1);
    private _bladeFlapTableInterp = [_bladeFlapTable, _rpm] call fza_fnc_linearInterp;
    private _bladeFlapLimit       = _bladeFlapTableInterp select 1;

    //blade Flapping  
    private _bladeFlapTableInterp = [_bladeConeTable, fza_sfmplus_collectiveOutput] call fza_fnc_linearInterp;
    private _bladeConeOut         = _bladeFlapTableInterp select 1;

    //Main Rotor Blade Flap                        
    _heli animateSource["blade1_flap", ((_blade1Output * 1.20) + _bladeConeOut) * _bladeFlapLimit]; //Functional, Coneing needs tuning
    _heli animateSource["blade2_flap", ((_blade2Output * 1.20) + _bladeConeOut) * _bladeFlapLimit]; //Functional, Coneing needs tuning
    _heli animateSource["blade3_flap", ((_blade3Output * 1.20) + _bladeConeOut) * _bladeFlapLimit]; //Functional, Coneing needs tuning
    _heli animateSource["blade4_flap", ((_blade4Output * 1.20) + _bladeConeOut) * _bladeFlapLimit]; //Functional, Coneing needs tuning
    //Main Rotor Blade Pitch
    _heli animateSource["blade1_pitch", -1 * (0.5 * (_blade1Output)) + (-0.5 * (fza_sfmplus_collectiveOutput))]; //Functional
    _heli animateSource["blade2_pitch", -1 * (0.5 * (_blade2Output)) + (-0.5 * (fza_sfmplus_collectiveOutput))]; //Functional
    _heli animateSource["blade3_pitch", -1 * (0.5 * (_blade3Output)) + (-0.5 * (fza_sfmplus_collectiveOutput))]; //Functional
    _heli animateSource["blade4_pitch", -1 * (0.5 * (_blade4Output)) + (-0.5 * (fza_sfmplus_collectiveOutput))]; //Functional
    //Main Rotor Squashplate
    _heli animateSource["swashplate_up_tns", (fza_sfmplus_collectiveOutput)];   //Functional
    _heli animateSource["swashplate_dn_tns", (fza_sfmplus_collectiveOutput)];   //Functional
    _heli animateSource["mr_act_tns", (fza_sfmplus_collectiveOutput)];          //Functional
    _heli animateSource["swashplate_up_pitch", _bladePitch];                    //Functional
    _heli animateSource["swashplate_up_bank", -1 * _bladeRoll];                 //Functional
    _heli animateSource["swashplate_dn_pitch", _bladePitch];                    //Functional
    _heli animateSource["swashplate_dn_bank", -1 * _bladeRoll];                 //Functional
    _heli animateSource["swup_arm2", (-1 * (_SParm1Pitch))];                    //Functional
    _heli animateSource["swup_arm4", _SParm1Pitch];                             //Functional
    //Tail Rotor & squashplate
    _heli animateSource["trsw", _RudderYaw];                                       // animation calibrated, needs review
    _heli animateSource["tr_blade1_pitch", (-1 * (_RudderYaw))];                   // animation calibrated, needs review
    _heli animateSource["tr_blade2_pitch", _RudderYaw];                            // animation calibrated, needs review
    _heli animateSource["tr_blade3_pitch", _RudderYaw];                            // animation calibrated, needs review
    _heli animateSource["tr_blade4_pitch", (-1 * (_RudderYaw))];                   // animation calibrated, needs review
};