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
params ["_heli"];
#include "\fza_ah64_sfmplus\headers\core.hpp"
#include "\fza_ah64_systems\headers\systems.hpp"

if (!local _heli) exitWith {};

private _deltaTime              = fza_ah64_fixedTimeStep;

private _altitude               = _heli getVariable "fza_sfmplus_PA";
private _temperature            = _heli getVariable "fza_sfmplus_FAT";
private _dryAirDensity          = _heli getVariable "fza_sfmplus_rho";

private _hdgHoldPedalYawOut     = _heli getVariable "fza_sfmplus_fmcHdgHoldPedalYawOut";
private _sasYawOut              = _heli getVariable "fza_sfmplus_fmcSasYawOut";
private _fmcYawOut              = _hdgHoldPedalYawOut + _sasYawOut;

private _rtrPos                 = [-0.87, -6.98, -0.075];
private _rtrDesignRPM           = 1403.0;
private _rtrRPMTrimVal          = 1.01;
private _rtrGearRatio           = 14.90;
private _rtrNumBlades           = 4;

private _bladeRadius            = 1.402;   //m
private _bladeChord             = 0.253;   //m
private _bladePitchInducedThrustTable = [
    [-1.00,  0.3000]
   ,[-0.90,  0.2200]
   ,[-0.80,  0.1500]
   ,[-0.70,  0.1000]
   ,[-0.60,  0.0620]
   ,[-0.50,  0.0380]
   ,[-0.40,  0.0250]
   ,[-0.30,  0.0190]
   ,[-0.20,  0.0145]
   ,[-0.10,  0.0134]
   ,[ 0.00,  0.0133]
   ,[ 0.10,  0.0060]
   ,[ 0.20, -0.0145]
   ,[ 0.30, -0.0377]
   ,[ 0.40, -0.0609]
   ,[ 0.50, -0.0841]
   ,[ 0.60, -0.1073]
   ,[ 0.70, -0.1304]
   ,[ 0.80, -0.1536]
   ,[ 0.90, -0.1768]
   ,[ 1.00, -0.2000]
  ];
private _rtrAirspeedVelocityMod = 0.4;
private _baseThrust             = 102302;  //N - max gross weight (kg) * gravity (9.806 m/s)

//Thrust produced
private _pedalLeftRight     = _heli getVariable "fza_sfmplus_pedalLeftRight";
private _pedalLeftRightTrim = 0.0;
_pedalLeftRightTrim         = _heli getVariable "fza_ah64_forceTrimPosPedal";

private _pedalInput         = ([_pedalLeftRight, _pedalLeftRightTrim] call fza_sfmplus_fnc_getInterpInput) + _fmcYawOut;
_pedalInput                 = [_pedalInput, -1.0, 1.0] call BIS_fnc_clamp;
private _bladePitchInducedThrustScalar = ([_bladePitchInducedThrustTable, _pedalInput] call fza_fnc_linearInterp select 1) * 0.7;//linearConversion [_bladePitch_min, _bladePitch_max, _bladePitch_cur, _rtrThrustScalar_min, _rtrThrustScalar_max, true];
//systemChat format ["_bladePitchInducedThrustScalar = %1 -- _pedalLeftRight = %2", _bladePitchInducedThrustScalar toFixed 3, _pedalLeftRight];
(_heli getVariable "fza_sfmplus_engPctNP")
    params ["_eng1PctNP", "_eng2PctNp"];
private _inputRPM                  = _eng1PctNP max _eng2PctNp;
//Rotor induced thrust as a function of RPM
private _rtrRPMInducedThrustScalar = _inputRPM / _rtrRPMTrimVal;

//Thrust scalar as a result of altitude
private _airDensityThrustScalar    = _dryAirDensity / ISA_STD_DAY_AIR_DENSITY;
//Additional thrust gained from increasing forward airspeed
private _deltaPos                  = _rtrPos vectorDiff (getCenterOfMass _heli);
private _velY                      = _heli getVariable "fza_sfmplus_velModelSpace" select 1;
private _velZ                      = _heli getVariable "fza_sfmplus_velModelSpace" select 2;
private _velWindY                  = _heli getVariable "fza_sfmplus_velWindModelSpace" select 1;
private _velWindX                  = _heli getVariable "fza_sfmplus_velWindModelSpace" select 0;
if (_velWindY < 0.0) then {
    _velWindY = 0.0;
};
private _velYZ                     = vectorMagnitude [_velY + _velWindY, _velZ];
private _airspeedVelocityScalar    = (1 + (_velYZ / VEL_VBE)) ^ (_rtrAirspeedVelocityMod);
//Induced flow handler
private _velX                      = _heli getVariable "fza_sfmplus_velModelSpace" select 0;
_velX = _velX * sin (_heli getVariable "fza_sfmplus_aero_beta_deg");
_velX = _velX + _velWindX;

private _inducedVelocityScalar     = 1.0;
if (_velX < -VEL_VRS && _velYZ < VEL_ETL) then { 
    _inducedVelocityScalar = 0.0;
} else { 
    _inducedVelocityScalar = 1 - (_velX / VEL_VRS);
};
//Finally, multiply all the scalars above to arrive at the final thrust scalar
private _rtrThrustScalar   = _bladePitchInducedThrustScalar * _rtrRPMInducedThrustScalar * _airDensityThrustScalar * _airspeedVelocityScalar * _inducedVelocityScalar;
private _rtrThrust         = _baseThrust * _rtrThrustScalar;

private _axisX = [1.0, 0.0, 0.0];
private _axisY = [0.0, 1.0, 0.0];
private _axisZ = [0.0, 0.0, 1.0];

private _totThrust     = _rtrThrust;
private _thrustVector  = _axisX vectorMultiply (_totThrust * _deltaTime);
private _moment        = _thrustVector vectorCrossProduct _deltaPos;
//systemChat format ["tail rotor _torqueZ = %1 -- _totThrust = %2 -- _deltaPos = %3 zz", (_moment select 2) toFixed 0, _totThrust toFixed 0, _deltaPos];

private _tailRtrDamage = _heli getHitPointDamage "hitvrotor";
private _IGBDamage     = _heli getHitPointDamage "hit_drives_intermediategearbox";
private _TGBDamage     = _heli getHitPointDamage "hit_drives_tailrotorgearbox";

private _outThrust = [0.0, 0.0, 0.0];
private _outTq     = [0.0, 0.0, 0.0];
if (_tailRtrDamage < 0.85 && _IGBDamage < SYS_IGB_DMG_THRESH && _TGBDamage < SYS_TGB_DMG_THRESH) then {
    if (currentPilot _heli == player) then {     
        //Tail rotor thrust force
        _heli addForce [_heli vectorModelToWorld _thrustVector, _rtrPos];

        //Tail rotor torque
        _heli addTorque (_heli vectorModelToWorld _moment);
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