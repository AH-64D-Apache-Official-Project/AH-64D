params ["_heli"];

if (_heli getVariable "fza_ah64_altHoldActive" == false) then {
    private _curVel    = vectorMagnitude [velocityModelSpace _heli # 0, velocityModelSpace _heli # 1];
    private _curVelZ   = velocity _heli # 2; 
    private _curAltAGL = ASLToAGL getPosASL _heli # 2;
    private _curAltASL = getPosASL _heli # 2;

    //If the vertical velocity is <= 200fpm and >= -200fpm, altitude hold can be engaged
    if (_curVelZ <= 1.016 && _curVelZ >= -1.016) then {
        //The collective reference is required to determine when to deactivate alt hold. If the
        //pilot moves the collective > 0.25 inches up/down from the ref, alt hold will be 
        //de-activate.
        _heli setVariable ["fza_ah64_altHoldCollRef",    fza_sfmplus_collectiveOutput];
        //If the helicopters radar altitude is < 1428ft (435.25m) and current velocity is < 40kts
        //then set the desired altitude to the current AGL altitude, otherwise set it to the
        //current ASL altitude.
        if (_curAltAGL < 435.254 && _curVel < 20.577) then {
            _heli setVariable ["fza_ah64_altHoldDesiredAlt", _curAltAGL];
            _heli setVariable ["fza_ah64_altHoldSubMode",    "rad"];
        } else {
            _heli setVariable ["fza_ah64_altHoldDesiredAlt", _curAltASL];
            _heli setVariable ["fza_ah64_altHoldSubMode",    "bar"];
        };
        //Activate altitude hold
        _heli setVariable ["fza_ah64_altHoldActive",     true];
    };
} else {
    //Reset the desired altitude and de-activate altitude hold
    _heli setVariable ["fza_ah64_altHoldDesiredAlt", 0.0];
    _heli setVariable ["fza_ah64_altHoldActive",     false];
    _heli setVariable ["fza_ah64_altHoldCollRef",    0.0];
    
};