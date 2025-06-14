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
#include "\fza_ah64_sfmplus\headers\core.hpp"

params ["_heli"];

if (!local _heli) exitWith {};

private _deltaTime              = fza_ah64_fixedTimeStep;

private _altitude               = _heli getVariable "fza_sfmplus_PA";
private _temperature            = _heli getVariable "fza_sfmplus_FAT";
private _dryAirDensity          = _heli getVariable "fza_sfmplus_RHO";

private _attHoldCycPitchOut     = _heli getVariable "fza_sfmplus_fmcAttHoldCycPitchOut";
private _collToPitchOut         = _heli getVariable "fza_sfmplus_fmcCollectiveToPitch";
private _yawToPitchOut          = _heli getVariable "fza_sfmplus_fmcYawToPitch";
private _sasPitchOut            = _heli getVariable "fza_sfmplus_fmcSasPitchOut";
private _fmcPitchOut            = _attHoldCycPitchOut + _sasPitchOut + _collToPitchOut + _yawToPitchOut;

private _attHoldCycRollOut      = _heli getVariable "fza_sfmplus_fmcAttHoldCycRollOut";
private _sasRollOut             = _heli getVariable "fza_sfmplus_fmcSasRollOut";
private _collToRollOut          = _heli getVariable "fza_sfmplus_fmcCollectiveToRoll";
private _yawToRollOut           = _heli getVariable "fza_sfmplus_fmcYawToRoll";
private _fmcRollOut             = _attHoldCycRollOut + _sasRollOut + _collToRollOut + _yawToRollOut;

private _altHoldCollOut         = _heli getVariable "fza_sfmplus_fmcAltHoldCollOut";
private _isAutorotating         = _heli getVariable "fza_sfmplus_isAutorotating";

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

private _velocityThrustExponent = 0.386;
private _vrsScalarExponent      = 0.3;
private _rtrTorqueScalar        = 1.0;

private _pitchTorqueScalar      = 2.50;
private _rollTorqueScalar       = 0.75;

private _baseThrust             = 102306;  //N - max gross weight (kg) * gravity (9.806 m/s)

//Thrust produced 
private _bladePitch_cur                = _bladePitch_min + (_bladePitch_max - _bladePitch_min) * ((_heli getVariable "fza_sfmplus_collectiveOutput") + _altHoldCollOut);
private _rtrThrustScalar_min           = [_rtrThrustScalarTable_min, _altitude] call fza_fnc_linearInterp select 1;
private _bladePitchInducedThrustScalar = _rtrThrustScalar_min + ((1 - _rtrThrustScalar_min) / _bladePitch_max)  * _bladePitch_cur;
(_heli getVariable "fza_sfmplus_engPctNP")
    params ["_eng1PctNP", "_eng2PctNp"];
private _inputRPM                      = _eng1PctNP max _eng2PctNp;

//Rotor induced thrust as a function of RPM
private _rtrThrustScalar_max       = [_rtrThrustScalarTable_max, _altitude] call fza_fnc_linearInterp select 1;
private _rtrRPMInducedThrustScalar = (_inputRPM / _rtrRPMTrimVal) * _rtrThrustScalar_max;

//Thrust scalar as a result of altitude
private _airDensityThrustScalar    = _dryAirDensity / ISA_STD_DAY_AIR_DENSITY;

//Additional thrust gained from increasing forward airspeed
private _velX                      = _heli getVariable "fza_sfmplus_velModelSpace" select 0;
private _velY                      = _heli getVariable "fza_sfmplus_velModelSpace" select 1;
private _velWindY                  = _heli getVariable "fza_sfmplus_velWindModelSpace" select 1;
private _velWindX                  = _heli getVariable "fza_sfmplus_velWindModelSpace" select 0;
if (_velWindY < 0.0) then {
    _velWindY = 0.0;
};
private _velXY                     = vectorMagnitude [_velX + _velWindX, _velY + _velWindY];
//private _velocityThrustExponent    = [_velocityThrustExpTable, _velXY] call fza_fnc_linearInterp select 1;
//systemChat format ["_velocityThrustExponent = %1 -- _collectiveOutput = %2", _velocityThrustExponent toFixed 3, (_heli getVariable "fza_sfmplus_collectiveOutput") toFixed 3];
private _airspeedVelocityScalar    = (1 + (_velXY / VEL_VBE)) ^ (_velocityThrustExponent);

