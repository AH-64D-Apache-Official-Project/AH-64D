/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_simpleRotorTail

Description:
    Simple rotor provides a simple, grounded in reality simulation of a
    helicopters rotor. Translational Lift, Ground Effect and Vortex Ring State
    are all simulated.

Parameters:
    _heli - The helicopter to get information from [Unit].

Returns:
    ...

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_altitude", "_temperature", "_dryAirDensity"];
#include "\fza_ah64_sfmplus\headers\core.hpp"
#include "\fza_ah64_systems\headers\systems.hpp"

if (!local _heli) exitWith {};

private _deltaTime              = fza_ah64_fixedTimeStep;

private _hdgHoldPedalYawOut     = _heli getVariable "fza_sfmplus_hdgHoldPedalYawOut";

private _rtrPos                 = [-0.87, -6.98, -0.075];
private _rtrDesignRPM           = 1403.0;
private _rtrRPMTrimVal          = 1.01;
private _rtrGearRatio           = 14.90;
private _rtrNumBlades           = 4;

private _bladeRadius            = 1.402;   //m
private _bladeChord             = 0.253;   //m
private _bladePitch_min         = -15.0;   //deg
private _bladePitch_max         =  27.0;   //deg
private _bladePitch_med         = -1.668;

private _rtrPowerScalarTable    = [
                                   [   0, 1.777]
                                  ,[2000, 1.617]
                                  ,[4000, 1.530]
                                  ,[6000, 1.377]
                                  ,[8000, 1.284]
                                  ];
private _rtrThrustScalar_min    = -0.125;
private _rtrThrustScalar_max    =  0.1162;
private _sideThrustScalar       = 1.0;
private _rtrAirspeedVelocityMod = 0.4;
private _rtrTorqueScalar        = 1.00;
private _baseThrust             = 102302;  //N - max gross weight (kg) * gravity (9.806 m/s)

//Thrust produced
private _pedalLeftRightTrim            = 0.0;
if (fza_ah64_sfmPlusControlScheme == HOTAS) then {
    _pedalLeftRightTrim = _heli getVariable "fza_ah64_forceTrimPosPedal";
};
private _bladePitch_cur                = 0.0;
if ((_heli getVariable "fza_sfmplus_pedalLeftRight") < 0.0) then {
    _bladePitch_cur = linearConversion[ 0.0, -1.0, (_heli getVariable "fza_sfmplus_pedalLeftRight") + _pedalLeftRightTrim + _hdgHoldPedalYawOut, _bladePitch_med, _bladePitch_min];
} else {
    _bladePitch_cur = linearConversion[ 0.0,  1.0, (_heli getVariable "fza_sfmplus_pedalLeftRight") + _pedalLeftRightTrim + _hdgHoldPedalYawOut, _bladePitch_med, _bladePitch_max];
};

private _bladePitchInducedThrustScalar = 0.0;
if (_bladePitch_cur < 0.0) then {
    _bladePitchInducedThrustScalar = _rtrThrustScalar_min + ((1 - _rtrThrustScalar_min) / _bladePitch_min) * _bladePitch_cur;
} else {
    _bladePitchInducedThrustScalar = _rtrThrustScalar_max + ((1 - _rtrThrustScalar_max) / _bladePitch_max) * _bladePitch_cur;
};

(_heli getVariable "fza_sfmplus_engPctNP")
    params ["_eng1PctNP", "_eng2PctNp"];
private _inputRPM                  = _eng1PctNP max _eng2PctNp;
//Rotor induced thrust as a function of RPM
private _rtrRPMInducedThrustScalar = 0.0;
if (_bladePitch_cur >= 0.0) then {
    _rtrRPMInducedThrustScalar = _rtrThrustScalar_max * (_inputRPM / _rtrRPMTrimVal);
} else {
    _rtrRPMInducedThrustScalar = _rtrThrustScalar_min * (_inputRPM / _rtrRPMTrimVal);
};

