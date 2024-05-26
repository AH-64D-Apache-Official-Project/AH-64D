/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_simpleRotorMain

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
params ["_heli", "_deltaTime", "_altitude", "_temperature", "_dryAirDensity", "_attHoldCycPitchOut", "_attHoldCycRollOut", "_altHoldCollOut"];
#include "\fza_ah64_sfmplus\headers\core.hpp"

private _rtrPos                 = [0.0, 2.06, 0.70];
private _rtrHeightAGL           = 3.606;   //m
private _rtrDesignRPM           = 289.0;
private _rtrRPMTrimVal          = 1.01;
private _rtrGearRatio           = 72.29;
private _rtrNumBlades           = 4;

private _bladeRadius            = 7.315;   //m
private _bladeChord             = 0.533;   //m
private _bladePitch_min         = 1.0;     //deg
private _bladePitch_max         = 19.0;    //deg

private _rtrPowerScalarTable    = [
                                   [   0, 1.777]
                                  ,[2000, 1.617]
                                  ,[4000, 1.530]
                                  ,[6000, 1.377]
                                  ,[8000, 1.284]
                                  ];
private _rtrGndEffModifier        = 0.238;
private _rtrThrustScalarTable_min = [
                                     [    0, 0.126]
                                    ,[ 2000, 0.123]
                                    ,[ 4000, 0.128]
                                    ,[ 6000, 0.134]
                                    ,[ 8000, 0.139]
                                    ,[10000, 0.151]
                                    ,[12000, 0.155]
                                    ];
private _rtrThrustScalarTable_max = [
                                     [    0, 1.534]
                                    ,[ 2000, 1.940]
                                    ,[ 4000, 2.290]
                                    ,[ 6000, 2.780]
                                    ,[ 8000, 3.320]
                                    ,[10000, 3.645]
                                    ,[12000, 4.175]
                                    ];
private _rtrAirspeedVelocityMod = 0.4;
private _rtrTorqueScalar        = 1.0; //0.95, 1.10

private _pitchTorqueScalar      = 2.75;//2.25//1.75;//PITCH_SCALAR;
private _rollTorqueScalar       = 1.00;//0.75;//ROLL_SCALAR;

private _altitude_max           = 30000;   //ft
private _baseThrust             = 102302;  //N - max gross weight (kg) * gravity (9.806 m/s)

//Thrust produced 
private _bladePitch_cur                = _bladePitch_min + (_bladePitch_max - _bladePitch_min) * (fza_sfmplus_collectiveOutput + _altHoldCollOut);
private _rtrThrustScalar_min           = [_rtrThrustScalarTable_min, _altitude] call fza_fnc_linearInterp select 1;
private _bladePitchInducedThrustScalar = _rtrThrustScalar_min + ((1 - _rtrThrustScalar_min) / _bladePitch_max)  * _bladePitch_cur;
(_heli getVariable "fza_sfmplus_engPctNP")
    params ["_eng1PctNP", "_eng2PctNp"];
