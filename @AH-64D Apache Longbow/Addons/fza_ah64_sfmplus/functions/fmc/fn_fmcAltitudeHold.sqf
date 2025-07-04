params ["_heli"];
#include "\fza_ah64_sfmplus\headers\core.hpp"

private _deltaTime  = _heli getVariable "fza_sfmplus_deltaTime";
private _gndSpeed   = (_heli getVariable "fza_sfmplus_gndSpeed") * KNOTS_TO_MPS;
private _pidRadAlt  = _heli getVariable "fza_sfmplus_pid_radHold";
//_pidRadAlt set ["kp", RAD_KP];
//_pidRadAlt set ["ki", RAD_KI];
//_pidRadAlt set ["kd", RAD_KD];
private _pidBarAlt  = _heli getVariable "fza_sfmplus_pid_barHold";
//_pidBarAlt set ["kp", BAR_KP];
//_pidBarAlt set ["ki", BAR_KI];
//_pidBarAlt set ["kd", BAR_KD];
private _curAltAGL  = ASLToAGL getPosASL _heli # 2;
private _subMode    = _heli getVariable "fza_ah64_altHoldSubMode";
private _desiredAlt = _heli getVariable "fza_ah64_altHoldDesiredAlt";
private _curAltMSL  = getPosASL _heli # 2;
private _collRef    = _heli getVariable  "fza_ah64_altHoldCollRef";
private _e1tq       = _heli getVariable "fza_sfmplus_engPctTQ" select 0;
private _e2tq       = _heli getVariable "fza_sfmplus_engPctTQ" select 1;
private _tq         = _e1tq max _e2tq;
private _output     = 0.0;

//If the total torque exceeds 98%, de-activate altitude hold and don't allow its
//activation until it it is below 98%
if (_tq >= 0.98) then { 
    [_heli, "fza_ah64_altHoldActive", false] call fza_fnc_updateNetworkGlobal;
    [_pidRadAlt] call fza_fnc_pidReset;
    [_pidBarAlt] call fza_fnc_pidReset;
    //playsound "fza_ah64_flt_control";
};

if ( _heli getVariable "fza_ah64_altHoldActive") then {
    //If the pilot is intentionally trying to change altitude, de-activate altitude
    //hold and allow them to do so
    private _collRef_low = _collRef * 0.95;
    private _collRef_hi  = _collRef * 1.05;
    if ((_heli getVariable "fza_sfmplus_collectiveOutput") >= _collRef_hi || (_heli getVariable "fza_sfmplus_collectiveOutput") <= _collRef_low) then {
        [_heli, "fza_ah64_altHoldActive", false] call fza_fnc_updateNetworkGlobal;
        [_heli] spawn fza_audio_fnc_flightTone;
    };

    //If the helicopters radar altitude is < 1428ft (435.25m) and current velocity is < 40kts
    //then set the desired altitude to the current AGL altitude, otherwise set it to the
    //current ASL altitude.
    if (_curAltAGL < RAD_ALT_MAX_ALT && _gndSpeed < ALT_HOLD_SPEED_SWITCH) then {
        [_heli, "fza_ah64_altHoldSubMode", "rad"] call fza_fnc_updateNetworkGlobal;
    } else {
        [_heli, "fza_ah64_altHoldSubMode", "bar"] call fza_fnc_updateNetworkGlobal;
    };

    if (_subMode == "rad") then {
        //Radar altitude hold uses AGL altitude
        private _altError = _curAltAGL - _desiredAlt;
        _output = [_pidRadAlt, _deltaTime, 0.0, _altError] call fza_fnc_pidRun;
    } else {
        //Barometric altitude hold uses the ASL altitude
        private _altError = _curAltMSL - _desiredAlt;
        _output = [_pidBarAlt, _deltaTime, 0.0, _altError] call fza_fnc_pidRun;
    };
} else {
    [_pidRadAlt] call fza_fnc_pidReset;
    [_pidBarAlt] call fza_fnc_pidReset;
};

_output;