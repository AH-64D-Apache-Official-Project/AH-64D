params ["_heli", "_deltaTime"];
#include "\fza_ah64_sfmplus\headers\core.hpp"

//Attitude Hold
([_heli, _deltaTime] call fza_sfmplus_fnc_fmcAttitudeHold)
    params ["_attHoldCycPitchOut", "_attHoldCycRollOut"];
//Altitude Hold
private _altHoldCollOut     = [_heli, _deltaTime] call fza_sfmplus_fnc_fmcAltitudeHold;
//Heading Hold
private _hdgHoldPedalYawOut = [_heli, _deltaTime] call fza_sfmplus_fnc_fmcHeadingHold;
if (!fza_ah64_sfmplusEnableHeadingHold
    || fza_ah64_sfmPlusControlScheme == KEYBOARD
    || fza_ah64_sfmPlusControlScheme == MOUSE) then {
    _hdgHoldPedalYawOut = 0.0;
};

([_heli, _deltaTime] call fza_sfmplus_fnc_fmcSAS)
    params ["_SASPitchOutput", "_SASRollOutput", "_SASYawOutput"];

[_attHoldCycPitchOut + _SASPitchOutput, _attHoldCycRollOut + _SASRollOutput, _hdgHoldPedalYawOut + _SASYawOutput, _altHoldCollOut];