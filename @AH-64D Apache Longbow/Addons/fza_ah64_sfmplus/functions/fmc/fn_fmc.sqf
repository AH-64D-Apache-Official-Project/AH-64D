params ["_heli", "_deltaTime"];

hintSilent format ["Pitch = %1
                    \nRoll = %2
                    \nYaw = %3
                    \nColl = %4
                    \nTrim = %5",
                    _heli getVariable "fza_ah64_fmcPitchOn"
                    ,_heli getVariable "fza_ah64_fmcRollOn"
                    ,_heli getVariable "fza_ah64_fmcYawOn"
                    ,_heli getVariable "fza_ah64_fmcCollOn"
                    ,_heli getVariable "fza_ah64_fmcTrimOn"];


//Attitude Hold
([_heli, _deltaTime] call fza_sfmplus_fnc_fmcAttitudeHold)
    params ["_attHoldCycPitchOut", "_attHoldCycRollOut"];
//Altitude Hold
private _altHoldCollOut     = [_heli, _deltaTime] call fza_sfmplus_fnc_fmcAltitudeHold;
//Heading Hold
private _hdgHoldPedalYawOut = [_heli, _deltaTime] call fza_sfmplus_fnc_fmcHeadingHold;

[_attHoldCycPitchOut, _attHoldCycRollOut, _hdgHoldPedalYawOut, _altHoldCollOut];