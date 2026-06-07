params ["_heli"];
#include "\fza_ah64_sfmplus\headers\core.hpp"

private _pidHdg        = _heli getVariable "fza_sfmplus_pid_hdgHold";
//_pidHdg set ["kp", H_KP];
//_pidHdg set ["ki", H_KI];
//_pidHdg set ["kd", H_KD];

private _pidTrn        = _heli getVariable "fza_sfmplus_pid_trnCoord";
//_pidTrn set ["kp", T_KP];
//_pidTrn set ["ki", T_KI];
//_pidTrn set ["kd", T_KD];

private _pidYaw        = _heli getVariable "fza_sfmplus_pid_sas_yaw";

private _deltaTime     = _heli getVariable "fza_sfmplus_deltaTime";
private _gndSpeed      = (_heli getVariable "fza_sfmplus_gndSpeed") * KNOTS_TO_MPS;
private _angVelZ       = (_heli getVariable "fza_sfmplus_angVelModelSpace") # 2;
private _pedalTrim     = _heli getVariable "fza_ah64_forceTrimPosPedal";
private _curHdg        = getDir _heli;
private _desiredHdg    = _heli getVariable "fza_ah64_hdgHoldDesiredHdg";
private _hdgError      = [_curHdg - _desiredHdg] call CBA_fnc_simplifyAngle180;
private _desiredSlip   = _heli getVariable "fza_ah64_hdgHoldDesiredSideslip";
private _sideslipError = [fza_ah64_sideslip - _desiredSlip] call CBA_fnc_simplifyAngle180;
private _subMode       = _heli getVariable "fza_ah64_hdgHoldSubMode";
private _attSubMode    = _heli getVariable "fza_ah64_attHoldSubMode";
private _hdgOutput     = 0.0;
private _trnOutput     = 0.0;
private _yawOutput     = 0.0;
private _output        = 0.0;

private _onGnd         = [_heli] call fza_sfmplus_fnc_onGround;
//Breakout values expand as the aircraft goes faster to provide good pedal response
//at a hover. The expanded range is meant to de-sensitize the pedals in order to 
//prevent disengaging the heading hold mode during cruise flight
private _breakoutValue = 0.0;
if (_attSubMode == "pos") then {
    _breakoutValue = HDG_HOLD_BREAKOUT_VALUE;
};
if (_attSubMode == "vel") then {
    _breakoutValue = VEL_HOLD_BREAKOUT_VALUE;
};
if (_attSubMode == "att") then {
    _breakoutValue = ATT_HOLD_BREAKOUT_VALUE;
};
//If we are on the ground, or if the force trim is interupted, or the pilot has exceeded
//the breakout values for the pedals, then heading hold is not active (doing work)
//otherwise, heading hold is ALWAYS active
private _breakout = false;
if ((_heli getVariable "fza_sfmplus_pedalLeftRight") <= -_breakoutValue && (_heli getVariable "fza_sfmplus_pedalLeftRight") < 0.0) then {
    _breakout = true;
};

