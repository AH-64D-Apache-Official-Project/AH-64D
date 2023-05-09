params ["_heli"];

if (_heli getVariable "fza_ah64_attHoldActive" == false) then {
    //Collect required inputs
    private _curVel    = vectorMagnitude [velocity _heli # 0, velocity _heli # 1];

    //Position hold
    if (_curVel <= 2.572) then {
        _heli setVariable ["fza_ah64_attHoldSubMode", "pos"];
    };
    //Velocity hold
    //This needs to check if accelerating or decelerating...really it's
    //5 to 40 knots accelerating, 30 to 5 knots decelerating
    if (_curVel > 2.572 && _curVel <= 20.577) then {
        _heli setVariable ["fza_ah64_attHoldSubMode", "vel"];
    };
    //Attitude hold
    if (_curVel > 20.577) then {
        _heli setVariable ["fza_ah64_attHoldSubMode", "att"];
    };

    _heli setVariable ["fza_ah64_attHoldActive", true];
} else {
    _heli setVariable ["fza_ah64_attHoldActive", false];
};