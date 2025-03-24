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
params ["_heli", "_altitude", "_temperature", "_dryAirDensity", "_attHoldCycPitchOut", "_attHoldCycRollOut", "_altHoldCollOut"];
#include "\fza_ah64_sfmplus\headers\core.hpp"

if (!local _heli) exitWith {};

private _deltaTime              = fza_ah64_fixedTimeStep;

private _rtrPos                 = [0.0, 2.06, 0.70];
private _rtrHeightAGL           = 3.606;   //m
private _rtrDesignRPM           = 289.0;
private _rtrRPMTrimVal          = 1.01;
private _rtrGearRatio           = 72.291;
private _rtrNumBlades           = 4;

private _bladeRadius            = 7.315;   //m
private _bladeChord             = 0.533;   //m
private _bladePitch_min         = 1.0;     //deg
private _bladePitch_max         = 19.0;    //deg

private _rtrGndEffTable            = [
                                     [    0, 0.410]
                                    ,[ 2000, 0.413]
                                    ,[ 4000, 0.428]
                                    ,[ 6000, 0.407]
                                    ,[ 8000, 0.438]
                                    ];
private _rtrThrustScalarTable_min = [
                                     [    0, 0.032]
                                    ,[ 2000, 0.052]
                                    ,[ 4000, 0.037]
                                    ,[ 6000, 0.041]
                                    ,[ 8000, 0.045]
                                    ];
private _rtrThrustScalarTable_max = [
                                     [    0, 1.152]
                                    ,[ 2000, 1.422]
                                    ,[ 4000, 1.748]
                                    ,[ 6000, 2.132]
                                    ,[ 8000, 2.561]
                                    ];
private _rtrTipLossTable          = [
                                     [ 6804, 1.108]
                                    ,[ 7711, 1.050]
                                    ,[ 8165, 1.000]
                                    ,[ 8618, 0.989]
                                    ,[ 9525, 0.940]
                                    ];

private _rtrAirspeedVelocityMod = 0.4;
private _vrsScalarExponent      = 0.3;
private _rtrTorqueScalar        = 1.0;//0.8; //0.95, 1.10

private _fwdPitchTorqueScalar   = 3.5;//3.25;//3.5;//3.00;
private _aftPitchTorqueScalar   = 3.0;//3.75;//4.5;//3.0;//2.75;//2.48;//2.25//1.75;//PITCH_SCALAR;
private _rollTorqueScalar       = 0.90;//1.00;//0.75;//ROLL_SCALAR;

private _baseThrust             = 102306;  //N - max gross weight (kg) * gravity (9.806 m/s)

//Thrust produced 
private _bladePitch_cur                = _bladePitch_min + (_bladePitch_max - _bladePitch_min) * ((_heli getVariable "fza_sfmplus_collectiveOutput") + _altHoldCollOut);
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
private _airspeedVelocityScalar    = (1 + (_velXY / VEL_VBE)) ^ (_rtrAirspeedVelocityMod);
//Induced flow handler
private _velZ                      = velocityModelSpace _heli # 2;

private _inducedVelocityScalar     = 1.0;
private _vrsVelMin                 = _heli getVariable "fza_sfmplus_vrsVelocityMin";
private _vrsVelMax                 = _heli getVariable "fza_sfmplus_vrsVelocityMax";
private _vrsVel                    = linearConversion[0.0, VEL_ETL, _velXY, _vrsVelMax, VEL_VRS, true];
if (_velZ < -_vrsVelMin && _velXY < VEL_ETL) then {
    private _vrsScalar = if(_velZ == 0.0) then { 0.0; } else { abs(_vrsVelMin / _velZ)^_vrsScalarExponent; };
    _inducedVelocityScalar   = if(_vrsVelMax == 0.0) then { 1.0; } else { (1 - (_velZ / _vrsVelMax)) * _vrsScalar; };
} else {
     private _isAutorotating = _heli getVariable "fza_sfmplus_isAutorotating";
    //Collective must be < 20% and TAS must be < 145 kts
    if (_isAutorotating && _velXY < 74.59) then {
        _inducedVelocityScalar = 1 - (_velZ / 7.62);
    } else {
        _inducedVelocityScalar = if(_vrsVel == 0.0) then { 1.0; } else { 1 - (_velZ / _vrsVel); };
    };
};
//Finally, multiply all the scalars above to arrive at the final thrust scalar
private _rtrThrustScalar           = _bladePitchInducedThrustScalar * _rtrRPMInducedThrustScalar * _airDensityThrustScalar * _airspeedVelocityScalar * _inducedVelocityScalar;
private _rtrThrust                 = _baseThrust * _rtrThrustScalar;
private _rtrOmega                  = (2.0 * PI) * ((_rtrDesignRPM * _inputRPM) / 60);
private _bladeTipVel               = _rtrOmega * _bladeRadius;
private _rtrArea                   = PI * _bladeRadius^2;

//Calculate the required rotor power
private _vel_vbe     =  36.011;
private _vel_vne     = 128.611;