//Induced flow handler
private _velZ                      = _heli getVariable "fza_sfmplus_velModelSpace" select 2;
private _inducedVelocityScalar     = 1.0;
private _vrsVelMin                 = _heli getVariable "fza_sfmplus_vrsVelocityMin";
private _vrsVelMax                 = _heli getVariable "fza_sfmplus_vrsVelocityMax";
private _vrsVel                    = linearConversion[0.0, VEL_ETL, _velXY, _vrsVelMax, VEL_VRS, true];
if (_velZ < -_vrsVelMin && _velXY < VEL_ETL) then {
    private _vrsScalar = if(_velZ == 0.0) then { 0.0; } else { abs(_vrsVelMin / _velZ)^_vrsScalarExponent; };
    _inducedVelocityScalar   = if(_vrsVelMax == 0.0) then { 1.0; } else { (1 - (_velZ / _vrsVelMax)) * _vrsScalar; };
} else {
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

private _velXNoWind  = _heli getVariable "fza_sfmplus_velModelSpaceNoWind" select 0;
private _velYNoWind  = _heli getVariable "fza_sfmplus_velModelSpaceNoWind" select 1;
private _velXYNoWind = vectorMagnitude [_velXNoWind, _velYNoWind];

private _profile_cur = _profile_min + ((_profile_max - _profile_min) / _vel_vne) * _velXYNoWind;

private _induced_val = _induced_min * ((_heli getVariable "fza_sfmplus_collectiveOutput") + _altHoldCollOut);
private _induced_cur = ((_induced_val - _induced_max) / _vel_vbe) * _velXYNoWind + _induced_val;

private _power_val   = _profile_cur + _induced_cur;
if (_power_val < 0.0) then {
    _power_val = 0.0;
};
private _power_req   = _power_val * 2133.0;
private _torque_req  = (_power_req / 0.001) / 0.105 / 21109;
/*
private _pedalLeftRight     = _heli getVariable "fza_sfmplus_pedalLeftRight";
private _pedalLeftRightTrim = _heli getVariable "fza_ah64_forceTrimPosPedal";
private _hdgHoldPedalYawOut = _heli getVariable "fza_sfmplus_hdgHoldPedalYawOut";
private _tailRtrScalar      = [
                               [-1.00, 1.20]
                              ,[-0.80, 1.05] 
                              ,[-0.05, 1.00]
                              ,[ 0.00, 1.00]
                              ,[ 0.50, 1.00]
                              ,[ 0.80, 0.95]
                              ,[ 1.00, 0.80]
                              ];
private _pedalPosition = _pedalLeftRight + _pedalLeftRightTrim + _hdgHoldPedalYawOut;
private _tailRtrDamage = _heli getHitPointDamage "hitvrotor";
private _pedalTqScalar = 1.0;
if (_tailRtrDamage < 0.85) then {
    _pedalTqScalar = [_tailRtrScalar, _pedalPosition] call fza_fnc_linearInterp select 1;
};
_torque_req = _torque_req * _pedalTqScalar;
*/
//systemChat format ["_pedalPosition = %1", _pedalPosition];

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
private _heightAGL     = _rtrHeightAGL  + (ASLToAGL getPosASL _heli # 2);
private _rtrDiam       = _bladeRadius * 2;

private _rtrGndEffScalar = ([_rtrGndEffTable, _altitude] call fza_fnc_linearInterp) select 1;
private _gndEffScalar  = (1 - (_heightAGL / _rtrDiam)) * _rtrGndEffScalar;
_gndEffScalar          = [_gndEffScalar, 0.0, 1.0] call BIS_fnc_clamp;
private _gndEffThrust  = _rtrThrust * _gndEffScalar;

private _eng1TQ        = _heli getVariable "fza_sfmplus_engPctTQ" select 0;
private _eng2TQ        = _heli getVariable "fza_sfmplus_engPctTQ" select 1;
private _engPctTQ      = _eng1TQ max _eng2TQ;
private _isSingleEng   = _heli getVariable "fza_sfmplus_isSingleEng";

private _cruiseTqTable = 
[
 [ 0.00, 0.94]
,[ 2.57, 0.93] 
,[ 5.14, 0.90]
,[ 7.72, 0.87]
,[10.29, 0.82]
,[12.86, 0.78]
,[20.58, 0.62]
,[25.72, 0.54]
,[30.87, 0.50]
,[36.01, 0.49]
,[41.16, 0.50]
,[46.30, 0.52]
,[51.44, 0.56]
,[56.59, 0.64]
,[61.73, 0.72]
,[66.88, 0.85]
,[72.02, 1.01]
,[77.17, 1.18]
];
private _cruiseTq   = [_cruiseTqTable, _velXY] call fza_fnc_linearInterp select 1;
if (_isSingleEng) then {
    _cruiseTq = _cruiseTq * 2.0;
};
private _tqChange   = _engPctTq - _cruiseTq;
_tqChange           = [_tqChange, 0.0, 0.8] call BIS_fnc_clamp;
private _tqRoCTable =
[
 [0.0, 0.000]   //0fpm
,[0.1, 0.078]   //400fpm
,[0.2, 0.151]   //800fpm
,[0.3, 0.224]   //1200fpm
,[0.4, 0.297]   //1600fpm
,[0.5, 0.369]   //2000fpm
,[0.6, 0.457]   //2400fpm
,[0.7, 0.517]   //2800fpm
,[0.8, 0.587]   //3200fpm
];
private _RoCScalar       = [_tqRoCTable, _tqChange] call fza_fnc_linearInterp select 1;
private _climbThrust     = _baseThrust * _RoCScalar;
private _tipLossScalar   = [_rtrTipLossTable, _heli getVariable "fza_sfmplus_GWT"] call fza_fnc_linearInterp select 1;
private _totThrust       = (_rtrThrust + _gndEffThrust + _climbThrust) * _tipLossScalar;
[_heli, "fza_sfmplus_rtrThrust", 0, _totThrust, true] call fza_fnc_setArrayVariable;
private _thrustZ         = _axisZ vectorMultiply (_totThrust * _deltaTime);
private _inducedVelocity = sqrt(_totThrust / (2 * _dryAirDensity * _rtrArea));
if ([_inducedVelocity] call fza_sfmplus_fnc_isNAN || [_inducedVelocity] call fza_sfmplus_fnc_isINF) then { _inducedVelocity = 0.0; };
_heli setVariable ["fza_sfmplus_vrsVelocityMin", _inducedVelocity * 0.23];
_heli setVariable ["fza_sfmplus_vrsVelocityMax", _inducedVelocity * 1.25];
/////////////////////////////////////////////////////////////////////////////////////////////
// Pitch Torque         /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _cyclicFwdAft     = _heli getVariable "fza_sfmplus_cyclicFwdAft";
private _cyclicFwdAftTrim = 0.0;
_cyclicFwdAftTrim         = _heli getVariable "fza_ah64_forceTrimPosPitch";

private _pitchTorque      = linearConversion [0.0, 1.0, _inputRPM / _rtrRPMTrimVal, 0.0, 100000 * _pitchTorqueScalar, true];
private _pitchInput       = ([_cyclicFwdAft, _cyclicFwdAftTrim] call fza_sfmplus_fnc_getInterpInput) + _fmcPitchOut;
_pitchInput               = [_pitchInput, -1.0, 1.0] call BIS_fnc_clamp;
private _torqueX          = _pitchTorque * _pitchInput * _deltaTime; 
/////////////////////////////////////////////////////////////////////////////////////////////
// Roll Torque          /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _cyclicLeftRight     = _heli getVariable "fza_sfmplus_cyclicLeftRight";
private _cyclicLeftRightTrim = 0.0;
_cyclicLeftRightTrim         = _heli getVariable "fza_ah64_forceTrimPosRoll";

private _rollInput           = ([_cyclicLeftRight, _cyclicLeftRightTrim] call fza_sfmplus_fnc_getInterpInput) + _fmcRollOut;
_rollInput                   = [_rollInput, -1.0, 1.0] call BIS_fnc_clamp;
private _rollTorque          = linearConversion [0.0, 1.0, _inputRPM / _rtrRPMTrimVal, 0.0, 100000 * _rollTorqueScalar, true];
private _torqueY             = _rollTorque * _rollInput * _deltaTime; 
//systemChat format ["_pitchInput = %1 -- _rollInput = %2", _pitchInput toFixed 3, _rollInput toFixed 3];
/////////////////////////////////////////////////////////////////////////////////////////////
// Yaw Torque           /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _torqueZ         = _rtrTorque * _rtrTorqueScalar * _deltaTime;
//systemChat format ["main rotor _torqueZ = %1", _torqueZ toFixed 0];
/////////////////////////////////////////////////////////////////////////////////////////////
// Rotor Forces         /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
if (currentPilot _heli == player) then {
    private _mainRtrDamage = _heli getHitPointDamage "HitHRotor";

    if (_mainRtrDamage < 0.99) then {
        //Main rotor thrust
        _heli addForce  [_heli vectorModelToWorld _thrustZ, _rtrPos];
        //Main rotor torque
        private _torque = [0.0, 0.0, 0.0];
        _torque = [_torqueX, _torqueY, _torqueZ];
        _heli addTorque (_heli vectorModelToWorld _torque);
    };
};
/////////////////////////////////////////////////////////////////////////////////////////////
// Rotor Effects        /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
if (cameraView == "INTERNAL") then {
    //Camera shake effect for ETL (16 to 24 knots)
    if (_velXYNoWind > 8.23 && _velXYNoWind < 12.35) then {
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
    if (_velXYNoWind < 12.35 && _inputRPM > EPSILON && !([_heli] call fza_sfmplus_fnc_onGround) && !_isAutorotating) then {  //must be less than ETL
        //2000 fpm to 2933fpm
        if (_velZ < -(_vrsVelMax * 0.40) && _velZ > -(_vrsVelMax * 0.60)) then {
            enableCamShake true;
            setCamShakeParams [0.0, 0.5, 0.0, 0.0, true];
            addCamShake       [2.5, 1, 5];
            enableCamShake false;

            setCustomSoundController[_heli, "CustomSoundController3", 6.4];
            setCustomSoundController[_heli, "CustomSoundController4", 1.8];

            if (fza_ah64_sfmPlusVrsWarning) then {
                hintSilent parseText format ["<t size='1.25' font='Zeppelin33' color='#99ffffff'>Entering VRS Condition!</t>"];
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
                hintSilent parseText format ["<t size='1.25' font='Zeppelin33' color='#FFFF00'>Caution! VRS Developing!</t>"];
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
                hintSilent parseText format ["<t size='1.25' font='Zeppelin33' color='#ff0000'>Warning! Fully Developed VRS Imminent!</t>"];
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

                hintSilent parseText format ["<t size='1.25' font='Zeppelin33' color='#ff0000'>Danger! You are in VRS!</t>"];
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