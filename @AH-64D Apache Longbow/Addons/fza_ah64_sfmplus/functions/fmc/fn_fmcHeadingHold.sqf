params ["_heli", "_deltaTime"];
#include "\fza_ah64_sfmplus\headers\core.hpp"

private _pid        = _heli getVariable "fza_sfmplus_pid_hdgHold";
private _curHdg     = getDir _heli;
private _desiredHdg = _heli getVariable "fza_ah64_hdgHoldDesiredHdg";
private _hdgError   = [_curHdg - _desiredHdg] call CBA_fnc_simplifyAngle180;
private _curVel     = vectorMagnitude [velocityModelSpace _heli # 0, velocityModelSpace _heli # 1];
private _subMode    = _heli getVariable "fza_ah64_hdgHoldSubMode";
private _output     = 0.0;
//If we are on the ground, or if the force trim is interupted, or the pilot has exceeded
//the breakout values for the pedals, then heading hold is not active (doing work)
//otherwise, heading hold is ALWAYS active
if (isTouchingGround _heli
    || _heli getVariable "fza_ah64_forceTrimInterupted" 
    || fza_sfmplus_pedalLeftRight <= -HDG_HOLD_BREAKOUT_VALUE 
    || fza_sfmplus_pedalLeftRight >=  HDG_HOLD_BREAKOUT_VALUE) then {
    if (_heli getVariable "fza_ah64_hdgHoldActive" isNotEqualTo false) then {
        _heli setVariable ["fza_ah64_hdgHoldActive", false, true];
    };
} else {
    if (_heli getVariable "fza_ah64_hdgHoldActive" isNotEqualTo true) then {
        _heli setVariable ["fza_ah64_hdgHoldActive", true, true];
        _heli setVariable ["fza_ah64_hdgHoldDesiredHdg", getDir _heli, true];
    };
};

if (_heli getVariable "fza_ah64_hdgHoldActive") then {
    //Heading and turn coordination logic...needs to take into account accel/decel
    if (_curVel < HDG_HOLD_SPEED_SWITCH_ACCEL) then {
        if (_subMode isNotEqualTo "hdg") then {
            _heli setVariable ["fza_ah64_hdgHoldSubMode", "hdg", true];
        };
    } else {
        if (_subMode isNotEqualTo "trn") then {
            _heli setVariable ["fza_ah64_hdgHoldSubMode", "trn", true];
        };
    };
    //Heading Hold
    if (_subMode == "hdg") then {
        _output = [_pid,  _deltaTime, 0.0, _hdgError] call fza_fnc_pidRun;
        _output = [_output, -1.0, 1.0] call BIS_fnc_clamp;
    };
    //Turn Coordination

} else {
    [_pid] call fza_fnc_pidReset;
};

systemChat format ["Heading Hold = %1 -- Heading Error = %2 -- Pedal = %3 -- Sub-Mode = %4", _heli getVariable "fza_ah64_hdgHoldActive", _hdgError toFixed 2, fza_sfmplus_pedalLeftRight toFixed 2, _subMode];
_output;