private _profile_min = 0.180;
private _profile_max = 0.704;

private _induced_min = 1.171;//IND_MIN;//0.8110;
private _induced_max = 0.918;//IND_MAX;//0.6072;

private _profile_cur = _profile_min + ((_profile_max - _profile_min) / _vel_vne) * _velXY;

private _induced_val = _induced_min * (_heli getVariable "fza_sfmplus_collectiveOutput");//((_heli getVariable "fza_sfmplus_collectiveOutput") + _altHoldCollOut);
private _induced_cur = ((_induced_val - _induced_max) / _vel_vbe) * _velXY + _induced_val;

private _power_val   = _profile_cur + _induced_cur;
if (_power_val < 0.0) then {
    _power_val = 0.0;
};
private _power_req   = _power_val * 2133.0;
private _torque_req  = (_power_req / 0.001) / 0.105 / 21109;
private _rtrTorque   = _torque_req * _rtrGearRatio;
_rtrTorque           = linearConversion [0.0, 1.0, _inputRPM / _rtrRPMTrimVal, 0.0, _rtrTorque, true];
/*
hintSilent format ["_profile_cur = % 1
                    \n_induced_val = %2
                    \n_induced_cur = %3
                    \n_power_val = %4
                    \n_power_req = %5
                    \n_torque_req = %6
                    \n_torque_req = %7 pct"
                    ,_profile_cur
                    ,_induced_val
                    ,_induced_cur
                    ,_power_val
                    ,_power_req
                    ,_torque_req
                    ,(_torque_req / 481.109) * 100 toFixed 1];
*/
_heli setVariable ["fza_sfmplus_reqEngTorque", _torque_req];

private _axisX = [1.0, 0.0, 0.0];
private _axisY = [0.0, 1.0, 0.0];
private _axisZ = [0.0, 0.0, 1.0];

