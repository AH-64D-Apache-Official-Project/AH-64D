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

private _config         = configFile >> "CfgVehicles" >> typeof _heli >> "Fza_SfmPlus";
private _configVehicles = configFile >> "CfgVehicles" >> typeof _heli;
private _flightModel    = getText (_configVehicles >> "fza_flightModel");

private _apuOn     = _heli getVariable "fza_systems_apuOn";

private _engState  = _heli getVariable "fza_sfmplus_engState";
private _eng1State = _engState select 0;
private _eng2State = _engState select 1;

private _engPwrLvrState  = _heli getVariable "fza_sfmplus_engPowerLeverState";
private _eng1PwrLvrState = _engPwrLvrState select 0;
private _eng2PwrLvrState = _engPwrLvrState select 1;

private _eng1Np  = _heli getVariable "fza_sfmplus_engPctNP" select 0;
private _eng2Np  = _heli getVariable "fza_sfmplus_engPctNP" select 1;
private _rtrRPM  = _eng1Np max _eng2Np;

private _eng1TQ   = _heli getVariable "fza_sfmplus_engPctTQ" select 0;
private _eng2TQ   = _heli getVariable "fza_sfmplus_engPctTQ" select 1;
private _engPctTQ = _eng1TQ max _eng2TQ;

if (local _heli) then {
    if (_eng1State != "OFF" || _eng2State != "OFF") then {
        _heli engineOn true;
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

private _isSingleEng     = _heli getVariable "fza_sfmplus_isSingleEng";
private _isAutorotating  = _heli getVariable "fza_sfmplus_isAutorotating";

if ((_eng1PwrLvrState isEqualTo _eng2PwrLvrState) && (_eng1State == "ON" && _eng2State == "ON")) then {
    _isSingleEng = false;
} else {
    _isSingleEng = true;
};
_heli setVariable ["fza_sfmplus_isSingleEng", _isSingleEng];

if (isMultiplayer && local _heli && (_heli getVariable "fza_sfmplus_lastTimePropagated") + 5 < time) then {
    {
        _heli setVariable [_x, _heli getVariable _x, true];
    } forEach [
        "fza_sfmplus_engFF",
        "fza_sfmplus_engBaseNG",
        "fza_sfmplus_engPctNG",
        "fza_sfmplus_engBaseNP",
        "fza_sfmplus_engPctNP",
        "fza_sfmplus_engBaseTQ",
        "fza_sfmplus_engPctTQ",
        "fza_sfmplus_engBaseTGT",
        "fza_sfmplus_engTGT",
        "fza_sfmplus_engBaseOilPSI",
        "fza_sfmplus_engOilPSI"
    ];
    _heli setVariable ["fza_sfmplus_lastTimePropagated", time, true];
};

[_heli, 0, _deltaTime] call fza_sfmplus_fnc_engine;
[_heli, 1, _deltaTime] call fza_sfmplus_fnc_engine;

private _no1EngDmg = _heli getHitPointDamage "hitengine1";
private _no2EngDmg = _heli getHitPointDamage "hitengine2";

if (_no1EngDmg > SYS_ENG_DMG_THRESH || fuel _heli < 0.01) then {
	[_heli, "fza_sfmplus_engState", 0, "OFF", true] call fza_fnc_setArrayVariable;
};

if (_no2EngDmg > SYS_ENG_DMG_THRESH || fuel _heli < 0.01) then {
	[_heli, "fza_sfmplus_engState", 1, "OFF", true] call fza_fnc_setArrayVariable;
};

if (_eng1State == "OFF" && _eng2State == "OFF" && !_isAutorotating && local _heli) then {
    _heli engineOn false;
};

//Autorotation handler
private _velXY = vectorMagnitude [velocityModelSpace _heli # 0, velocityModelSpace _heli # 1];
if (   ((_eng1State == "OFF" && _eng2State == "OFF") || (_eng1PwrLvrState in ["OFF", "IDLE"] && _eng2PwrLvrState in ["OFF", "IDLE"]))
    && _engPctTQ < 0.10
    && !isTouchingGround _heli
    && _rtrRPM > EPSILON) then {
    _heli setVariable ["fza_sfmplus_isAutorotating", true];
} else {
    _heli setVariable ["fza_sfmplus_isAutorotating", false];
};
//End Autorotation handler

if (_flightModel == "SFMPlus") then {
    private _maxTQ    = getNumber (_config >> "engMaxTQ");
    private _limitTQ  = 0.0;
    private _limitRPM = getNumber (_config >> "engIdleNP");

    private _realRPM = [_heli] call fza_sfmplus_fnc_getRtrRPM;

    if (_isSingleEng) then {
        _limitTQ = _heli getVariable "fza_sfmplus_maxTQ_SE";
    } else {
        _limitTQ = _heli getVariable "fza_sfmplus_maxTQ_DE";
    };

    private _droopVal = (_rtrRPM - _limitRPM) / (_maxTQ - _limitTQ);
    private _droopRPM = _rtrRPM - ((_engPctTQ - _limitTQ) * _droopVal);
    _droopRPM = [_droopRPM, _limitRPM, _rtrRPM] call BIS_fnc_clamp;

    if (_heli getHitPointDamage "hithrotor" == 1.0) exitWith {};

    private _lastUpdate = _heli getVariable ["fza_sfmplus_lastUpdate", 0];
    if (cba_missionTime > _lastUpdate + MIN_TIME_BETWEEN_UPDATES && _rtrRPM > 0.05) then {
        _rtrRPM = _droopRPM;
            if (_realRPM  > _rtrRPM) then {
            _heli setHitpointDamage ["hithrotor", 0.9];
        } else {
            _heli setHitpointDamage ["hithrotor", 0.0];
            _heli engineOn true;
        };
        _heli setVariable ["fza_sfmplus_lastUpdate", cba_missionTime];
    };
};