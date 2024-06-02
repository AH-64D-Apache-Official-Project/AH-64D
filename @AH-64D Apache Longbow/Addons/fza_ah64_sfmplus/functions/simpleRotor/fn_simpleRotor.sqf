params ["_heli", "_rtrNum", "_deltaTime"];
#include "\fza_ah64_sfmplus\headers\core.hpp"

private _cfg              = configOf _heli;
private _sfmPlusConfig    = _cfg >> "Fza_SfmPlus";

private _numBlades        = getArray  (_sfmPlusConfig >> "rotorNumBlades")         select _rtrNum;
private _designRPM        = getArray  (_sfmPlusConfig >> "rotorDesignRPM")         select _rtrNum;
private _rpmTrimVal       = getNumber (_sfmPlusConfig >> "rotorRPMTrimVal");
private _direction        = getArray  (_sfmPlusConfig >> "rotorDirection")         select _rtrNum;
private _type             = getArray  (_sfmPlusConfig >> "rotorType")              select _rtrNum;
private _hitPoint         = getArray  (_sfmPlusConfig >> "rotorHitPoints")         select _rtrNum;

private _pos              = getArray  (_sfmPlusConfig >> "rotorPos")               select _rtrNum;
private _rot              = getArray  (_sfmPlusConfig >> "rotorRot")               select _rtrNum;
private _gearRatio        = getArray  (_sfmPlusConfig >> "rotorGearRatio")         select _rtrNum;
private _rtrHeightAGL     = getArray  (_sfmPlusConfig >> "rotorHeightAGL")         select _rtrNum;
private _velocityMod      = getNumber (_sfmPlusConfig >> "rotorVelModifier");
private _rtrGndEffMod     = getArray  (_sfmPlusConfig >> "rotorGndEffMod")         select _rtrNum;
private _baseThrust       = getNumber (_sfmPlusConfig >> "rotorBaseThrust");
private _thrustScalar_min = getArray  (_sfmPlusConfig >> "rotorThrustScalar_min")   select _rtrNum;
private _thrustScalar_max = getArray  (_sfmPlusConfig >> "rotorThrustScalar_max")   select _rtrNum;

private _bladeRadius      = getArray  (_sfmPlusConfig >> "rotorBladeRadius")       select _rtrNum;
private _bladeChord       = getArray  (_sfmPlusConfig >> "rotorBladeChord")        select _rtrNum;
private _bladePitch_min   = getArray  (_sfmPlusConfig >> "collectivePitch")        select _rtrNum select 0;
private _bladePitch_max   = getArray  (_sfmPlusConfig >> "collectivePitch")        select _rtrNum select 1;

private _profilePwr_min   = getArray  (_sfmPlusConfig >> "bladeProfilePower_min")   select _rtrNum;
private _profilePwr_max   = getArray  (_sfmPlusConfig >> "bladeProfilePower_max")   select _rtrNum;

private _inducedPwr_min   = getArray  (_sfmPlusConfig >> "bladeInducedPower_min")   select _rtrNum;
private _inducedPwr_max   = getArray  (_sfmPlusConfig >> "bladeInducedPower_max")   select _rtrNum;

private _axisX            = [[1.0, 0.0, 0.0], _rot] call fza_sfmplus_fnc_rotateVector;
private _axisY            = [[0.0, 1.0, 0.0], _rot] call fza_sfmplus_fnc_rotateVector;
private _axisZ            = [[0.0, 0.0, 1.0], _rot] call fza_sfmplus_fnc_rotateVector;

//Get velocities
([_heli, false] call fza_sfmplus_fnc_getVelocities)
    params ["_gndSpeed", "_vel2D", "_vel3D", "_vertVel", "_velModelSpace"];
private _heliVel            = [_velModelSpace, _rot] call fza_sfmplus_fnc_rotateVector;
//Get Input
([_sfmPlusConfig, _rtrNum, _deltaTime, _vel2D] call fza_sfmplus_fnc_rotorControl)
    params ["_AIC", "_BIC", "_theta0", "_mastPitchRoll"];
//Get rotor RPM
(_heli getVariable "fza_sfmplus_engPctNP")
    params ["_eng1PctNP", "_eng2PctNp"];
private _inputRPM       = _eng1PctNP max _eng2PctNp;
//Thrust produced as a function collective input
private _altitude       = _heli getVariable "fza_sfmplus_PA";
_rtrThrustScalar_min    = [_thrustScalar_min, _altitude] call fza_fnc_linearInterp select 1;
_rtrThrustScalar_max    = [_thrustScalar_max, _altitude] call fza_fnc_linearInterp select 1;


_bladePitchInducedThrustScalar = 

if (_type == MAIN) then {
    _bladePitchInducedThrustScalar = _rtrThrustScalar_min + ((1 - _rtrThrustScalar_min) / _bladePitch_max)  * _theta0;
};

