params ["_heli", "_deltaTime"];
#include "\fza_ah64_sfmplus\headers\core.hpp"

private _pid        = _heli getVariable "fza_sfmplus_pid_altHold";
private _curVel     = vectorMagnitude [velocityModelSpace _heli # 0, velocityModelSpace _heli # 1];
private _curAltAGL  = ASLToAGL getPosASL _heli # 2;
private _subMode    = _heli getVariable "fza_ah64_altHoldSubMode";
private _desiredAlt = _heli getVariable "fza_ah64_altHoldDesiredAlt";
private _collRef    = _heli getVariable  "fza_ah64_altHoldCollRef";
private _e1tq       = _heli getVariable "fza_sfmplus_engPctTQ" select 0;
private _e2tq       = _heli getVariable "fza_sfmplus_engPctTQ" select 1;
private _tq         = _e1tq max _e2tq;
private _output     = 0.0;

//If the total torque exceeds 98%, de-activate altitude hold and don't allow its
//activation until it it is below 98%
if (_tq >= 0.98) then { 
    _heli setVariable ["fza_ah64_altHoldActive", false, true];
    [_pid] call fza_fnc_pidReset;
};

if ( _heli getVariable "fza_ah64_altHoldActive") then {
    //If the pilot is intentionally trying to change altitude, de-activate altitude
    //hold and allow them to do so
    private _collRef_low = _collRef * 0.95;
    private _collRef_hi  = _collRef * 1.05;
    if (fza_sfmplus_collectiveOutput >= _collRef_hi || fza_sfmplus_collectiveOutput <= _collRef_low) then {
        _heli setVariable ["fza_ah64_altHoldActive", false, true];
    };

    //If the helicopters radar altitude is < 1428ft (435.25m) and current velocity is < 40kts
    //then set the desired altitude to the current AGL altitude, otherwise set it to the
    //current ASL altitude.
    if (_curAltAGL < RAD_ALT_MAX_ALT && _curVel < ALT_HOLD_SPEED_SWITCH) then {
        if (_heli getVariable "fza_ah64_altHoldSubMode" isNotEqualTo "rad") then {
            _heli setVariable ["fza_ah64_altHoldSubMode", "rad", true];
        };
    } else {
        if (_heli getVariable "fza_ah64_altHoldSubMode" isNotEqualTo "bar") then {
            _heli setVariable ["fza_ah64_altHoldSubMode", "bar", true];
        };
    };

    if (_subMode == "rad") then {
        //Radar altitude hold uses AGL altitude
        _output = [_pid, _deltaTime, _desiredAlt, ASLToAGL getPosASL _heli # 2] call fza_fnc_pidRun;
    } else {
        //Barometric altitude hold uses the ASL altitude
        _output = [_pid, _deltaTime, _desiredAlt, getPosASL _heli # 2] call fza_fnc_pidRun;
    };
} else {
    [_pid] call fza_fnc_pidReset;
};

_output;