//Thrust scalar as a result of altitude
private _airDensityThrustScalar    = _dryAirDensity / ISA_STD_DAY_AIR_DENSITY;
//Additional thrust gained from increasing forward airspeed
private _velYZ                      = vectorMagnitude [velocityModelSpace _heli # 1, velocityModelSpace _heli # 2];
private _airspeedVelocityScalar    = (1 + (_velYZ / VEL_VBE)) ^ (_rtrAirspeedVelocityMod);
//Induced flow handler
private _velX                      = velocityModelSpace _heli # 0;
private _inducedVelocityScalar     = 1.0;
if (_velX < -VEL_VRS && _velYZ < VEL_ETL) then { 
    _inducedVelocityScalar = 0.0;
} else { 
    _inducedVelocityScalar = 1 - (_velX / VEL_VRS);
};
//Finally, multiply all the scalars above to arrive at the final thrust scalar
private _rtrThrustScalar           = _bladePitchInducedThrustScalar * _rtrRPMInducedThrustScalar * _airDensityThrustScalar * _airspeedVelocityScalar * _inducedVelocityScalar;
private _rtrThrust                 = _baseThrust * _rtrThrustScalar;

private _axisX = [1.0, 0.0, 0.0];
private _axisY = [0.0, 1.0, 0.0];
private _axisZ = [0.0, 0.0, 1.0];

private _totThrust     = _rtrThrust;

private _thrustX       = _axisX vectorMultiply ((_totThrust * _sideThrustScalar * -1.0) * _deltaTime);
private _torqueY       = 0.0;
private _torqueZ       = ((_rtrPos # 1) * _totThrust * -1.0) * _deltaTime; 

private _tailRtrDamage = _heli getHitPointDamage "hitvrotor";
private _IGBDamage     = _heli getHitPointDamage "hit_drives_intermediategearbox";
private _TGBDamage     = _heli getHitPointDamage "hit_drives_tailrotorgearbox";

private _outThrust = [0.0, 0.0, 0.0];
private _outTq     = [0.0, 0.0, 0.0];
if (_tailRtrDamage < 0.85 && _IGBDamage < SYS_IGB_DMG_THRESH && _TGBDamage < SYS_TGB_DMG_THRESH) then {
    if (currentPilot _heli == player) then {     
        //Tail rotor thrust force
        _heli addForce [_heli vectorModelToWorld _thrustX, _rtrPos];

        //Tail rotor torque
        private _torque   = [0.0, _torqueY, _torqueZ];
        _heli addTorque (_heli vectorModelToWorld _torque);
    };
};

#ifdef __A3_DEBUG__
[_heli, _rtrPos, _rtrPos vectorAdd _axisX, "red"]   call fza_fnc_debugDrawLine;
[_heli, _rtrPos, _rtrPos vectorAdd _axisY, "green"] call fza_fnc_debugDrawLine;
[_heli, _rtrPos, _rtrPos vectorAdd _axisZ, "blue"]  call fza_fnc_debugDrawLine;
[_heli, 24, _rtrPos, _bladeRadius, 0, "white", 0]   call fza_fnc_debugDrawCircle;
#endif

[_outThrust, _outTq];

/*
hintsilent format ["v0.7 testing
                    \nRotor Omega = %1
                    \nBlade Tip Vel = %2
                    \nRotor Power Req = %3 kW
                    \nRotor Torque = %4 Nm 
                    \nE1 Tq = %5 % E2 Tq = %6 %
                    \nVelZ = %7
                    \nInduced Vel Scalar = %8
                    \nGnd Eff Scalar = %9
                    \nStab = %10
                    \nPitch = %11", _rtrOmega, _bladeTipVel, _rtrPowerReq * 0.001, _reqEngTorque, (_reqEngTorque / 2) / 481, (_reqEngTorque / 2) / 481, _velZ, _inducedVelocityScalar, _gndEffScalar, (_heli getVariable "fza_sfmplus_collectiveOutput"), _heli call BIS_fnc_getPitchBank select 0];
                    */