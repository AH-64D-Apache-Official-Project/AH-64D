fmPlusConfig
params ["_sfmPlusConfig", "_rtrNum", "_deltaTime", "_vel2D"];
#include "\fza_ah64_sfmplus\headers\core.hpp"

private _heliType            = getNumber (_sfmPlusConfig >> "heliType");
private _rtrType             = getArray  (_sfmPlusConfig >> "rotorType")              select _rtrNum;

private _collective_min      = getArray  (_sfmPlusConfig >> "collectivePitch")        select _rtrNum select 0;
private _collective_max      = getArray  (_sfmPlusConfig >> "collectivePitch")        select _rtrNum select 1;
//Add FMC input here

private _cyclicPitch_min     = getArray (_sfmPlusConfig >> "cyclicPitch")      select _rtrNum select 0;
private _cyclicPitch_max     = getArray (_sfmPlusConfig >> "cyclicPitch")      select _rtrNum select 1;
private _cyclicPitch_mix     = getArray (_sfmPlusConfig >> "cyclicPitch")      select _rtrNum select 2;
private _cyclicFwdAftTrim    = _heli getVariable "fza_sfmplus_forceTrimPosPitch";
//Add FMC input here

private _cyclicRoll_min      = getArray (_sfmPlusConfig >> "cyclicRoll")       select _rtrNum select 0;
private _cyclicRoll_max      = getArray (_sfmPlusConfig >> "cyclicRoll")       select _rtrNum select 1;
private _cyclicLeftRightTrim = _heli getVariable "fza_sfmplus_forceTrimPosRoll";
//Add FMC input here

private _pedal_min           = getArray (_sfmPlusConfig >> "pedalYaw")         select _rtrNum select 0;
private _pedal_max           = getArray (_sfmPlusConfig >> "pedalYaw")         select _rtrNum select 1;
private _pedal_mix           = getArray (_sfmPlusConfig >> "pedalYaw")         select _rtrNum select 2;
private _pedalLeftRightTrim  = _heli getVariable "fza_sfmplus_forceTrimPosPedal";
//Add FMC input here

switch (_heliType) do {
    case CONVENTIONAL: {
        if (_rtrType == MAIN) then {
            _theta0 = _collective_min + ((_collective_max - _collective_min) * fza_sfmplus_collectiveOutput);
            _AIC    = linearConversion[-1.0, 1.0, fza_sfmplus_cyclicLeftRight + _cyclicLeftRightTrim, _cyclicRoll_min,  _cyclicRoll_max,  true];
            _BIC    = linearConversion[-1.0, 1.0, fza_sfmplus_cyclicFwdAft    + _cyclicFwdAftTrim,    _cyclicPitch_min, _cyclicPitch_max,  true];
        };

        if (_rtrType == TAIL) then {
            _theta0 = linearConversion[-1.0, 1.0, fza_sfmplus_pedalLeftRight + _pedalLeftRightTrim, _pedal_min,  _pedal_max,  true];
        };
    };
    case TANDEM: {

    };
    case COAXIAL: {

    };
    case TILTROTOR: {

    };
};

[_AIC, _BIC, _theta0, _mastPitchRoll];