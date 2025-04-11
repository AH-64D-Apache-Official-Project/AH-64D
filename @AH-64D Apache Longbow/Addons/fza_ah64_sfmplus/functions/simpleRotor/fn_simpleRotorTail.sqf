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

private _hdgHoldPedalYawOut     = _heli getVariable "fza_sfmplus_hdgHoldPedalYawOut";

private _rtrPos                 = [-0.87, -6.98, -0.075];
private _rtrDesignRPM           = 1403.0;
private _rtrRPMTrimVal          = 1.01;
private _rtrGearRatio           = 14.90;
private _rtrNumBlades           = 4;

private _bladeRadius            = 1.402;   //m
private _bladeChord             = 0.253;   //m
//private _bladePitch_min         = -15.0;   //deg
//private _bladePitch_max         =  27.0;   //deg
private _bladePitchTable = [
    [-1.00, -15.0]
   ,[-0.90, -14.8]
   ,[-0.80, -14.5]
   ,[-0.70, -14.2]
   ,[-0.60, -14.0]
   ,[-0.50, -13.5]
   ,[-0.40, -12.8]
   ,[-0.30, -11.9]
   ,[-0.20, -10.5]
   ,[-0.10,  -8.0]
   ,[ 0.00,  -3.4]
   ,[ 0.10,   3.4]
   ,[ 0.20,  13.0]
   ,[ 0.30,  18.0]
   ,[ 0.40,  20.5]
   ,[ 0.50,  22.5]
   ,[ 0.60,  24.0]
   ,[ 0.70,  25.0]
   ,[ 0.80,  25.8]
   ,[ 0.90,  26.5]
   ,[ 1.00,  27.0]
  ];

  private _bladePitchInducedThrustTable = [
    [-15.0,  0.1500]
   ,[-14.8,  0.1000]
   ,[-14.5,  0.0700]
   ,[-14.2,  0.0500]
   ,[-14.0,  0.0350]
   ,[-13.5,  0.0250]
   ,[-12.8,  0.0190]
   ,[-11.9,  0.0145]
   ,[-10.5,  0.0139]
   ,[ -8.0,  0.0134]
   ,[ -3.4,  0.0133]
   ,[  3.4,  0.0120]
   ,[ 13.0,  0.0110]
   ,[ 18.0,  0.0090]
   ,[ 20.5,  0.0070]
   ,[ 22.5,  0.0040]
   ,[ 24.0, -0.0015]
   ,[ 25.0, -0.0100]
   ,[ 25.8, -0.0220]
   ,[ 26.5, -0.0420]
   ,[ 27.0, -0.0700]
  ];

//private _rtrThrustScalar_min    = THRUST_MIN;//-0.120;//THRUST_MIN;//-0.050;//-0.125;//-0.067;
//private _rtrThrustScalar_max    = THRUST_MAX;// 0.075;//THRUST_MAX;// 0.050;//0.063;// 0.267;
private _sideThrustScalar       = 1.0;
private _rtrAirspeedVelocityMod = 0.4;
private _rtrTorqueScalar        = 1.00;
private _baseThrust             = 102302;  //N - max gross weight (kg) * gravity (9.806 m/s)

//Thrust produced
private _pedalLeftRightTrim     = 0.0;
if (fza_ah64_sfmPlusControlScheme == HOTAS) then {
    _pedalLeftRightTrim = _heli getVariable "fza_ah64_forceTrimPosPedal";
};
private _pedalPosition  = (_heli getVariable "fza_sfmplus_pedalLeftRight") + _pedalLeftRightTrim + _hdgHoldPedalYawOut;
private _bladePitch_cur = [_bladePitchTable, _pedalPosition] call fza_fnc_linearInterp select 1;
private _bladePitchInducedThrustScalar = [_bladePitchInducedThrustTable, _bladePitch_cur] call fza_fnc_linearInterp select 1;//linearConversion [_bladePitch_min, _bladePitch_max, _bladePitch_cur, _rtrThrustScalar_min, _rtrThrustScalar_max, true];
//systemChat format ["_bladePitchInducedThrustScalar = %1 -- _pedalLeftRight = %2", _bladePitchInducedThrustScalar toFixed 3, (_heli getVariable "fza_sfmplus_pedalLeftRight")];
(_heli getVariable "fza_sfmplus_engPctNP")
    params ["_eng1PctNP", "_eng2PctNp"];
private _inputRPM                  = _eng1PctNP max _eng2PctNp;
//Rotor induced thrust as a function of RPM
private _rtrRPMInducedThrustScalar = _inputRPM / _rtrRPMTrimVal;// * _rtrThrustScalar_max;//0.0;

//Thrust scalar as a result of altitude
private _airDensityThrustScalar    = _dryAirDensity / ISA_STD_DAY_AIR_DENSITY;
//Additional thrust gained from increasing forward airspeed
private _velY                      = _heli getVariable "fza_sfmplus_velModelSpace" select 1;
private _velZ                      = _heli getVariable "fza_sfmplus_velModelSpace" select 2;
/*
private _velWindY                  = _heli getVariable "fza_sfmplus_velWindModelSpace" select 1;
if (_velWindY < 0.0) then {
    _velWindY = 0.0;
};
private _velYZ                      = vectorMagnitude [_velY + velWindY, _velZ];
*/
private _velYZ                     = vectorMagnitude [_velY, _velZ];
private _airspeedVelocityScalar    = (1 + (_velYZ / VEL_VBE)) ^ (_rtrAirspeedVelocityMod);
//Induced flow handler
private _velX                      = _heli getVariable "fza_sfmplus_velModelSpace" select 0;
_velX = _velX * sin (_heli getVariable "fza_sfmplus_aero_beta_deg");
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
private _deltaPos      = _rtrPos vectorDiff (getCenterOfMass _heli);

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