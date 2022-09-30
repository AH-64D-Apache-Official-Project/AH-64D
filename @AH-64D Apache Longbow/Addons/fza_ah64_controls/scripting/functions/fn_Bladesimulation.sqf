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

if !(player == currentPilot _heli) exitwith {};

/////////////////////////////////////////////////////////////////////
///////Blade Simulation        //////////////////////////////////////
/////////////////////////////////////////////////////////////////////

//Input Values
private _bladePitch      = _heli animationSourcePhase "cyclicForward";
private _bladeRoll       = (_heli animationSourcePhase "cyclicAside") * -1;
private _colletiveOut    = _heli animationSourcePhase "collective";
private _mainRtrPctRot   = (_heli animationphase "mainRotor") * 360;  // 0 to 1, going counterclockwise, 0  is the nose.
Private _RudderYaw       = (-1 * ((inputAction "HeliRudderLeft") - (inputAction "HeliRudderRight")));
private _Cyclicdir       = [0,0] getdir [_bladeRoll, _bladePitch];
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
private _rtrRPM = ((_heli animationPhase "mainrotorRPM") * 1.08) / 10;
private _bladeFlapTableInterp = [_bladeFlapTable, _rtrRPM] call fza_fnc_linearInterp;
private _bladeFlapLimit       = _bladeFlapTableInterp select 1;

//Rotor Blade Coning
private _bladeConeOut = _colletiveOut * 0.3;

//Main Rotor Blade Flap
_heli animateSource["blade1_flap", (_blade1Output + _bladeConeOut) * _bladeFlapLimit];  // Finished
_heli animateSource["blade2_flap", (_blade2Output + _bladeConeOut) * _bladeFlapLimit];  // Finished
_heli animateSource["blade3_flap", (_blade3Output + _bladeConeOut) * _bladeFlapLimit];  // Finished
_heli animateSource["blade4_flap", (_blade4Output + _bladeConeOut) * _bladeFlapLimit];  // Finished
//Main Rotor Blade Pitch
_heli animateSource["blade1_pitch", _blade1Output + _colletiveOut, true];               // Finished
_heli animateSource["blade2_pitch", _blade2Output + _colletiveOut, true];               // Finished
_heli animateSource["blade3_pitch", _blade3Output + _colletiveOut, true];               // Finished
_heli animateSource["blade4_pitch", _blade4Output + _colletiveOut, true];               // Finished
//Main Rotor Squashplate
_heli animateSource["swup_arm2", _SParmPitch];                                          // Finished
_heli animateSource["swup_arm4", _SParmPitch];                                          // Finished
//Tail Rotor & squashplate
_heli animateSource["trsw",                 _RudderYawOutput];                          // Finished
_heli animateSource["tr_blade1_pitch", -1 * _RudderYawOutput];                          // Finished
_heli animateSource["tr_blade2_pitch",      _RudderYawOutput];                          // Finished
_heli animateSource["tr_blade3_pitch",      _RudderYawOutput];                          // Finished
_heli animateSource["tr_blade4_pitch", -1 * _RudderYawOutput];                          // Finished

/////////////////////////////////////////////////////////////////////
///////Air Probe Simulation    //////////////////////////////////////
/////////////////////////////////////////////////////////////////////

//NOT WORKING 
/*
//Input
private _velair = velocity _heli - wind select;
private _velmag = vectorMagnitude _velair;
private _vertvect = ((_velair select 2) atan2 sqrt(((_velair select 0) * (_velair select 0)) + ((_velair select 1) * (_velair select 1))));
private _weight = 90;

private _velfactor = _velmag * 0.05;
if (_velfactor > 1) then {_velfactor = 1;};

private _vertvect = (_vertvect * _velfactor) + _weight;
private _helipb = _heli call fza_fnc_getPitchBank;
private _vertvect = (_vertvect - (_helipb select 0));
private _horveldir = abs((velocity _heli select 0) atan2(velocity _heli select 1));
private _theta = (360 + (_horveldir - (direction _heli))) Mod 360;
private _targhead = _theta;
if (_theta >= 180) then {
    _targhead = _theta - 360;
};
private _horvect = (_targhead * _velfactor);

private _vertvect1 = (sin(_helipb select 1)) * _horvect;
private _vertvect2 = (cos(_helipb select 1)) * _vertvect;

private _horvect1 = (cos(_helipb select 1)) * _horvect;
private _horvect2 = (sin(_helipb select 1)) * _vertvect;

//Lerp Smoothing
private _inputP = (_vertvect1 + _vertvect2) * 0.002778;
private _inputY = (_horvect1 + _horvect2) * 0.002778

private _AirProbePoutput = _heli getvariable ["Fza_ah64_AirProbePoutput", 0];
Private _AirProbePoutput =  [_AirProbePoutput, _inputP, 0.1] call BIS_fnc_lerp; 
_heli setvariable ["Fza_ah64_AirProbePoutput", _AirProbePoutput];

private _AirProbeYoutput = _heli getvariable ["Fza_ah64_AirProbeYoutput", 0];
Private _AirProbeYoutput =  [_AirProbeYoutput, _inputY, 0.1] call BIS_fnc_lerp; 
_heli setvariable ["Fza_ah64_AirProbeYoutput", _AirProbeYoutput];

//Left airprobe
_heli animateSource["l_ads_p", _AirProbePoutput];
_heli animateSource["l_ads_y",  _AirProbeYoutput];

//Right airprobe
_heli animateSource["r_ads_p", _AirProbePoutput];
_heli animateSource["r_ads_y",  _AirProbeYoutput];