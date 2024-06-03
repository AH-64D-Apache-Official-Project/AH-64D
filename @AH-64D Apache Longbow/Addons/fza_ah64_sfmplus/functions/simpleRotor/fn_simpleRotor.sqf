params ["_heli", "_rtrNum", "_deltaTime"];
#include "\fza_ah64_sfmplus\headers\core.hpp"

private _cfg               = configOf _heli;
private _sfmPlusConfig     = _cfg >> "Fza_SfmPlus";

private _numBlades         = getArray  (_sfmPlusConfig >> "rotorNumBlades")          select _rtrNum;
private _designRPM         = getArray  (_sfmPlusConfig >> "rotorDesignRPM")          select _rtrNum;
private _rpmTrimVal        = getNumber (_sfmPlusConfig >> "rotorRPMTrimVal");
private _direction         = getArray  (_sfmPlusConfig >> "rotorDirection")          select _rtrNum;
private _type              = getArray  (_sfmPlusConfig >> "rotorType")               select _rtrNum;
private _hitPoint          = getArray  (_sfmPlusConfig >> "rotorHitPoints")          select _rtrNum;

private _pos               = getArray  (_sfmPlusConfig >> "rotorPos")                select _rtrNum;
private _rot               = getArray  (_sfmPlusConfig >> "rotorRot")                select _rtrNum;
private _gearRatio         = getArray  (_sfmPlusConfig >> "rotorGearRatio")          select _rtrNum;
private _rtrHeightAGL      = getArray  (_sfmPlusConfig >> "rotorHeightAGL")          select _rtrNum;
private _velocityMod       = getNumber (_sfmPlusConfig >> "rotorVelModifier");
private _rtrGndEffMod      = getArray  (_sfmPlusConfig >> "rotorGndEffMod")          select _rtrNum;
private _baseThrust        = getNumber (_sfmPlusConfig >> "rotorBaseThrust");
private _baseThrustScalar  = getArray  (_sfmPlusConfig >> "rotorBaseThrustScalar")   select _rtrNum;
private _thrustScalar_min  = getArray  (_sfmPlusConfig >> "rotorThrustScalar_min")   select _rtrNum;
private _thrustScalar_max  = getArray  (_sfmPlusConfig >> "rotorThrustScalar_max")   select _rtrNum;

private _bladeRadius       = getArray  (_sfmPlusConfig >> "rotorBladeRadius")        select _rtrNum;
private _bladeChord        = getArray  (_sfmPlusConfig >> "rotorBladeChord")         select _rtrNum;
private _bladePitch_min    = getArray  (_sfmPlusConfig >> "collectivePitch")         select _rtrNum select 0;
private _bladePitch_max    = getArray  (_sfmPlusConfig >> "collectivePitch")         select _rtrNum select 1;

private _profilePwr_min    = getArray  (_sfmPlusConfig >> "bladeProfilePower_min")   select _rtrNum;
private _profilePwr_max    = getArray  (_sfmPlusConfig >> "bladeProfilePower_max")   select _rtrNum;

private _inducedPwr_min    = getArray  (_sfmPlusConfig >> "bladeInducedPower_min")   select _rtrNum;
private _inducedPwr_max    = getArray  (_sfmPlusConfig >> "bladeInducedPower_max")   select _rtrNum;

private _pitchTorqueScalar = getNumber (_sfmPlusConfig >> "cyclicPitchTorqueScalar");//PITCH_SCALAR;//0.05;//2.25//1.75;//PITCH_SCALAR;
private _rollTorqueScalar  = getNumber (_sfmPlusConfig >> "cyclicRollTorqueScalar");//ROLL_SCALAR;//0.05;//0.75;//ROLL_SCALAR;
private _yawTorqueScalar   = getArray  (_sfmPlusConfig >> "rotorYawTorqueScalar")    select _rtrNum;//1.0; //0.95, 1.10

private _axisX             = [[1.0, 0.0, 0.0], _rot] call fza_sfmplus_fnc_rotateVector;
private _axisY             = [[0.0, 1.0, 0.0], _rot] call fza_sfmplus_fnc_rotateVector;
private _axisZ             = [[0.0, 0.0, 1.0], _rot] call fza_sfmplus_fnc_rotateVector;

private _torqueDir = 1.0;
if (_direction == CCW) then {
    _torqueDir = -1.0;
};
//Get velocities
([_heli, false] call fza_sfmplus_fnc_getVelocities)
    params ["_gndSpeed", "_vel2D", "_vel3D", "_vertVel", "_velModelSpace"];
private _heliVel            = [_velModelSpace, _rot] call fza_sfmplus_fnc_rotateVector;
//Get Input
([_heli, _sfmPlusConfig, _rtrNum, _deltaTime, _vel2D] call fza_sfmplus_fnc_simpleRotorControl)
    params ["_AIC", "_BIC", "_theta0", "_mastPitchRoll"];
//Get rotor RPM
(_heli getVariable "fza_sfmplus_engPctNP")
    params ["_eng1PctNP", "_eng2PctNp"];
private _inputRPM       = _eng1PctNP max _eng2PctNp;
//Thrust produced as a function collective input
private _altitude       = _heli getVariable "fza_sfmplus_PA";
_rtrThrustScalar_min    = [_thrustScalar_min, _altitude] call fza_fnc_linearInterp select 1;
_rtrThrustScalar_max    = [_thrustScalar_max, _altitude] call fza_fnc_linearInterp select 1;