if (_type == TAIL) then {
    private _rtrThrustScalar_med   = (_rtrThrustScalar_min + _rtrThrustScalar_max) / 2;
    _bladePitchInducedThrustScalar = _rtrThrustScalar_med  + _theta0 * ((_rtrThrustScalar_max - _rtrThrustScalar_min) / (_bladePitch_max - _bladePitch_min));
};
//Rotor induced thrust as a function of RPM
private _rtrRPMInducedThrustScalar = (_inputRPM / _rpmTrimVal) * _rtrThrustScalar_max;
//Thrust scalar as a result of altitude
private _dryAirDensity             = _heli getVariable "fza_sfmplus_rho";
private _airDensityThrustScalar    = _dryAirDensity / ISA_STD_DAY_AIR_DENSITY;
//Additional thrust gained from increasing forward airspeed
private _velXY                     = vectorMagnitude [_heliVel # 0, _heliVel # 1];
private _airspeedVelocityScalar    = (1 + (_velXY / VEL_VBE)) ^ (_velocityMod);
//Induced flow handler
private _velZ                      = _heliVel # 2;
private _inducedVelocityScalar     = 1.0;
if (_velZ < -VEL_VRS && _velXY < VEL_ETL) then { 
    _inducedVelocityScalar = 0.0;
} else {
    if (_velXY < 74.59) then {
        _inducedVelocityScalar = 1 - (_velZ / 7.62);
    } else {
        _inducedVelocityScalar = 1 - (_velZ / VEL_VRS);
    };
};
//Finally, multiply all the scalars above to arrive at the final thrust scalar
systemChat format ["Blade Pitch Induced Thrust Scalar = %1
                    \nRotor RPM Induced Thrust Scalar = %2
                    \nAir Density Scalar = %3
                    \nVelocity Scalar = %4
                    \nInduced Velocity Scalar = %5"
                    , _bladePitchInducedThrustScalar
                    , _rtrRPMInducedThrustScalar
                    , _airDensityThrustScalar
                    , _airspeedVelocityScalar
                    , _inducedVelocityScalar];

private _rtrThrustScalar = _bladePitchInducedThrustScalar * _rtrRPMInducedThrustScalar * _airDensityThrustScalar * _airspeedVelocityScalar * _inducedVelocityScalar;
private _rtrThrust       = _baseThrust * _rtrThrustScalar;
//Ground Effect
private _heightAGL       = _rtrHeightAGL  + (ASLToAGL getPosASL _heli # 2);
private _rtrDiam         = _bladeRadius * 2;
private _gndEffScalar    = (1 - (_heightAGL / _rtrDiam)) * _rtrGndEffMod;
_gndEffScalar            = [_gndEffScalar, 0.0, 1.0] call BIS_fnc_clamp;
private _gndEffThrust    = _rtrThrust * _gndEffScalar;
private _totThrust       = _rtrThrust + _gndEffThrust;
[_heli, "fza_sfmplus_rtrThrust", 0, _totThrust, true] call fza_fnc_setArrayVariable;
private _thrustZ         = _axisZ vectorMultiply (_totThrust * _deltaTime);
/*
//Pitch torque
private _cyclicFwdAftTrim    = _heli getVariable "fza_ah64_forceTrimPosPitch";
private _torqueX             = ((_rtrThrust * (fza_sfmplus_cyclicFwdAft + _cyclicFwdAftTrim + _attHoldCycPitchOut)) * _pitchTorqueScalar) * _deltaTime;
//Roll torque
private _cyclicLeftRightTrim = _heli getVariable "fza_ah64_forceTrimPosRoll";
private _torqueY             = ((_rtrThrust * (fza_sfmplus_cyclicLeftRight + _cyclicLeftRightTrim + _attHoldCycRollOut)) * _rollTorqueScalar) * _deltaTime;
//Main rotor yaw torque
private _torqueZ             = (_rtrTorque  * _rtrTorqueScalar) * _deltaTime;
*/
//Rotor forces
private _rtrDamage       = _heli getHitPointDamage _hitPoint;
if (currentPilot _heli == player) then {
    if (_rtrDamage < 0.99) then {
        //Main rotor thrust
        _heli addForce  [_heli vectorModelToWorld _thrustZ, _pos];
        
        private _torque = [0.0, 0.0, 0.0];
        //Main rotor torque
        //if (fza_ah64_sfmplusEnableTorqueSim) then {
        //    _torque = [_torqueX, _torqueY, _torqueZ];
        //} else {
        //    _torque = [_torqueX, _torqueY, 0.0];
        //};
        //_heli addTorque (_heli vectorModelToWorld _torque);
    };
};

#ifdef __A3_DEBUG__
[_heli, _pos, _pos vectorAdd _axisX, "red"]   call fza_sfmplus_fnc_debugDrawLine;
[_heli, _pos, _pos vectorAdd _axisY, "green"] call fza_sfmplus_fnc_debugDrawLine;
[_heli, _pos, _pos vectorAdd _axisZ, "blue"]  call fza_sfmplus_fnc_debugDrawLine;
[_heli, 24, _pos, _bladeRadius, _rot, "white", 0]   call fza_sfmplus_fnc_debugDrawCircle;
#endif