private _inputRPM                  = _eng1PctNP max _eng2PctNp;
//Rotor induced thrust as a function of RPM
private _rtrThrustScalar_max           = [_rtrThrustScalarTable_max, _altitude] call fza_fnc_linearInterp select 1;
private _rtrRPMInducedThrustScalar = (_inputRPM / _rtrRPMTrimVal) * _rtrThrustScalar_max;
//Thrust scalar as a result of altitude
private _airDensityThrustScalar    = _dryAirDensity / ISA_STD_DAY_AIR_DENSITY;
//Additional thrust gained from increasing forward airspeed
private _velXY                      = vectorMagnitude [velocityModelSpace _heli # 0, velocityModelSpace _heli # 1];
private _airspeedVelocityScalar    = (1 + (_velXY / VEL_BEST_ENDURANCE)) ^ (_rtrAirspeedVelocityMod);
//Induced flow handler
private _velZ                      = velocityModelSpace _heli # 2;
private _inducedVelocityScalar     = 1.0;
if (_velZ < -VEL_VRS && _velXY < VEL_ETL) then { 
    _inducedVelocityScalar = 0.0;
} else {
    private _isAutorotating = _heli getVariable "fza_sfmplus_isAutorotating";
    //Collective must be < 20% and TAS must be < 145 kts
    if (_isAutorotating && _velXY < 74.59) then {
        _inducedVelocityScalar = 1 - (_velZ / 7.62);
    } else {
        _inducedVelocityScalar = 1 - (_velZ / VEL_VRS);
    };
};
//Finally, multiply all the scalars above to arrive at the final thrust scalar
private _rtrThrustScalar           = _bladePitchInducedThrustScalar * _rtrRPMInducedThrustScalar * _airDensityThrustScalar * _airspeedVelocityScalar * _inducedVelocityScalar;
private _rtrThrust                 = _baseThrust * _rtrThrustScalar;
private _rtrOmega                  = (2.0 * PI) * ((_rtrDesignRPM * _inputRPM) / 60);
private _bladeTipVel               = _rtrOmega * _bladeRadius;
private _rtrArea                   = PI * _bladeRadius^2;
private _thrustCoef                = if (_rtrOmega <= EPSILON) then { 0.0; } else { _rtrThrust / (_dryAirDensity * _rtrArea * _rtrOmega^2 * _bladeRadius^2); };
_thrustCoef                        = if (_inducedVelocityScalar == 0.0) then { 0.0; } else { _thrustCoef / _inducedVelocityScalar; };

//Calculate the required rotor power
private _vel_vbe     =  38.583;
private _vel_vne     = 128.611;

private _profile_min = 0.1330;
private _profile_max = 0.2080;

private _induced_min = 1.4000;//IND_MIN;//0.8110;
private _induced_max = 0.6100;//IND_MAX;//0.6072;

private _profile_cur = _profile_min + ((_profile_max - _profile_min) / _vel_vne) * _velXY;

private _induced_val = _induced_min * (fza_sfmplus_collectiveOutput + _altHoldCollOut);
private _induced_cur = ((_induced_val - _induced_max) / _vel_vbe) * _velXY + _induced_val;

private _power_val   = _profile_cur + _induced_cur;

private _power_req   = _power_val * 2857.17;
private _torque_req  = (_power_req / 0.001) / 0.105 / 21109;
private _rtrTorque   = _torque_req * _rtrGearRatio;

//Calcualte the required engine torque
private _rtrRPMTorqueScalar        = 1.0;
private _onGnd                   = [_heli] call fza_sfmplus_fnc_onGround;
if (_inputRPM < 1.0 && !_onGnd) then {
    _rtrRPMTorqueScalar = _inputRPM;
};
_rtrRPMTorqueScalar                = [_rtrRPMTorqueScalar, EPSILON, 1.0] call BIS_fnc_clamp;
private _reqEngTorque              = (_rtrTorque / _rtrGearRatio) / _rtrRPMTorqueScalar;
_heli setVariable ["fza_sfmplus_reqEngTorque", _reqEngTorque];

private _axisX = [1.0, 0.0, 0.0];
private _axisY = [0.0, 1.0, 0.0];
private _axisZ = [0.0, 0.0, 1.0];

//Ground Effect
private _heightAGL    = _rtrHeightAGL  + (ASLToAGL getPosASL _heli # 2);
private _rtrDiam      = _bladeRadius * 2;
private _gndEffScalar = (1 - (_heightAGL / _rtrDiam)) * _rtrGndEffModifier;
_gndEffScalar         = [_gndEffScalar, 0.0, 1.0] call BIS_fnc_clamp;
private _gndEffThrust = _rtrThrust * _gndEffScalar;
//private _totThrust    = _heli getVariable "fza_sfmplus_rtrThrust" select 0;
private _totThrust    = _rtrThrust + _gndEffThrust;//[_totThrust, _rtrThrust + _gndEffThrust, _deltaTime] call BIS_fnc_lerp;
[_heli, "fza_sfmplus_rtrThrust", 0, _totThrust, true] call fza_fnc_setArrayVariable;
private _thrustZ      = _axisZ vectorMultiply (_totThrust * _deltaTime);

//Pitch torque
private _cyclicFwdAftTrim    = _heli getVariable "fza_ah64_forceTrimPosPitch";
private _torqueX             = ((_rtrThrust * (fza_sfmplus_cyclicFwdAft + _cyclicFwdAftTrim + _attHoldCycPitchOut)) * _pitchTorqueScalar) * _deltaTime;
//Roll torque
private _cyclicLeftRightTrim = _heli getVariable "fza_ah64_forceTrimPosRoll";
private _torqueY             = ((_rtrThrust * (fza_sfmplus_cyclicLeftRight + _cyclicLeftRightTrim + _attHoldCycRollOut)) * _rollTorqueScalar) * _deltaTime;
//Main rotor yaw torque
private _torqueZ             = (_rtrTorque  * _rtrTorqueScalar) * _deltaTime;

private _mainRtrDamage  = _heli getHitPointDamage "HitHRotor";

//Rotor forces
if (currentPilot _heli == player) then {
    if (_mainRtrDamage < 0.99) then {
        //Main rotor thrust
        _heli addForce  [_heli vectorModelToWorld _thrustZ, _rtrPos];
        private _torque = [0.0, 0.0, 0.0];

        //Main rotor torque
        if (fza_ah64_sfmplusEnableTorqueSim) then {
            _torque = [_torqueX, _torqueY, _torqueZ];
        } else {
            _torque = [_torqueX, _torqueY, 0.0];
        };
        _heli addTorque (_heli vectorModelToWorld _torque);
    };
};

if (cameraView == "INTERNAL") then {
    //Camera shake effect for ETL (16 to 24 knots)
    if (_velXY > 8.23 && _velXY < 12.35) then {
        enableCamShake true;
        setCamShakeParams [0.0, 0.5, 0.0, 0.0, true];
        addCamShake       [0.9, 0.4, 6.2];
        enableCamShake false;

        setCustomSoundController[_heli, "CustomSoundController3", 1.5];
        setCustomSoundController[_heli, "CustomSoundController4", 0.8];
    } else {
        setCustomSoundController[_heli, "CustomSoundController4", 0.0];
    };

    //Camera shake effect for vortex ring sate
    if (_velXY < 12.35) then {  //must be less than ETL
        //2000 fpm to 2933fpm
        if (_velZ < -10.16 && _velZ > -14.89) then {
            enableCamShake true;
            setCamShakeParams [0.0, 0.5, 0.0, 0.0, true];
            addCamShake       [2.5, 1, 5];
            enableCamShake false;

            setCustomSoundController[_heli, "CustomSoundController3", 6.4];
            setCustomSoundController[_heli, "CustomSoundController4", 1.8];
        };
        //2933 fpm to 3867 
        if (_velZ <= -14.89 && _velZ > -19.64) then {
            enableCamShake true;
            setCamShakeParams [0.0, 0.5, 0.0, 0.5, true];
            addCamShake       [3, 1, 5.5];
            enableCamShake false;

            setCustomSoundController[_heli, "CustomSoundController3", 6.4];
            setCustomSoundController[_heli, "CustomSoundController4", 1.8];
        };
        //3867fpm to 4800 fpm
        if (_velZ <= -19.64 && _velZ > -24.384) then {
            enableCamShake true;
            setCamShakeParams [0.0, 0.75, 0.0, 0.75, true];
            addCamShake       [3.5, 1, 6.0];
            enableCamShake false;

            setCustomSoundController[_heli, "CustomSoundController3", 6.4];
            setCustomSoundController[_heli, "CustomSoundController4", 1.8];
        };
        //> 4800fpm
        if (_velZ < -24.384) then {
            enableCamShake true;
            setCamShakeParams [0.0, 1.0, 0.0, 2.0, true];
            addCamShake       [4.0, 1, 6.5];
            enableCamShake false;

            setCustomSoundController[_heli, "CustomSoundController3", 6.4];
            setCustomSoundController[_heli, "CustomSoundController4", 1.8];
        };
    } else {
        setCustomSoundController[_heli, "CustomSoundController4", 0.0];
    };
};

#ifdef __A3_DEBUG__
[_heli, _rtrPos, _rtrPos vectorAdd _axisX, "red"]   call fza_fnc_debugDrawLine;
[_heli, _rtrPos, _rtrPos vectorAdd _axisY, "green"] call fza_fnc_debugDrawLine;
[_heli, _rtrPos, _rtrPos vectorAdd _axisZ, "blue"]  call fza_fnc_debugDrawLine;
[_heli, 24, _rtrPos, _bladeRadius, 2, "white", 0]   call fza_fnc_debugDrawCircle;
#endif

//[_outThrust, _outTq];

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
                    \nPitch = %11", _rtrOmega, _bladeTipVel, _rtrPowerReq * 0.001, _reqEngTorque, (_reqEngTorque / 2) / 481, (_reqEngTorque / 2) / 481, _velZ, _inducedVelocityScalar, _gndEffScalar, fza_sfmplus_collectiveOutput, _heli call BIS_fnc_getPitchBank select 0];
                    */