if ((_heli getVariable "fza_sfmplus_pedalLeftRight") >= _breakoutValue && (_heli getVariable "fza_sfmplus_pedalLeftRight") > 0.0) then {
    _breakout = true;
};
//systemChat format ["_breakoutValue = %1 -- fza_sfmplus_pedalLeftRight = %2", _breakoutValue, (_heli getVariable "fza_sfmplus_pedalLeftRight") toFixed 2];
if (   _onGnd
    || _heli getVariable "fza_ah64_forceTrimInterupted"
    || _breakout
    ) then {
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
    //Compute target sub-mode from current state — one authoritative decision per frame.
    //  < 5 kts                              → hdg  (always, regardless of auto pedal)
    //  >= 5 kts, auto pedal on              → aut  (auto pedal owns axis via force trim, PIDs idle)
    //  >= 5 kts, auto pedal off, trn active → trn
    //  >= 5 kts, auto pedal off, trn off    → yaw
    private _targetSubMode = if (_gndSpeed < POS_HOLD_SPEED_SWITCH) then {
        "hdg"
    } else {
        if (fza_ah64_sfmPlusAutoPedal) then {
            "aut"
        } else {
            private _attHoldActive = _heli getVariable "fza_ah64_attHoldActive";
            private _curBank       = (_heli call BIS_fnc_getPitchBank) # 1;

            //Turn coord: engages at > 7 deg bank from level, disengages when back within 3 deg.
            //When disengaging, reset att hold roll reference to 0 so yaw SAS holds level cleanly.
            private _trnCoordActive = _attHoldActive && (if (_subMode == "trn") then { abs _curBank > 3.0 } else { abs _curBank > 7.0 });
            if (_subMode == "trn" && !_trnCoordActive) then {
                private _desiredAtt = _heli getVariable "fza_ah64_attHoldDesiredAtt";
                _heli setVariable ["fza_ah64_attHoldDesiredAtt", [_desiredAtt # 0, 0.0], true];
            };

            if (_trnCoordActive) then { "trn" } else { "yaw" }
        }
    };

    //On transition: reset outgoing PID; capture heading when returning to hdg
    if (_subMode != _targetSubMode) then {
        if (_subMode == "hdg") then { [_pidHdg] call fza_fnc_pidReset; };
        if (_subMode == "trn" || _subMode == "yaw") then { [_pidTrn] call fza_fnc_pidReset; };
        if (_subMode == "aut") then { [_pidYaw] call fza_fnc_pidReset; };
        if (_targetSubMode == "hdg") then {
            _heli setVariable ["fza_ah64_hdgHoldDesiredHdg", getDir _heli, true];
        };
        _subMode = _targetSubMode;
        _heli setVariable ["fza_ah64_hdgHoldSubMode", _subMode, true];
    };

    //Run exactly one PID per frame based on current sub-mode
    if (_subMode == "hdg") then {
        _hdgOutput = [_pidHdg, _deltaTime, 0.0, _hdgError] call fza_fnc_pidRun;
        _hdgOutput = [_hdgOutput, -1.0, 1.0] call BIS_fnc_clamp;
    };
    if (_subMode == "trn") then {
        _trnOutput = [_pidTrn, _deltaTime, 0.0, _sideslipError] call fza_fnc_pidRun;
        _trnOutput = [_trnOutput, -1.0, 1.0] call BIS_fnc_clamp;
    };
    if (_subMode == "yaw") then {
        _yawOutput = [_pidTrn, _deltaTime, _sideslipError, 0.0] call fza_fnc_pidRun;
        _yawOutput = [_yawOutput, -1.0, 1.0] call BIS_fnc_clamp;
    };
    //"aut": auto pedal owns the yaw axis via fza_ah64_forceTrimPosPedal (fn_getInput.sqf).
    //  fn_fmc.sqf zeroes _hdgHoldPedalYawOut when auto pedal is active, so no PID runs here.
    //  This sub-mode exists only to block "yaw" and "trn" from interfering.

    //Blend hdg → high-speed output across the 5-40 kt transition band.
    //Below 5 kts: pure heading hold. Above 40 kts: pure yaw SAS, turn coord, or auto pedal.
    private _highSpeedOutput = switch (_subMode) do {
        case "trn": { _trnOutput };
        case "yaw": { _yawOutput };
        case "aut": { 0.0 };        // auto pedal owns the axis; fn_fmc.sqf zeroes this anyway
        default     { 0.0 };
    };
    _output = linearConversion[POS_HOLD_SPEED_SWITCH, HDG_HOLD_SPEED_SWITCH_ACCEL, _gndSpeed, _hdgOutput, _highSpeedOutput, true];
} else {
    [_pidHdg] call fza_fnc_pidReset;
    [_pidTrn] call fza_fnc_pidReset;
    [_pidYaw] call fza_fnc_pidReset;
};

_output = [_output,  -0.1, 0.1] call BIS_fnc_clamp;

_output;
