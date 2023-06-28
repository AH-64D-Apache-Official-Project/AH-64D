params ["_heli", "_deltaTime"];

//Attitude Hold
([_heli, _deltaTime] call fza_sfmplus_fnc_fmcAttitudeHold)
    params ["_attHoldCycPitchOut", "_attHoldCycRollOut"];
//Altitude Hold
private _altHoldCollOut     = [_heli, _deltaTime] call fza_sfmplus_fnc_fmcAltitudeHold;
//Heading Hold
private _hdgHoldPedalYawOut = [_heli, _deltaTime] call fza_sfmplus_fnc_fmcHeadingHold;

if (currentPilot _heli != player) exitWith { 
    systemChat "You are not the the pilot in command, No fmc for you";
    _attHoldCycPitchOut = 0.0;
    _attHoldCycRollOut  = 0.0;
    _hdgHoldPedalYawOut = 0.0;
    _altHoldCollOut     = 0.0;
};

[_attHoldCycPitchOut, _attHoldCycRollOut, _hdgHoldPedalYawOut, _altHoldCollOut];