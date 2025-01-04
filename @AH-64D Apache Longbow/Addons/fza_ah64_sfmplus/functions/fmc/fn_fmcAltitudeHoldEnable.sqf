params ["_heli"];

if (_heli getVariable "fza_ah64_altHoldActive" == false) then {
    //Collect required inputs
    private _curVel    = vectorMagnitude [velocityModelSpace _heli # 0, velocityModelSpace _heli # 1];
    private _curVelZ   = velocity _heli # 2; 
    private _curAltAGL = ASLToAGL getPosASL _heli # 2;
    if (_curAltAGL > 50) then {
        _curAltAGL = round ((_curAltAGL / 10) * 10);
    };
    private _curAltASL = round(((getPosASL _heli # 2) / 10) * 10);
    //If the vertical velocity is <= 200fpm and >= -200fpm, altitude hold can be engaged
    if (_curVelZ <= 1.016 && _curVelZ >= -1.016) then {
        //The collective reference is required to determine when to deactivate alt hold. If the
        //pilot moves the collective > 0.25 inches up/down from the ref, alt hold will be 
        //de-activate.
        [_heli, "fza_ah64_altHoldCollRef", (_heli getVariable "fza_sfmplus_collectiveOutput")] call fza_fnc_updateNetworkGlobal;
        //If the helicopters radar altitude is < 1428ft (435.25m) and current velocity is < 40kts
        //then set the desired altitude to the current AGL altitude, otherwise set it to the
        //current ASL altitude.
        if (_curAltAGL < 435.254 && _curVel < 20.577) then {
            [_heli, "fza_ah64_altHoldDesiredAlt", _curAltAGL] call fza_fnc_updateNetworkGlobal;
            [_heli, "fza_ah64_altHoldSubMode", "rad"] call fza_fnc_updateNetworkGlobal;
        } else {
            [_heli, "fza_ah64_altHoldDesiredAlt", _curAltASL] call fza_fnc_updateNetworkGlobal;
            [_heli, "fza_ah64_altHoldSubMode", "bar"] call fza_fnc_updateNetworkGlobal;
        };
        //Activate altitude hold
        [_heli, "fza_ah64_altHoldActive", true] call fza_fnc_updateNetworkGlobal;
    };
} else {
    //Reset the desired altitude and de-activate altitude hold
    [_heli, "fza_ah64_altHoldDesiredAlt", 0.0] call fza_fnc_updateNetworkGlobal;
    [_heli, "fza_ah64_altHoldActive", false] call fza_fnc_updateNetworkGlobal;
    [_heli, "fza_ah64_altHoldCollRef", 0.0] call fza_fnc_updateNetworkGlobal;
    [_heli] call fza_audio_fnc_flightTone;
};