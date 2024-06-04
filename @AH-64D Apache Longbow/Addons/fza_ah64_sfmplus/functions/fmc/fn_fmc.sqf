params ["_heli", "_deltaTime"];

//Attitude Hold
([_heli, _deltaTime] call fza_sfmplus_fnc_fmcAttitudeHold)
    params ["_attHoldCycPitchOut", "_attHoldCycRollOut"];
//Altitude Hold
private _altHoldCollOut     = [_heli, _deltaTime] call fza_sfmplus_fnc_fmcAltitudeHold;
//Heading Hold
private _hdgHoldPedalYawOut = [_heli, _deltaTime] call fza_sfmplus_fnc_fmcHeadingHold;
if (!fza_ah64_sfmplusEnableHeadingHold) then {
    _hdgHoldPedalYawOut = 0.0;
};





[_attHoldCycPitchOut, _attHoldCycRollOut, _hdgHoldPedalYawOut, _altHoldCollOut];