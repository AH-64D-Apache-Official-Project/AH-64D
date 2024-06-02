params ["_heli"];
#include "\fza_ah64_sfmplus\headers\core.hpp"

if (_heli getVariable "fza_sfmplus_attHoldActive" == false) then {
    //Collect required inputs
    private _curVel    = vectorMagnitude [velocity _heli # 0, velocity _heli # 1];

    //Position hold
    if (_curVel <= POS_HOLD_SPEED_SWITCH) then {
        _heli setVariable ["fza_sfmplus_attHoldSubMode",   "pos",         true];
        _heli setVariable ["fza_sfmplus_attHoldDesiredPos", getPos _heli, true];
    };
    //Velocity hold
    //This needs to check if accelerating or decelerating...really it's
    //5 to 40 knots accelerating, 30 to 5 knots decelerating
    if (_curVel > POS_HOLD_SPEED_SWITCH && _curVel <= VEL_HOLD_SPEED_SWITCH_ACCEL) then {
        _heli setVariable ["fza_sfmplus_attHoldSubMode", "vel", true];
        
        private _curVel   = velocityModelSpace _heli;
        private _curVelX  = (_curVel # 0) * -1.0;
        private _curVelY  = _curVel # 1;
        _heli setVariable ["fza_sfmplus_attHoldDesiredVel", [_curVelX, _curVelY], true];
    };
    //Attitude hold
    if (_curVel > VEL_HOLD_SPEED_SWITCH_ACCEL) then {
        _heli setVariable ["fza_sfmplus_attHoldSubMode", "att", true];

        (_heli call BIS_fnc_getPitchBank)
            params ["_curPitch", "_curRoll"];
        _heli setVariable ["fza_sfmplus_attHoldDesiredAtt", [_curPitch, _curRoll], true];
    };

    _heli setVariable ["fza_sfmplus_attHoldActive", true, true];
} else {
    _heli setVariable ["fza_sfmplus_attHoldActive", false, true];
    [_heli] call fza_audio_fnc_flightTone;
};