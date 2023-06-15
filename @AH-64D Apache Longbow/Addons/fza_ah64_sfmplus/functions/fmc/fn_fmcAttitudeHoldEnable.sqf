params ["_heli"];
#include "\fza_ah64_sfmplus\headers\core.hpp"

if (_heli getVariable "fza_ah64_attHoldActive" == false) then {
    //Collect required inputs
    private _curVel    = vectorMagnitude [velocity _heli # 0, velocity _heli # 1];

    //Position hold
    if (_curVel <= POS_HOLD_SPEED_SWITCH) then {
        [_heli, "fza_ah64_attHoldSubMode", "pos"] call fza_fnc_updateNetworkGlobal;
        [_heli, "fza_ah64_attHoldDesiredPos", getPos _heli] call fza_fnc_updateNetworkGlobal;
    };
    //Velocity hold
    //This needs to check if accelerating or decelerating...really it's
    //5 to 40 knots accelerating, 30 to 5 knots decelerating
    if (_curVel > POS_HOLD_SPEED_SWITCH && _curVel <= VEL_HOLD_SPEED_SWITCH_ACCEL) then {
        [_heli, "fza_ah64_attHoldSubMode", "vel"] call fza_fnc_updateNetworkGlobal;
    };
    //Attitude hold
    if (_curVel > VEL_HOLD_SPEED_SWITCH_ACCEL) then {
        [_heli, "fza_ah64_attHoldSubMode", "att"] call fza_fnc_updateNetworkGlobal;
    };

    [_heli, "fza_ah64_attHoldActive", true] call fza_fnc_updateNetworkGlobal;
} else {
    [_heli, "fza_ah64_attHoldActive", false] call fza_fnc_updateNetworkGlobal;
};