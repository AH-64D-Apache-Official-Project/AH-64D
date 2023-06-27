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
params ["_heli", "_deltaTime", "_altitude", "_temperature", "_dryAirDensity", "_altHoldCollOut"];
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
private _rtrGndEffModifier      = 0.238;
private _rtrThrustScalar_min    = 0.120;
private _rtrThrustScalar_max    = 1.830;   //20,200lbs @ 6700ft, 15 deg C and 0.9 collective
private _rtrAirspeedVelocityMod = 0.4;
private _rtrTorqueScalar        = 1.10;

private _altitude_max           = 30000;   //ft
private _baseThrust             = 102302;  //N - max gross weight (kg) * gravity (9.806 m/s)

//Thrust produced 
private _bladePitch_cur                = _bladePitch_min + (_bladePitch_max - _bladePitch_min) * (fza_sfmplus_collectiveOutput + _altHoldCollOut);
private _bladePitchInducedThrustScalar = _rtrThrustScalar_min + ((1 - _rtrThrustScalar_min) / _bladePitch_max)  * _bladePitch_cur;
(_heli getVariable "fza_sfmplus_engPctNP")
    params ["_eng1PctNP", "_eng2PctNp"];
private _inputRPM                  = _eng1PctNP max _eng2PctNp;
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
    //Collective must be < 20% and TAS must be < 145 kts
    if (fza_sfmplus_collectiveOutput < 0.20 && _velXY < 74.59) then {
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

//Calculate the hover induced velocity
private _sign                      = [_rtrThrust] call fza_fnc_sign;
private _rtrInducedVelocity        = if (_rtrThrust <= MIN_THRUST) then { 0.0; } else { sqrt((abs _rtrThrust) / (2 * _dryAirDensity * _rtrArea)) * _sign; };
//Gather the velocities required to determine the actual induced flow velocity using the newton-raphson method
private _w = _rtrInducedVelocity;
private _u = if (_w <= EPSILON) then { 0.0; } else { _velXY / _rtrInducedVelocity; };
private _n = if (_w <= EPSILON) then { 0.0; } else { _velZ  / _rtrInducedVelocity; };
private _rtrCorrInducedVelocity    = if (_w <= EPSILON) then { 0.0; } else { [_w, _u, _n] call fza_sfmplus_fnc_simpleRotorNewtRaphSolver; };
_rtrCorrInducedVelocity            = _rtrCorrInducedVelocity * _rtrInducedVelocity;
//Calculate the required rotor power
private _rtrPowerScalar            = [_rtrPowerScalarTable, _altitude] call fza_fnc_linearInterp select 1;
private _rtrPowerReq               = (_rtrThrust * _velZ + _rtrThrust * _rtrCorrInducedVelocity) * _rtrPowerScalar;
//Calculate the required rotor torque
private _rtrTorque                 = if (_rtrOmega <= EPSILON) then { 0.0; } else { _rtrPowerReq / _rtrOmega; };
//Calcualte the required engine torque
private _reqEngTorque              = _rtrTorque / _rtrGearRatio;
_heli setVariable ["fza_sfmplus_reqEngTorque", _reqEngTorque];

private _axisX = [1.0, 0.0, 0.0];
private _axisY = [0.0, 1.0, 0.0];
private _axisZ = [0.0, 0.0, 1.0];

//Ground Effect
private _heightAGL    = _rtrHeightAGL  + (ASLToAGL getPosASL _heli # 2);
private _rtrDiam      = _bladeRadius * 2;
private _gndEffScalar = (1 - (_heightAGL / _rtrDiam)) * _rtrGndEffModifier;
_gndEffScalar = [_gndEffScalar, 0.0, 1.0] call BIS_fnc_clamp;
private _gndEffThrust = _rtrThrust * _gndEffScalar;
private _totalThrust  = _rtrThrust + _gndEffThrust;
private _thrustZ      = _axisZ vectorMultiply (_totalThrust * _deltaTime);
private _torqueZ      = _axisZ vectorMultiply ((_rtrTorque  * _rtrTorqueScalar) * _deltaTime);

//Rotor thrust force
_heli addForce [_heli vectorModelToWorld _thrustZ, _rtrPos];
//Main rotor torque effect
if (fza_ah64_sfmplusEnableTorqueSim) then {
    _heli addTorque (_heli vectorModelToWorld _torqueZ);
};
//Camera shake effect for ETL (16 to 24 knots)
if (_velXY > 8.23 && _velXY < 12.35) then {
    enableCamShake true;
    setCamShakeParams [0.0, 0.5, 0.0, 0.0, true];
    addCamShake       [2.5, 1, 5];
    enableCamShake false;

    setCustomSoundController[_heli, "CustomSoundController3", 6.4];
    setCustomSoundController[_heli, "CustomSoundController4", 1.8];
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
};;

#ifdef __A3_DEBUG__
[_heli, _rtrPos, _rtrPos vectorAdd _axisX, "red"]   call fza_fnc_debugDrawLine;
[_heli, _rtrPos, _rtrPos vectorAdd _axisY, "green"] call fza_fnc_debugDrawLine;
[_heli, _rtrPos, _rtrPos vectorAdd _axisZ, "blue"]  call fza_fnc_debugDrawLine;
[_heli, 24, _rtrPos, _bladeRadius, 2, "white", 0]   call fza_fnc_debugDrawCircle;
#endif

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