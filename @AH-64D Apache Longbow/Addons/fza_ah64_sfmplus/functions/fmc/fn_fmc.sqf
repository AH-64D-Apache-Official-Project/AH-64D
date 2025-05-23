params ["_heli"];
#include "\fza_ah64_sfmplus\headers\core.hpp"

private _deltaTime = _heli getVariable "fza_sfmplus_deltaTime";

//Attitude Hold
([_heli] call fza_sfmplus_fnc_fmcAttitudeHold)
    params ["_attHoldCycPitchOut", "_attHoldCycRollOut"];
//Altitude Hold
private _altHoldCollOut     = [_heli] call fza_sfmplus_fnc_fmcAltitudeHold;
//Heading Hold
private _hdgHoldPedalYawOut = [_heli] call fza_sfmplus_fnc_fmcHeadingHold;
//Stability Augmentation System (SAS)
([_heli, _deltaTime] call fza_sfmplus_fnc_fmcSAS)
    params ["_SASPitchOutput", "_SASRollOutput", "_SASYawOutput"];

if (fza_ah64_sfmPlusSpringlessPedals || fza_ah64_sfmPlusAutoPedal) then {
    _hdgHoldPedalYawOut = 0.0;
};

if (!(_heli getVariable "fza_ah64_fmcPitchOn")) then {
    _attHoldCycPitchOut = 0.0;
    _SASPitchOutput     = 0.0;
};

if (!(_heli getVariable "fza_ah64_fmcRollOn")) then {
    _attHoldCycRollOut = 0.0;
    _SASRollOutput     = 0.0;
};

if (!(_heli getVariable "fza_ah64_fmcYawOn")) then {
    _hdgHoldPedalYawOut = 0.0;
    _SASYawOutput       = 0.0;
};

if (!(_heli getVariable "fza_ah64_fmcCollOn")) then {
    _altHoldCollOut = 0.0;
};

_heli setVariable ["fza_sfmplus_fmcAttHoldCycPitchOut", _attHoldCycPitchOut];
_heli setVariable ["fza_sfmplus_fmcSasPitchOut",        _SASPitchOutput];

_heli setVariable ["fza_sfmplus_fmcAttHoldCycRollOut",  _attHoldCycRollOut];
_heli setVariable ["fza_sfmplus_fmcSasRollOut",         _SASRollOutput];

_heli setVariable ["fza_sfmplus_fmcHdgHoldPedalYawOut", _hdgHoldPedalYawOut];
_heli setVariable ["fza_sfmplus_fmcSasYawOut",          _SASYawOutput];

_heli setVariable ["fza_sfmplus_fmcAltHoldCollOut",     _altHoldCollOut];