//Ground Effect
private _heightAGL    = _rtrHeightAGL  + (ASLToAGL getPosASL _heli # 2);
private _rtrDiam      = _bladeRadius * 2;

private _rtrGndEffScalar = ([_rtrGndEffTable, _altitude] call fza_fnc_linearInterp) select 1;
private _gndEffScalar = (1 - (_heightAGL / _rtrDiam)) * _rtrGndEffScalar;
_gndEffScalar         = [_gndEffScalar, 0.0, 1.0] call BIS_fnc_clamp;
private _gndEffThrust = _rtrThrust * _gndEffScalar;

private _eng1TQ   = _heli getVariable "fza_sfmplus_engPctTQ" select 0;
private _eng2TQ   = _heli getVariable "fza_sfmplus_engPctTQ" select 1;
private _engPctTQ = _eng1TQ max _eng2TQ;

private _cruiseTqTable = 
[
 [ 0.00, _heli getVariable "fza_sfmplus_hvrTQ_OGE"]
,[ 5.14, 0.90]
,[10.29, 0.82]
,[20.58, 0.62]
,[27.78, 0.53]
,[36.01, 0.49]
,[38.07, 0.49]
,[46.30, 0.52]
,[51.44, 0.56]
,[56.59, 0.64]
,[61.73, 0.72]
,[66.88, 0.85]
,[69.96, 0.94]
,[72.02, 1.01]
,[77.17, 1.18]
];
private _cruiseTq   = [_cruiseTqTable, _velXY] call fza_fnc_linearInterp select 1;
private _tqChange   = _engPctTq - _cruiseTq;
_tqChange           = [_tqChange, 0.0, 0.8] call BIS_fnc_clamp;
private _tqRoCTable =
[
 [0.0, 0.00]
,[0.1, 0.11]
,[0.2, 0.22]
,[0.3, 0.32]
,[0.4, 0.43]
,[0.5, 0.54]
,[0.6, 0.65]
,[0.7, 0.75]
,[0.8, 0.86]
];
private _RoCScalar     = [_tqRoCTable, _tqChange] call fza_fnc_linearInterp select 1;
//systemChat format ["_tqChange = %1 -- RoC = %2", _tqChange, (_heli getVariable "fza_sfmplus_velClimb") toFixed 0];
private _climbThrust   = _rtrThrust * _RoCScalar;
private _tipLossScalar = [_rtrTipLossTable, _heli getVariable "fza_sfmplus_GWT"] call fza_fnc_linearInterp select 1;
//systemChat format ["_tipLossScalar = %1", _tipLossScalar];
private _totThrust     = ((_rtrThrust + _gndEffThrust) * _tipLossScalar) + _climbThrust;
[_heli, "fza_sfmplus_rtrThrust", 0, _totThrust, true] call fza_fnc_setArrayVariable;
private _thrustZ       = _axisZ vectorMultiply (_totThrust * _deltaTime);

private _inducedVelocity = sqrt(_totThrust / (2 * _dryAirDensity * _rtrArea));
if ([_inducedVelocity] call fza_sfmplus_fnc_isNAN || [_inducedVelocity] call fza_sfmplus_fnc_isINF) then { _inducedVelocity = 0.0; };
_heli setVariable ["fza_sfmplus_vrsVelocityMin", _inducedVelocity * 0.23];
_heli setVariable ["fza_sfmplus_vrsVelocityMax", _inducedVelocity * 1.25];

//systemChat format ["_rtrThrust = %1 -- _gndEffThrust = %2 -- _totThrust = %3", _rtrThrust toFixed 0, _gndEffThrust toFixed 0, _totThrust toFixed 0];
//systemChat format ["_gndEffScalar = %1 -- _collectiveOuptut = %2", _gndEffScalar toFixed 3, (_heli getVariable "fza_sfmplus_collectiveOutput")];

//Pitch torque
private _cyclicFwdAftTrim    = 0.0;
if (fza_ah64_sfmPlusControlScheme == HOTAS) then {
    _cyclicFwdAftTrim = _heli getVariable "fza_ah64_forceTrimPosPitch";
};

private _pitchTorqueScalar = linearConversion [-1.0, 1.0, (_heli getVariable "fza_sfmplus_cyclicFwdAft"), _aftPitchTorqueScalar, _fwdPitchTorqueScalar, true];
//systemChat format ["_pitchTorqueScalar = %1", _pitchTorqueScalar];
private _torqueX           = ((_rtrThrust * ((_heli getVariable "fza_sfmplus_cyclicFwdAft") + _cyclicFwdAftTrim + _attHoldCycPitchOut)) * _pitchTorqueScalar) * _deltaTime;
//Roll torque
private _cyclicLeftRightTrim = 0.0;
if (fza_ah64_sfmPlusControlScheme == HOTAS) then {
    _cyclicLeftRightTrim = _heli getVariable "fza_ah64_forceTrimPosRoll";
};
private _torqueY             = ((_rtrThrust * ((_heli getVariable "fza_sfmplus_cyclicLeftRight") + _cyclicLeftRightTrim + _attHoldCycRollOut)) * _rollTorqueScalar) * _deltaTime;
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
        if (fza_ah64_sfmPlusControlScheme == HOTAS) then {
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
    if (_velXY < 12.35 && _inputRPM > EPSILON) then {  //must be less than ETL
        //2000 fpm to 2933fpm
        if (_velZ < -(_vrsVelMax * 0.40) && _velZ > -(_vrsVelMax * 0.60)) then {
            enableCamShake true;
            setCamShakeParams [0.0, 0.5, 0.0, 0.0, true];
            addCamShake       [2.5, 1, 5];
            enableCamShake false;

            setCustomSoundController[_heli, "CustomSoundController3", 6.4];
            setCustomSoundController[_heli, "CustomSoundController4", 1.8];

            if (fza_ah64_sfmPlusVrsWarning) then {
                hintSilent format ["Warning! Entering VRS Conditions!"];
            };
        };
        //2933 fpm to 3867 
        if (_velZ <= -(_vrsVelMax * 0.60) && _velZ > -(_vrsVelMax * 0.80)) then {
            enableCamShake true;
            setCamShakeParams [0.0, 0.5, 0.0, 0.5, true];
            addCamShake       [3, 1, 5.5];
            enableCamShake false;

            setCustomSoundController[_heli, "CustomSoundController3", 6.4];
            setCustomSoundController[_heli, "CustomSoundController4", 1.8];

            if (fza_ah64_sfmPlusVrsWarning) then {
                hintSilent format ["Warning! VRS Developing!"];
            };
        };
        //3867fpm to 4800 fpm
        if (_velZ <= -(_vrsVelMax * 0.80) && _velZ > -_vrsVelMax) then {
            enableCamShake true;
            setCamShakeParams [0.0, 0.75, 0.0, 0.75, true];
            addCamShake       [3.5, 1, 6.0];
            enableCamShake false;

            setCustomSoundController[_heli, "CustomSoundController3", 6.4];
            setCustomSoundController[_heli, "CustomSoundController4", 1.8];
            if (fza_ah64_sfmPlusVrsWarning) then {
                hintSilent format ["Warning! Fully Developed VRS Imminent!"];
            };
        };
        //> 4800fpm
        if (_velZ < -_vrsVelMax) then {
            enableCamShake true;
            setCamShakeParams [0.0, 1.0, 0.0, 2.0, true];
            addCamShake       [4.0, 1, 6.5];
            enableCamShake false;

            setCustomSoundController[_heli, "CustomSoundController3", 6.4];
            setCustomSoundController[_heli, "CustomSoundController4", 1.8];

            if (fza_ah64_sfmPlusVrsWarning) then {
                hintSilent format ["Warning! VRS Fully Developed!"];
            };
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
                    \nPitch = %11", _rtrOmega, _bladeTipVel, _rtrPowerReq * 0.001, _reqEngTorque, (_reqEngTorque / 2) / 481, (_reqEngTorque / 2) / 481, _velZ, _inducedVelocityScalar, _gndEffScalar, (_heli getVariable "fza_sfmplus_collectiveOutput"), _heli call BIS_fnc_getPitchBank select 0];
                    */