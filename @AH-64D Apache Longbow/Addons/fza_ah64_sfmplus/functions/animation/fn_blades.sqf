/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_blades

Description:
    to simulate the cyclinc and collective input into animations visible on 
    the tail rotor, main rotor and squash plates

Parameters:
    _heli = The apache

Returns:
    Nothing

Examples:
    [_heli] call fza_fnc_SimulateBlades;

Author:
	Snow(Dryden)
---------------------------------------------------------------------------- */
params["_heli"];

if !(player == currentPilot _heli) exitwith {};

//Input Values
private _bladePitch      = _heli animationSourcePhase "cyclicForward";
private _bladeRoll       = _heli animationSourcePhase "cyclicAside";
private _colletiveOut    = _heli animationSourcePhase "collective";
private _mainRtrPctRot   = (_heli animationphase "mainRotor") * 360;  // 0 to 1, going counterclockwise, 0  is the nose.
Private _RudderYaw       = (-1 * ((inputAction "HeliRudderLeft") - (inputAction "HeliRudderRight")));
private _Cyclicdir       = [0,0] getdir [_bladePitch, _bladeRoll];
private _cyclicmagnatude = vectorMagnitude [_bladePitch, _bladeRoll];
private _cyclicmagnatude = [_cyclicmagnatude, 0, 1] call BIS_fnc_clamp;

//Rudder smoothing
private _RudderYawOutput = _heli getvariable ["Fza_ah64_RudderOutputValue", 0];
Private _RudderYawOutput =  [_RudderYawOutput, _RudderYaw, 0.1] call BIS_fnc_lerp; 
_heli setvariable ["Fza_ah64_RudderOutputValue", _RudderYawOutput];

//Tables
private _bladePitchTable = [[0, -1],
                            [90, 0],
                            [180, 1],
                            [270, 0],
                            [360, -1]];

//Blade posiiton
private _mainRtrPctRot = (_mainRtrPctRot + 45) mod 360;
private _blade1CyclicOfset = abs(_Cyclicdir - _mainRtrPctRot mod 360);
private _blade2CyclicOfset = abs(_Cyclicdir - (_mainRtrPctRot + 90) mod 360);
private _blade3CyclicOfset = abs(_Cyclicdir - (_mainRtrPctRot + 180) mod 360);
private _blade4CyclicOfset = abs(_Cyclicdir - (_mainRtrPctRot + 270) mod 360);
private _SPA1CyclicOfset   = abs(_Cyclicdir - (_mainRtrPctRot + 285) mod 360);
hintSilent str _blade1CyclicOfset;

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

//Rotor Blade Coning
private _bladeConeOut = _colletiveOut * 0.3;

//Main Rotor Blade Flap
_heli animateSource["blade1_flap", (_blade1Output + _bladeConeOut)];
_heli animateSource["blade2_flap", (_blade2Output + _bladeConeOut)];
_heli animateSource["blade3_flap", (_blade3Output + _bladeConeOut)];
_heli animateSource["blade4_flap", (_blade4Output + _bladeConeOut)];
//Main Rotor Blade Pitch
_heli animateSource["blade1_pitch", (_blade1Output + _colletiveOut) * 0.5, true];
_heli animateSource["blade2_pitch", (_blade2Output + _colletiveOut) * 0.5, true];
_heli animateSource["blade3_pitch", (_blade3Output + _colletiveOut) * 0.5, true];
_heli animateSource["blade4_pitch", (_blade4Output + _colletiveOut) * 0.5, true];
//Main Rotor Squashplate
_heli animateSource["swup_arm2", _SParmPitch];
_heli animateSource["swup_arm4", _SParmPitch];
//Tail Rotor & squashplate
_heli animateSource["trsw",                 _RudderYawOutput];
_heli animateSource["tr_blade1_pitch", -1 * _RudderYawOutput];
_heli animateSource["tr_blade2_pitch",      _RudderYawOutput];
_heli animateSource["tr_blade3_pitch",      _RudderYawOutput];
_heli animateSource["tr_blade4_pitch", -1 * _RudderYawOutput];