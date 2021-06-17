/* ----------------------------------------------------------------------------
Function: fza_fnc_engineGetTarget

Description:
	Handles rotorlib, governs the engine RPM. Should be called regularly, at least once a second

Parameters:
	_heli - The apache helicopter [Unit].

Returns:
	Nothing

Examples:
    --- Code
	[_heli] call fza_fnc_engineGovernor;
    ---

Author:
	mattysmith22
---------------------------------------------------------------------------- */
params["_heli"];

if (!local _heli) exitWith {};

_tgtTapeScaler = [
    [0, 0],
    [400, 0.10],
    [810, 0.60],
    [811, 0.70],
    [999, 1.00]
];
_npTapeScaler = [
    [0, 0],
    [96, 0.43],
    [99, 0.50],
    [100, 0.55],
    [102, 0.61],
    [105, 0.89],
    [120, 1.00]
];

_e1data = [_heli, 0] call fza_fnc_engineGetData;
_e1percent = (_e1data select 0) / 209.0;
_e1tgt = _e1data select 2;
_e1trq = (_e1data select 4) / 4.81;

_e2data = [_heli, 1] call fza_fnc_engineGetData;
_e2percent = (_e2data select 0) / 209.0;
_e2tgt = _e2data select 2;
_e2trq = (_e2data select 4) / 4.81;

_rotorRpm = _e1percent max _e2percent;

_heli animateSource["mpd_pr_eng_e1trq", _e1trq / 130.0];
_heli animateSource["mpd_pr_eng_e2trq", _e2trq / 130.0];
_heli animateSource["mpd_pr_eng_1tgt", ([_tgtTapeScaler, _e1tgt] call fza_fnc_linearInterp)# 1];
_heli animateSource["mpd_pr_eng_2tgt", ([_tgtTapeScaler, _e2tgt] call fza_fnc_linearInterp)# 1];
_heli animateSource["mpd_pr_eng_e1np", ([_npTapeScaler, _e1percent] call fza_fnc_linearInterp)# 1];
_heli animateSource["mpd_pr_eng_e2np", ([_npTapeScaler, _e2percent] call fza_fnc_linearInterp)# 1];

_heli animateSource["mpd_pr_eng_rtrrpm", ([_npTapeScaler, _rotorrpm] call fza_fnc_linearInterp)# 1];

((_heli getVariable "fza_ah64_engineStates") select 0) params ["_e1state", "_e1stateParams"];
((_heli getVariable "fza_ah64_engineStates") select 1) params ["_e2state", "_e2stateParams"];

//Startup
private _engineOffStates = ["OFF", "OFFSTARTED", "STARTEDOFF", "STARTED"];
if (!isEngineOn _heli && _heli animationphase "plt_batt" == 1 && _heli animationphase "plt_apu" == 1 && (!(_e1state in _engineOffStates) || !(_e2state in _engineOffStates)) && _heli animationphase "plt_rtrbrake" == 0) then {
    _heli setVariable ["fza_ah64_estarted", true, true];
    (vehicle player) engineOn true;
};

if (_heli animationphase "plt_eng1_throttle" == 0 && (_e1state == "OFF"  && _e2state == "OFF") && isEngineOn _heli) then {
    _heli setVariable ["fza_ah64_estarted", false, true];
    _heli engineOn false;
};

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