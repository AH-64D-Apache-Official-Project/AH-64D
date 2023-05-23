params ["_heli", "_deltaTime"];

//Attitude Hold
([_heli, _deltaTime] call fza_sfmplus_fnc_fmcAttitudeHold)
    params ["_attHoldCycPitchOut", "_attHoldCycRollOut"];
<<<<<<< Updated upstream
//systemChat format ["Att Hold Active = %1 -- Sub-Mode = %2", _heli getVariable "fza_ah64_attHoldActive", _heli getVariable "fza_ah64_attHoldSubMode"];
//systemChat format ["Pitch out = %1 -- Roll out = %2", _attHoldCycPitchOut, _attHoldCycRollOut];
//Heading Hold
private _hdgHoldPedalYawOut = 0.0;
//Altitude Hold
private _altHoldCollOut     = [_heli, _deltaTime] call fza_sfmplus_fnc_fmcAltitudeHold;
=======
//Altitude Hold
private _altHoldCollOut     = [_heli, _deltaTime] call fza_sfmplus_fnc_fmcAltitudeHold;
//Heading Hold
private _hdgHoldPedalYawOut = [_heli, _deltaTime] call fza_sfmplus_fnc_fmcHeadingHold;
>>>>>>> Stashed changes

[_attHoldCycPitchOut, _attHoldCycRollOut, _hdgHoldPedalYawOut, _altHoldCollOut];