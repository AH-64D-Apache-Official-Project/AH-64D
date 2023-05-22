params ["_heli", "_deltaTime"];
#include "\fza_ah64_sfmplus\headers\core.hpp"

private _pidHdg     = _heli getVariable "fza_sfmplus_pid_hdgHold";
private _pidTrn     = _heli getVariable "fza_sfmplus_pid_trnCoord";
//_pidTrn set ["kp", KP];
//_pidTrn set ["ki", KI];
//_pidTrn set ["kd", KD];
private _curHdg     = getDir _heli;
private _desiredHdg = _heli getVariable "fza_ah64_hdgHoldDesiredHdg";
private _hdgError   = [_curHdg - _desiredHdg] call CBA_fnc_simplifyAngle180;
private _curVel     = vectorMagnitude [velocityModelSpace _heli # 0, velocityModelSpace _heli # 1];
private _subMode    = _heli getVariable "fza_ah64_hdgHoldSubMode";
private _attSubMode = _heli getVariable "fza_ah64_attHoldSubMode";
private _output     = 0.0;
//Breakout values expand as the aircraft goes faster to provide good pedal response
//at a hover. The expanded range is meant to de-sensitize the pedasl in order to 
//prevent disengaging the heading hold mode during cruise flight
private _breakoutValue = 0.0;
if (_attSubMode == "pos") then {
    _breakoutValue = HDG_HOLD_BREAKOUT_VALUE;
};
if (_attSubMode == "vel") then {
    _breakoutValue = VEL_HOLD_BREAKOUT_VALUE;
};
if (_attSubMode == "att" || _curVel > HDG_HOLD_SPEED_SWITCH_ACCEL) then {
    _breakoutValue = ATT_HOLD_BREAKOUT_VALUE;
};
//If we are on the ground, or if the force trim is interupted, or the pilot has exceeded
//the breakout values for the pedals, then heading hold is not active (doing work)
//otherwise, heading hold is ALWAYS active
if (isTouchingGround _heli
    || _heli getVariable "fza_ah64_forceTrimInterupted" 
    || fza_sfmplus_pedalLeftRight <= -_breakoutValue 
    || fza_sfmplus_pedalLeftRight >=  _breakoutValue) then {
    if (_heli getVariable "fza_ah64_hdgHoldActive" isNotEqualTo false) then {
        _heli setVariable ["fza_ah64_hdgHoldActive", false, true];
    };
} else {
    if (_heli getVariable "fza_ah64_hdgHoldActive" isNotEqualTo true) then {
        _heli setVariable ["fza_ah64_hdgHoldActive", true, true];
        _heli setVariable ["fza_ah64_hdgHoldDesiredHdg", getDir _heli, true];
    };
};
//Finally, if the heading hold is active, perform the required functions
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
        _output = [_pidHdg, _deltaTime, 0.0, _hdgError] call fza_fnc_pidRun;
        _output = [_output, -1.0, 1.0] call BIS_fnc_clamp;
    };
    //Turn Coordination
    if (_subMode == "trn") then {
        _output = [_pidTrn, _deltaTime, 0.0, fza_ah64_sideslip * -1.0] call fza_fnc_pidRun;
        _output = [_output, -1.0, 1.0] call BIS_fnc_clamp;
    };
} else {
    [_pid] call fza_fnc_pidReset;
};

systemChat format ["Heading Hold = %1 -- Heading Error = %2 -- Pedal = %3 -- Sub-Mode = %4 -- Sideslip = %5", _heli getVariable "fza_ah64_hdgHoldActive", _hdgError toFixed 2, fza_sfmplus_pedalLeftRight toFixed 2, _subMode, fza_ah64_sideslip];
_output;