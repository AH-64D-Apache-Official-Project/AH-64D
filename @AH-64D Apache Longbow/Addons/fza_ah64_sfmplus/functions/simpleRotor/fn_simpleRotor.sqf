params ["_heli", "_rtrNum", "_deltaTime"];
#include "\fza_ah64_sfmplus\headers\core.hpp"

private _cfg           = configOf _heli;
private _sfmPlusConfig = _cfg >> "Fza_SfmPlus";

private _numBlades       = getArray  (_sfmPlusConfig >> "rotorNumBlades")         select _rtrNum;
private _designRPM       = getArray  (_sfmPlusConfig >> "rotorDesignRPM")         select _rtrNum;
private _rpmTrimVal      = getNumber (_sfmPlusConfig >> "rotorRPMTrimVal")        select _rtrNum;
private _direction       = getArray  (_sfmPlusConfig >> "rotorDirection")         select _rtrNum;
private _type            = getArray  (_sfmPlusConfig >> "rotorType")              select _rtrNum;

private _pos             = getArray  (_sfmPlusConfig >> "rotorPos")               select _rtrNum;
private _rot             = getArray  (_sfmPlusConfig >> "rotorRot")               select _rtrNum;
private _gearRatio       = getArray  (_sfmPlusConfig >> "rotorGearRatio")         select _rtrNum;
private _heightAGL       = getArray  (_sfmPlusConfig >> "rotorHeightAGL")         select _rtrNum;
private _velocityMod     = getNumber (_sfmPlusConfig >> "rotorVelModifier");
private _thrustScalarMin = getArray  (_sfmPlusConfig >> "rotorThrustScalarMin")   select _rtrNum;
private _thrustScalarMax = getArray  (_sfmPlusConfig >> "rotorThrustScalarMax")   select _rtrNum;

private _bladeRadius     = getArray  (_sfmPlusConfig >> "rotorBladeRadius")       select _rtrNum;
private _bladeChord      = getArray  (_sfmPlusConfig >> "rotorBladeChord")        select _rtrNum;
private _bladePitchMin   = getArray  (_sfmPlusConfig >> "rotorBladePitch")        select _rtrNum select 0;
private _bladePitchMax   = getArray  (_sfmPlusConfig >> "rotorBladePitch")        select _rtrNum select 1;

private _profilePwrMin   = getArray  (_sfmPlusConfig >> "bladeProfilePowerMin")   select _rtrNum;
private _profilePwrMax   = getArray  (_sfmPlusConfig >> "bladeProfilePowerMax")   select _rtrNum;

private _inducedPwrMin   = getArray  (_sfmPlusConfig >> "bladeInducedPowerMin")   select _rtrNum;
private _inducedPwrMax   = getArray  (_sfmPlusConfig >> "bladeInducedPowerMax")   select _rtrNum;

private _axisX           = [[1.0, 0.0, 0.0], _rot] call fza_sfmplus_fnc_rotateVector;
private _axisY           = [[0.0, 1.0, 0.0], _rot] call fza_sfmplus_fnc_rotateVector;
private _axisZ           = [[0.0, 0.0, 1.0], _rot] call fza_sfmplus_fnc_rotateVector;

//Gather velocities
([_heli, false] call fza_sfmplus_fnc_getVelocities)
    params ["_gndSpeed", "_vel2D", "_vel3D", "_vertVel", "_velModelSpace"];
private _heliVel  = [_velModelSpace, _rot] call fza_sfmplus_fnc_rotateVector;
//Get rotor RPM
(_heli getVariable "fza_sfmplus_engPctNP")
    params ["_eng1PctNP", "_eng2PctNp"];
private _inputRPM = _eng1PctNP max _eng2PctNp;
//Thrust produced as a function collective input
private _bladePitch_cur                = _bladePitchMin + (_bladePitchMax - _bladePitchMin) * (fza_sfmplus_collectiveOutput + _altHoldCollOut);
private _rtrThrustScalarMin            = [_thrustScalarMin, _altitude] call fza_fnc_linearInterp select 1;
private _bladePitchInducedThrustScalar = _rtrThrustScalarMin + ((1 - _rtrThrustScalarMin) / _bladePitch_max)  * _bladePitch_cur;
//Rotor induced thrust as a function of RPM
private _rtrThrustScalarMax            = [_thrustScalarMax, _altitude] call fza_fnc_linearInterp select 1;
private _rtrRPMInducedThrustScalar     = (_inputRPM / _rpmTrimVal) * _rtrThrustScalarMax;
//Thrust scalar as a result of altitude
private _airDensityThrustScalar        = _dryAirDensity / ISA_STD_DAY_AIR_DENSITY;
//Additional thrust gained from increasing forward airspeed
private _velXY                         = vectorMagnitude [_heliVel # 0, _heliVel # 1];
private _airspeedVelocityScalar        = (1 + (_velXY / VEL_VBE)) ^ (_velocityMod);
//Induced flow handler
private _velZ                          = _heliVel # 2;
private _inducedVelocityScalar         = 1.0;
if (_velZ < -VEL_VRS && _velXY < VEL_ETL) then { 
    _inducedVelocityScalar = 0.0;
} else {
    if (_velXY < 74.59) then {
        _inducedVelocityScalar = 1 - (_velZ / 7.62);
    } else {
        _inducedVelocityScalar = 1 - (_velZ / VEL_VRS);
    };
};





#ifdef __A3_DEBUG__
[_heli, _pos, _pos vectorAdd _axisX, "red"]   call fza_sfmplus_fnc_debugDrawLine;
[_heli, _pos, _pos vectorAdd _axisY, "green"] call fza_sfmplus_fnc_debugDrawLine;
[_heli, _pos, _pos vectorAdd _axisZ, "blue"]  call fza_sfmplus_fnc_debugDrawLine;
[_heli, 24, _pos, _bladeRadius, _rot, "white", 0]   call fza_sfmplus_fnc_debugDrawCircle;
#endif