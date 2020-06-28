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
    fza_ah64_estarted = true;
    [] spawn { //TODO: Fix fuel management system so that sleep isn't needed here for 
        sleep 0.1;
        (vehicle player) engineOn true;
        (vehicle player) enableAutoStartUpRTD false;
        (vehicle player) setRotorBrakeRTD 0;
        (vehicle player) setActualCollectiveRTD 0;
        (vehicle player) setActualCollectiveRTD 0;
        (vehicle player) setWantedRPMRTD[20000, 15, -1];
        (vehicle player) setWantedRPMRTD[0, 15, -1];
        hint "call on";
    }
};

if (_heli animationphase "plt_eng1_throttle" == 0 && (_e1state == "OFF" && _e2state == "OFF") && isEngineOn _heli) then {
    fza_ah64_estarted = false;
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
}