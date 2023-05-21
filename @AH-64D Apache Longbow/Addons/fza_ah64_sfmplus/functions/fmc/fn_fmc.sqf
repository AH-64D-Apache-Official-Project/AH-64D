params ["_heli", "_deltaTime"];

//Attitude Hold
([_heli, _deltaTime] call fza_sfmplus_fnc_fmcAttitudeHold)
    params ["_attHoldCycPitchOut", "_attHoldCycRollOut"];
//systemChat format ["Att Hold Active = %1 -- Sub-Mode = %2", _heli getVariable "fza_ah64_attHoldActive", _heli getVariable "fza_ah64_attHoldSubMode"];
//systemChat format ["Pitch out = %1 -- Roll out = %2", _attHoldCycPitchOut, _attHoldCycRollOut];
//Altitude Hold
private _altHoldCollOut     = [_heli, _deltaTime] call fza_sfmplus_fnc_fmcAltitudeHold;
//Heading Hold
private _hdgHoldPedalYawOut = [_heli, _deltaTime] call fza_sfmplus_fnc_fmcHeadingHold;
systemChat format ["Heading Hold Output = %1", _hdgHoldPedalYawOut];

[_attHoldCycPitchOut, _attHoldCycRollOut, _hdgHoldPedalYawOut, _altHoldCollOut];