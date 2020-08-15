/* ----------------------------------------------------------------------------
Function: fza_fnc_engineGetTarget

Description:
	Handles rotorlib, governs the engine RPM. Should be called regularly, at least once a second

Parameters:
	_heli - The apache helicopter [Unit].

Returns:
	Nothing

Examples:
    (begin example)
	[_heli] call fza_fnc_engineGovernor;
    (end)

Author:
	mattysmith22
---------------------------------------------------------------------------- */
params["_heli"];

if (!local _heli) exitWith {};

((_heli getVariable "fza_ah64_engineStates") select 0) params ["_e1state", "_e1stateParams"];
((_heli getVariable "fza_ah64_engineStates") select 1) params ["_e2state", "_e2stateParams"];

//Startup
if (!isEngineOn _heli && _heli animationphase "plt_batt" == 1 && _heli animationphase "plt_apu" == 1 && (_e1state != "OFF" || _e2state != "OFF") && _heli animationphase "plt_rtrbrake" == 0) then {
    _heli setVariable ["fza_ah64_estarted", true, true];
    (vehicle player) engineOn true;
    (vehicle player) enableAutoStartUpRTD false;
    (vehicle player) setRotorBrakeRTD 0;
    (vehicle player) setActualCollectiveRTD 0;
    (vehicle player) setWantedRPMRTD[20000, 15, -1];
    (vehicle player) setWantedRPMRTD[0, 15, -1];
};

if (_heli animationphase "plt_eng1_throttle" == 0 && (_e1state == "OFF" && _e2state == "OFF") && isEngineOn _heli) then {
    _heli setVariable ["fza_ah64_estarted", false, true];
    _heli engineOn false;
};

([_heli, 0] call fza_fnc_engineGetTarget) params["_e1rpm", "_e1time"];
([_heli, 1] call fza_fnc_engineGetTarget) params["_e2rpm", "_e2time"];

if (_e1rpm == _e2rpm) then {
    _heli setWantedRPMRTD[_e1rpm, _e1time min _e2time, -1];
} else {
    if (_e1rpm > _e2rpm) then {
        _heli setWantedRPMRTD[_e1rpm, _e1time, -1];
    } else {
        _heli setWantedRPMRTD[_e2rpm, _e2time, -1];
    }
};

_rotorrpm = if (count rotorsRpmRTD _heli == 2) then {
	(rotorsRpmRTD _heli# 0) / 2.89;
} else {0};

/*
 If there is a rotor rpm fault, autopage to engine and play audible warning

 The global variable fza_ah64_rotorRPMWarning is there to ensure that the autopaging and audible warning occurs once
 */
 if (_rotorrpm >= 106 && !fza_ah64_rotorRPMWarning) then {
    fza_ah64_rotorRPMWarning = true;
    ["fza_ah64_bt_rotorrpm", 1.7, "fza_ah64_bt_high", 1] execvm "\fza_ah64_controls\scripting\damage\dam_bt_audio.sqf";
    [_heli, 1, "eng"] call fza_fnc_mpdSetDisplay;
};

if (_rotorrpm < 106 && fza_ah64_rotorRPMWarning) then {
    fza_ah64_rotorRPMWarning = false;
};