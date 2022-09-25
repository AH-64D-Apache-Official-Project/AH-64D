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

if (player == currentPilot _heli) then {

    /////////////////////////////////////////////////////////////////////
    ///////Blade Simulation        //////////////////////////////////////
    /////////////////////////////////////////////////////////////////////

    //Input Values
    private _bladePitch      = _heli animationSourcePhase "cyclicForward";
    private _bladeRoll       = (_heli animationSourcePhase "cyclicAside") * -1;
    private _colletiveOut    = _heli animationSourcePhase "collective";
    private _mainRtrPctRot   = (_heli animationphase "mainRotor") * 360;  // 0 to 1, going counterclockwise, 0  is the nose.
    Private _RudderYaw       = (-1 * ((inputAction "HeliRudderLeft") - (inputAction "HeliRudderRight")));
    private _Cyclicdir = [0,0] getdir [_bladeRoll, _bladePitch];
    private _cyclicmagnatude = vectorMagnitude [_bladeRoll, _bladePitch];
    private _cyclicmagnatude = [_cyclicmagnatude, 0, 1] call BIS_fnc_clamp;

    //Rudder smoothing
    private _RudderYawOutput = _heli getvariable ["Fza_ah64_RudderOutputValue", 0];
    Private _RudderYawOutput =  [_RudderYawOutput, _RudderYaw, 0.1] call BIS_fnc_lerp; 
    _heli setvariable ["Fza_ah64_RudderOutputValue", _RudderYawOutput];
    
    //Tables
    private _bladeFlapTable = [[0.0,   0.00],
                              [0.57,  0.50],
                              [1.01,  1.00]];

    private _bladePitchTable = [[0, -1],
                                [90, 0],
                                [180, 1],
                                [270, 0],
                                [360, -1]];

    //Blade posiiton
    private _blade1CyclicOfset = abs(_Cyclicdir - _mainRtrPctRot mod 360);
    private _blade2CyclicOfset = abs(_Cyclicdir - (_mainRtrPctRot + 90) mod 360);
    private _blade3CyclicOfset = abs(_Cyclicdir - (_mainRtrPctRot + 180) mod 360);
    private _blade4CyclicOfset = abs(_Cyclicdir - (_mainRtrPctRot + 270) mod 360);
    private _SPA1CyclicOfset   = abs(_Cyclicdir - (_mainRtrPctRot + 285) mod 360);

    //blade Coef
    private _blade1Coef = ([_bladePitchTable, _blade1CyclicOfset] call fza_fnc_linearInterp) # 1;
    private _blade2Coef = ([_bladePitchTable, _blade2CyclicOfset] call fza_fnc_linearInterp) # 1;
    private _blade3Coef = ([_bladePitchTable, _blade3CyclicOfset] call fza_fnc_linearInterp) # 1;
    private _blade4Coef = ([_bladePitchTable, _blade4CyclicOfset] call fza_fnc_linearInterp) # 1;
    private _SParmCoef = ([_bladePitchTable, _SPA1CyclicOfset] call fza_fnc_linearInterp) # 1;

    //blade output
    private _blade1Output = _blade1Coef * _cyclicmagnatude;
    private _blade2Output = _blade2Coef * _cyclicmagnatude;
    private _blade3Output = _blade3Coef * _cyclicmagnatude;
    private _blade4Output = _blade4Coef * _cyclicmagnatude;
    private _SParmPitch = _SParmCoef * _cyclicmagnatude;

    //blade Flapping
    private _rpm = (_heli getVariable "fza_sfmplus_engPctNP" select 0) max (_heli getVariable "fza_sfmplus_engPctNP" select 1);
    private _bladeFlapTableInterp = [_bladeFlapTable, _rpm] call fza_fnc_linearInterp;
    private _bladeFlapLimit       = _bladeFlapTableInterp select 1;

    //Rotor Blade Coning
    private _bladeConeOut = _colletiveOut * 0.5;

    //Main Rotor Blade Flap           
    _heli animateSource["blade1_flap", ((_blade1Output * _cyclicmagnatude) + _bladeConeOut) * _bladeFlapLimit]; // Functional, Coneing needs tuning
    _heli animateSource["blade2_flap", ((_blade2Output * _cyclicmagnatude) + _bladeConeOut) * _bladeFlapLimit]; // Functional, Coneing needs tuning
    _heli animateSource["blade3_flap", ((_blade3Output * _cyclicmagnatude) + _bladeConeOut) * _bladeFlapLimit]; // Functional, Coneing needs tuning
    _heli animateSource["blade4_flap", ((_blade4Output * _cyclicmagnatude) + _bladeConeOut) * _bladeFlapLimit]; // Functional, Coneing needs tuning
    //Main Rotor Blade Pitch
    _heli animateSource["blade1_pitch", (_blade1Output * _cyclicmagnatude) + _colletiveOut, true];      // Functional
    _heli animateSource["blade2_pitch", (_blade2Output * _cyclicmagnatude) + _colletiveOut, true];      // Functional
    _heli animateSource["blade3_pitch", (_blade3Output * _cyclicmagnatude) + _colletiveOut, true];      // Functional
    _heli animateSource["blade4_pitch", (_blade4Output * _cyclicmagnatude) + _colletiveOut, true];      // Functional
    //Main Rotor Squashplate
    _heli animateSource["swup_arm2", (_SParmPitch * _cyclicmagnatude)];                                 // Functional
    _heli animateSource["swup_arm4", (_SParmPitch * _cyclicmagnatude)];                                 // Functional
    //Tail Rotor & squashplate
    _heli animateSource["trsw",                 _RudderYawOutput];        // Finished
    _heli animateSource["tr_blade1_pitch", -1 * _RudderYawOutput];        // Finished
    _heli animateSource["tr_blade2_pitch",      _RudderYawOutput];        // Finished
    _heli animateSource["tr_blade3_pitch",      _RudderYawOutput];        // Finished
    _heli animateSource["tr_blade4_pitch", -1 * _RudderYawOutput];        // Finished

    /////////////////////////////////////////////////////////////////////
    ///////Air Probe Simulation    //////////////////////////////////////
    /////////////////////////////////////////////////////////////////////
    
    /*
    private _airvelocityX = (velocity _heli select 0) + (0.836 * (abs(wind select 0) ^ 1.5));
    private _airvelocityY = (velocity _heli select 1) + (0.836 * (abs(wind select 1) ^ 1.5));
    private _airvelocityZ = (velocity _heli select 2) + (0.836 * (abs(wind select 2) ^ 1.5));
    private _velair = [_airvelocityX, _airvelocityY, _airvelocityZ];

    private _velocityMagnitudeX = ((velocity _heli select 0) + (0.836 * (abs(wind select 0) ^ 1.5))) ^ 2; //Times 2 basicaly
    private _velocityMagnitudeY = ((velocity _heli select 1) + (0.836 * (abs(wind select 1) ^ 1.5))) ^ 2;
    private _velocityMagnitudeZ = ((velocity _heli select 2) + (0.836 * (abs(wind select 2) ^ 1.5))) ^ 2;
    private _velmag = sqrt(_velocityMagnitudeX + _velocityMagnitudeY + _velocityMagnitudeZ);

    private _vertvect = ((_velair select 2) atan2 sqrt(((_velair select 0) * (_velair select 0)) + ((_velair select 1) * (_velair select 1))));
    private _velfactor = _velmag * 0.05;
    private _smoothfactor = abs(20 - _velmag) * 0.05;
    if (_velfactor > 1) then {_velfactor = 1;};

    _weight = 90;
    _weight = _weight * _smoothfactor;

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

    private _1 = random 1;
    private _2 = random 1;
    if (random 1 >= 0.5) then {_2 = _2 - 1;};
    if (random 1 >= 0.5) then {_1 = _1 - 1;};

    _heli animateSource["l_ads_p", (_vertvect1 + _vertvect2 + _1) * 0.002778];
    _heli animateSource["l_ads_y", (_horvect1 + _horvect2 + _2) * 0.002778];
    _heli animateSource["r_ads_p", (_vertvect1 + _vertvect2 + _2) * 0.002778];
    _heli animateSource["r_ads_y", (_horvect1 + _horvect2 + _1) * 0.002778];
    */

};

/* Rewrite of the Air Probe sim
//Input
private _velair = velocity _heli - wind select;
private _velmag = vectorMagnitude _velair;
private _vertvect = ((_velair select 2) atan2 sqrt(((_velair select 0) * (_velair select 0)) + ((_velair select 1) * (_velair select 1))));

private _velfactor = _velmag * 0.05;
if (_velfactor > 1) then {_velfactor = 1;};
private _smoothfactor = abs(20 - _velmag) * 0.05;

_weight = 90;
_weight = _weight * _smoothfactor;

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

private _1 = random 1;
private _2 = random 1;
if (random 1 >= 0.5) then {_2 = _2 - 1;};
if (random 1 >= 0.5) then {_1 = _1 - 1;};

_heli animateSource["l_ads_p", (_vertvect1 + _vertvect2 + _1) * 0.002778];
_heli animateSource["l_ads_y", (_horvect1 + _horvect2 + _2) * 0.002778];
_heli animateSource["r_ads_p", (_vertvect1 + _vertvect2 + _2) * 0.002778];
_heli animateSource["r_ads_y", (_horvect1 + _horvect2 + _1) * 0.002778];