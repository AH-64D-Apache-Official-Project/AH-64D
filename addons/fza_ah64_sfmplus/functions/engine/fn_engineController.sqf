/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_engineController

Description:
    Monitors and controls engine states.

Parameters:
    _heli      - The helicopter to get information from [Unit].

Returns:
    ...

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli"];
#include "\fza_ah64_sfmplus\headers\core.hpp"
#include "\fza_ah64_systems\headers\systems.hpp"

private _config         = configOf _heli >> "Fza_SfmPlus";
private _configVehicles = configOf _heli;

private _apuOn     = _heli getVariable "fza_systems_apuOn";
private _onGnd     = [_heli] call fza_sfmplus_fnc_onGround;

private _engState  = _heli getVariable "fza_sfmplus_engState";
private _eng1State = _engState select 0;
private _eng2State = _engState select 1;

private _engPwrLvrState  = _heli getVariable "fza_sfmplus_engPowerLeverState";
private _eng1PwrLvrState = _engPwrLvrState select 0;
private _eng2PwrLvrState = _engPwrLvrState select 1;

private _eng1Np  = _heli getVariable "fza_sfmplus_engPctNP" select 0;
private _eng2Np  = _heli getVariable "fza_sfmplus_engPctNP" select 1;
private _rtrRPM  = _heli getVariable "fza_sfmplus_rtrRPM";

private _eng1TQ   = _heli getVariable "fza_sfmplus_engPctTQ" select 0;
private _eng2TQ   = _heli getVariable "fza_sfmplus_engPctTQ" select 1;
private _engPctTQ = _eng1TQ max _eng2TQ;
private _eng1FuelAvail = _heli getVariable ["fza_fuel_eng1FuelAvail", true];
private _eng2FuelAvail = _heli getVariable ["fza_fuel_eng2FuelAvail", true];

private _isSingleEng     = _heli getVariable "fza_sfmplus_isSingleEng";
//private _isAutorotating  = _heli getVariable "fza_sfmplus_isAutorotating";


if (local _heli) then {
    
    /*
    if ((_heli getHitPointDamage "hithrotor") < 1.0) then {
        private _lastRtdUpdate = _heli getVariable ["fza_sfmplus_lastUpdate", 0];
        if (cba_missionTime > _lastRtdUpdate + MIN_TIME_BETWEEN_UPDATES) then {
            private _realRPM = (_heli animationPhase "mainRotorRPM") * 1.08 / 10;
            if (_realRPM > _rtrRPM && _rtrRPM < 0.9) then {
                _heli setHitPointDamage ["hithrotor", 0.9];
            } else {
                _heli setHitPointDamage ["hithrotor", 0.0];
                _heli engineOn true;
            };
            _heli setVariable ["fza_sfmplus_lastUpdate", cba_missionTime];
        };
    } else {
        _heli engineOn false;
    };

    if (_eng1State == "OFF" && _eng2State == "OFF" && _rtrRPM < 0.5) then {
        _heli engineOn false;
        _heli setHitPointDamage ["hithrotor", 0.9];
    };
    */
    if ((_heli getHitPointDamage "hithrotor") > 0.9) then {
        _heli engineOn false;
    } else {
        if (_eng1State != "OFF" || _eng2State != "OFF" || _rtrRPM >= 0.5) then {
            _heli engineOn true;
        } else {
            _heli engineOn false;
        };
    };
    private _shiftLocked = _heli getVariable "fza_sfmplus_shiftLocked";
    if (_eng1State == "OFF" && _eng2State == "OFF" && _rtrRPM < 0.1) then { //prevents player holding shift causing Rotor spinning
        _heli engineOn false;
        _heli setHitPointDamage ["hithrotor", 0.9];
        if (!_shiftLocked) then {
            _heli setVariable ["fza_sfmplus_shiftLocked", true];
        };
    } else {
        if (_shiftLocked) then {
            _heli setVariable ["fza_sfmplus_shiftLocked", false];
            _heli setHitPointDamage ["hithrotor", 0];
        };
    };
};


if !_apuOn then {
    if (_eng1State == "STARTING") then {
		[_heli, "fza_sfmplus_engState", 0, "OFF", true] call fza_fnc_setArrayVariable;
    };
    if (_eng2State == "STARTING") then {
		[_heli, "fza_sfmplus_engState", 1, "OFF", true] call fza_fnc_setArrayVariable;
    };
};

// Single engine when: one engine is OFF/damaged, or one power lever is at IDLE
// while the other is at FLY (lever-induced single engine operation).
private _eng1Active = (_eng1State in ["STARTING","ON"]) && (_eng1PwrLvrState == "FLY");
private _eng2Active = (_eng2State in ["STARTING","ON"]) && (_eng2PwrLvrState == "FLY");
_isSingleEng = !(_eng1Active && _eng2Active);
_heli setVariable ["fza_sfmplus_isSingleEng", _isSingleEng];

if (isMultiplayer && (currentPilot _heli == player || local _heli) && (_heli getVariable "fza_sfmplus_lastTimePropagated") + 0.1 < time) then {
    {
        _heli setVariable [_x, _heli getVariable _x, true];
    } forEach [
        "fza_systems_apuRPM_pct",
        "fza_sfmplus_engFF",
        "fza_sfmplus_engPctNG",
        "fza_sfmplus_engPctNP",
        "fza_sfmplus_engPctTQ",
        "fza_sfmplus_engBaseTGT",
        "fza_sfmplus_engTGT",
        "fza_sfmplus_engBaseOilPSI",
        "fza_sfmplus_engOilPSI",
        "fza_sfmplus_engState",
        "fza_sfmplus_engFF",
        "fza_sfmplus_collectiveOutput",
        "fza_sfmplus_xmsnOutputRpm",
        "fza_sfmplus_xmsnDeltaRpm"
    ];
    _heli setVariable ["fza_sfmplus_lastTimePropagated", time, true];
};

if (currentPilot _heli == player || local _heli) then {
    [_heli, 0] call fza_sfmplus_fnc_engine;
    [_heli, 1] call fza_sfmplus_fnc_engine;

    if (fza_ah64_sfmPlusRotorModel == 1) then {
        [_heli, 0] call fza_sfmplus_fnc_engineBET;
        [_heli, 1] call fza_sfmplus_fnc_engineBET;
    } else {
        [_heli, 0] call fza_sfmplus_fnc_engine2;
        [_heli, 1] call fza_sfmplus_fnc_engine2;
    };
};

private _no1EngDmg = _heli getHitPointDamage "hitengine1";
private _no2EngDmg = _heli getHitPointDamage "hitengine2";

if (_no1EngDmg > SYS_ENG_DMG_THRESH || !_eng1FuelAvail) then {
	[_heli, "fza_sfmplus_engState", 0, "OFF", true] call fza_fnc_setArrayVariable;
};

if (_no2EngDmg > SYS_ENG_DMG_THRESH || !_eng2FuelAvail) then {
	[_heli, "fza_sfmplus_engState", 1, "OFF", true] call fza_fnc_setArrayVariable;
};

//Autorotation handler
/*
private _velXY = vectorMagnitude [velocityModelSpace _heli # 0, velocityModelSpace _heli # 1];
if (   _engPctTQ < 0.10
    && !_onGnd
    && _rtrRPM > EPSILON) then {
    _heli setVariable ["fza_sfmplus_isAutorotating", true];
} else {
    _heli setVariable ["fza_sfmplus_isAutorotating", false];
};
*/
//systemChat format ["_isAutorotating = %1", _heli getVariable "fza_sfmplus_isAutorotating"];
//End Autorotation handler