//
private _bladePitchInducedThrustScalar = 0.0;
if (_bladePitch_min < 0.0) then {
    if (_theta0 >= 0.0) then {
        _bladePitchInducedThrustScalar = _rtrThrustScalar_max + ((1 - _rtrThrustScalar_max) / _bladePitch_max) * _theta0;
    } else {
        _bladePitchInducedThrustScalar = _rtrThrustScalar_min + ((1 - _rtrThrustScalar_min) / _bladePitch_min) * _theta0;
    };
} else {
    _bladePitchInducedThrustScalar     = _rtrThrustScalar_min + ((1 - _rtrThrustScalar_min) / _bladePitch_max) * _theta0;
};

//Rotor induced thrust as a function of RPM
private _rtrRPMInducedThrustScalar = 0.0;
if (_theta0 >= 0.0) then {
    _rtrRPMInducedThrustScalar = _rtrThrustScalar_max * (_inputRPM / _rpmTrimVal);
} else {
    _rtrRPMInducedThrustScalar = _rtrThrustScalar_min * (_inputRPM / _rpmTrimVal);
};
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
private _rtrThrustScalar = _bladePitchInducedThrustScalar * _rtrRPMInducedThrustScalar * _airDensityThrustScalar * _airspeedVelocityScalar * _inducedVelocityScalar;

systemChat format ["Rtr %1 Thrust Scalar = %2 -- Pedal = %3", _rtrNum, _rtrThrustScalar toFixed 3];
//systemChat format ["Heli Vel [%1, %2, %3]", (_heliVel select 0) toFixed 2, (_heliVel select 1) toFixed 2, (_heliVel select 2) toFixed 2];

private _rtrThrust       = (_baseThrust * _baseThrustScalar) * _rtrThrustScalar;
//Ground Effect
private _heightAGL       = _rtrHeightAGL  + (ASLToAGL getPosASL _heli # 2);
private _rtrDiam         = _bladeRadius * 2;
private _gndEffScalar    = (1 - (_heightAGL / _rtrDiam)) * _rtrGndEffMod;
_gndEffScalar            = [_gndEffScalar, 0.0, 1.0] call BIS_fnc_clamp;
private _gndEffThrust    = _rtrThrust * _gndEffScalar;
private _totThrust       = _rtrThrust + _gndEffThrust;

private _thrustX         = _totThrust * (sin _AIC);
private _thrustY         = _totThrust * (sin _BIC);
private _thrustZ         = _totThrust;

private _force           = [_thrustX, _thrustY, _thrustZ];
_force                   = [_force, _rot] call fza_sfmplus_fnc_rotateVector;
systemChat format ["Rtr %1 Force [%2, %3, %4]", _rtrNum, (_force select 0) toFixed 0, (_force select 1) toFixed 0, (_force select 2) toFixed 0];
//Calculate the required rotor power
private _profile_cur = _profilePwr_min + ((_profilePwr_max - _profilePwr_min) / VEL_VNE) * _velXY;

private _induced_val = _inducedPwr_min * fza_sfmplus_collectiveOutput;// + _altHoldCollOut);
private _induced_cur = ((_induced_val - _inducedPwr_max) / VEL_VBE) * _velXY + _induced_val;

private _power_val   = (_profile_cur + _induced_cur) * (_inputRPM / _rpmTrimVal);

private _power_req   = _power_val * 2132;
private _torque_req  = (_power_req / 0.001) / 0.105 / 21109;
private _rtrTorque   = _torque_req * _gearRatio;
[_heli, "fza_sfmplus_reqEngTorque", _rtrNum, _torque_req, true] call fza_fnc_setArrayVariable;

//Pitch torque
private _torqueX     = (_rtrThrust * _BIC) * _pitchTorqueScalar;
//Roll torque
private _torqueY     = (_rtrThrust * _AIC) * _rollTorqueScalar;
//Yaw torque
private _torqueZ     =  _rtrTorque  * _torqueDir;
if (!fza_ah64_sfmplusEnableTorqueSim && _type == MAIN) then {
    _torqueZ = 0.0;
};

private _deltaPos = _pos vectorDiff (getCenterOfMass _heli);
private _moment   = [_torqueX, _torqueY, _torqueZ] vectorAdd (_force vectorCrossProduct _deltaPos);
_moment           = _moment vectorMultiply [-1.0, -1.0, -1.0];
systemChat format ["Rtr %1 Moment [%2, %3, %4]", _rtrNum, (_moment select 0) toFixed 0, (_moment select 1) toFixed 0, (_moment select 2) toFixed 0];
//Rotor forces
private _rtrDamage = _heli getHitPointDamage _hitPoint;
if (currentPilot _heli == player) then {
    if (_rtrDamage < 0.99) then {
        //Forces
        _heli addForce  [_heli vectorModelToWorld (_force  vectorMultiply _deltaTime), getCenterOfMass _heli];
        //Moments
        _heli addTorque (_heli vectorModelToWorld (_moment vectorMultiply _deltaTime));
    };
};

#ifdef __A3_DEBUG__
[_heli, _pos, _pos vectorAdd _axisX, "red"]   call fza_sfmplus_fnc_debugDrawLine;
[_heli, _pos, _pos vectorAdd _axisY, "green"] call fza_sfmplus_fnc_debugDrawLine;
[_heli, _pos, _pos vectorAdd _axisZ, "blue"]  call fza_sfmplus_fnc_debugDrawLine;
[_heli, 24, _pos, _bladeRadius, _rot, "white", 0]   call fza_sfmplus_fnc_debugDrawCircle;
#endif