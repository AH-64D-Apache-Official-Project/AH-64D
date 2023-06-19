/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_engineController

Description:
    Monitors and controls engine states.

Parameters:
    _heli      - The helicopter to get information from [Unit].
    _deltaTime - Passed delta time from core update.

Returns:
    ...

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_deltaTime"];
#include "\fza_ah64_sfmplus\headers\core.hpp";
#include "\fza_ah64_systems\headers\systems.hpp"

private _apuOn           = _heli getVariable "fza_systems_apuOn";
private _isAutorotating  = _heli getVariable "fza_sfmplus_isAutorotating";
private _engState        = _heli getVariable "fza_sfmplus_simpleEng_state";
private _eng1State       = _engState select 0;
private _eng2State       = _engState select 1;
private _isSingleEng     = _heli getVariable "fza_sfmplus_isSingleEng";
private _engPwrLvrState  = _heli getVariable "fza_sfmplus_engPowerLeverState";
private _eng1PwrLvrState = _engPwrLvrState select 0;
private _eng2PwrLvrState = _engPwrLvrState select 1;

private _mainRtrTq       = _heli getVariable "fza_sfmplus_mainRtrTorque";
private _refTq           = 0.0;

//The engines cannot start unless the APU is on, and an engine is in the START
//state.
if (_apuOn && local _heli) then {
    if (   (_eng1State == "START" && _eng1PwrLvrState == "IDLE") 
        || (_eng2State == "START" && _eng2PwrLvrState == "IDLE")) then {
        _heli engineOn true;
    };
};

//Single engine handling
if (   (_eng1PwrLvrState isEqualTo _eng2PwrLvrState)
    && (_eng1State == "ON" && _eng2State == "ON")) then {
    _refTq       = _mainRtrTq / 2.0;
    _isSingleEng = false;
} else {
    _refTq       = _mainRtrTq;
    _isSingleEng = true;
};
_heli setVariable ["fza_sfmplus_isSingleEng", _isSingleEng];

//Engines
[_heli, 0, _deltaTime, _refTq] call fza_sfmplus_fnc_simpleEngine;
[_heli, 1, _deltaTime, _refTq] call fza_sfmplus_fnc_simpleEngine;

//Engine 1 damage handling
private _no1EngDmg = _heli getHitPointDamage "hitengine1";
if (_no1EngDmg > SYS_ENG_DMG_THRESH) then {
	[_heli, "fza_sfmplus_engState", 0, "OFF", true] call fza_fnc_setArrayVariable;
};
//Engine 2 damage handling
private _no2EngDmg = _heli getHitPointDamage "hitengine2";
if (_no2EngDmg > SYS_ENG_DMG_THRESH) then {
	[_heli, "fza_sfmplus_engState", 1, "OFF", true] call fza_fnc_setArrayVariable;
};

//Do not let the helicopter start if both engines are off
if (_eng1State == "OFF" && _eng2State == "OFF") then {
    _heli engineOn false;
};

private _velXY = vectorMagnitude [velocityModelSpace _heli # 0, velocityModelSpace _heli # 1];
if (   ((_eng1State == "OFF" && _eng2State == "OFF") || (_eng1PwrLvrState in ["OFF", "IDLE"] && _eng2PwrLvrState in ["OFF", "IDLE"]))
    && (_velXY > 23.15 && _velXY < 61.73)) then {
    _heli setVariable ["fza_sfmplus_isAutorotating", true];
} else {
    _heli setVariable ["fza_sfmplus_isAutorotating", false];
};

//Rotor animation speed control
/*
private _realRPM    = _heli animationPhase "mainRotorRPM";
private _rtrRPM     = _heli getVariable "fza_sfmplus_xmsnOutputRPM_pct";
private _lastUpdate = _heli getVariable ["fza_sfmplus_lastUpdate", 0];

if (_heli getHitPointDamage "hithrotor" == 1.0) exitWith {};

if (cba_missionTime > _lastUpdate + MIN_TIME_BETWEEN_UPDATES && _rtrRPM > 0.05) then {
    _rtrRPM = 0.57;
    systemChat "We should be drooping!";
    if ((_realRPM / 10)  > _rtrRPM) then {
        systemChat "Break rotor!";
        _heli setHitpointDamage ["hithrotor", 0.9];
    } else {
        systemChat "Fix rotor!";
        _heli setHitpointDamage ["hithrotor", 0.0];
        _heli engineOn true;
    };
    _heli setVariable ["fza_sfmplus_lastUpdate", cba_missionTime];
};*/