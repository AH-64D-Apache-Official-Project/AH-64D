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
#include "\fza_ah64_sfmplus\headers\core.hpp";

private _numEng = 2;

//Get the engine states
(_heli getVariable "fza_sfmplus_engState")
    params ["_eng1State_new", "_eng2State_new"];
//Get the engine power lever states
(_heli getVariable "fza_sfmplus_engPowerLeverState")
    params ["_eng1PwrLvrState", "_eng2PwrLvrState"];
//Get the required engine torque
(_heli getVariable "fza_sfmplus_engTq_req")
    params ["_eng1Tq_req", "_eng2Tq_req"];

private _isOEI = _heli getVariable "fza_sfmplus_engIsOEI";

if (currentPilot _heli == player || local _heli) then {
    for "_i" from 0 to (_numEng - 1) do {
        [_heli, _i] call fza_sfmplus_fnc_engine;
    };

    if (_eng1State_new != ENG_OFF || _eng2State_new != ENG_OFF) then {
        _heli engineOn true;
    };

    if (_eng1State_new == ENG_OFF && _eng2State_new == ENG_OFF) then {
        _heli engineOn false;
    };

    if ((_eng1PwrLvrState isEqualTo _eng2PwrLvrState) && (_eng1State_new == ENG_ON && _eng2State_new == ENG_ON)) then {
        _isOEI = false;
    } else {
        _isOEI = true;
    };

    _heli setVariable ["fza_sfmplus_engIsOEI", _isOEI];
};

//Old
/*
private _config         = configFile >> "CfgVehicles" >> typeof _heli >> "Fza_SfmPlus";
private _configVehicles = configFile >> "CfgVehicles" >> typeof _heli;

private _apuOn     = _heli getVariable "fza_systems_apuOn";
private _onGnd     = [_heli] call fza_sfmplus_fnc_onGround;

private _engState  = _heli getVariable "fza_sfmplus_engState";
private _eng1State = _engState select 0;
private _eng2State = _engState select 1;

private _engPwrLvrState  = _heli getVariable "fza_sfmplus_engPowerLeverState";
private _eng1PwrLvrState = _engPwrLvrState select 0;
private _eng2PwrLvrState = _engPwrLvrState select 1;

private _eng1Np  = _heli getVariable "fza_sfmplus_engNp" select 0;
private _eng2Np  = _heli getVariable "fza_sfmplus_engNp" select 1;
private _rtrRPM  = _eng1Np max _eng2Np;
_rtrRPM = _rtrRPM * 0.01;

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

private _isOEI     = _heli getVariable "fza_sfmplus_engIsOEI";
private _isAutorotating  = _heli getVariable "fza_sfmplus_isAutorotating";

if ((_eng1PwrLvrState isEqualTo _eng2PwrLvrState) && (_eng1State == "ON" && _eng2State == "ON")) then {
    _isOEI = false;
} else {
    _isOEI = true;
};
_heli setVariable ["fza_sfmplus_engIsOEI", _isOEI];

if (isMultiplayer && (currentPilot _heli == player || local _heli) && (_heli getVariable "fza_sfmplus_lastTimePropagated") + 1 < time) then {
    {
        _heli setVariable [_x, _heli getVariable _x, true];
    } forEach [
        "fza_sfmplus_engFF",
        "fza_sfmplus_engBaseNG",
        "fza_sfmplus_engPctNG",
        "fza_sfmplus_engBaseNP",
        "fza_sfmplus_engPctNP",
        "fza_sfmplus_engPctTQ",
        "fza_sfmplus_engBaseTGT",
        "fza_sfmplus_engTGT",
        "fza_sfmplus_engBaseOilPSI",
        "fza_sfmplus_engOilPSI",
        "fza_sfmplus_engState",
        "fza_sfmplus_engFF"
    ];
    _heli setVariable ["fza_sfmplus_lastTimePropagated", time, true];
};

if (currentPilot _heli == player || local _heli) then {
    [_heli, 0] call fza_sfmplus_fnc_engine;
    [_heli, 1] call fza_sfmplus_fnc_engine;
};

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
if (   ((_eng1State == "OFF" && _eng2State == "OFF") || (_eng1PwrLvrState in [PWR_LEVER_OFF, PWR_LEVER_IDLE] && _eng2PwrLvrState in [PWR_LEVER_OFF, PWR_LEVER_IDLE]))
    && _engPctTQ < 0.10
    && !_onGnd
    && _rtrRPM > EPSILON) then {
    _heli setVariable ["fza_sfmplus_isAutorotating", true];
} else {
    _heli setVariable ["fza_sfmplus_isAutorotating", false];
};
//End Autorotation handler
*/