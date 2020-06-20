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

//Startup
if (!isEngineOn _heli && _heli animationphase "plt_batt" == 1 && _heli animationphase "plt_apu" == 1 && (_heli animationphase "plt_eng1_start" == 1 || _heli animationphase "plt_eng2_start" == 1) && _heli animationphase "plt_rtrbrake" == 0) then {
    fza_ah64_estarted = true;
    (vehicle player) engineOn true;
    (vehicle player) enableAutoStartUpRTD false;
    (vehicle player) setRotorBrakeRTD 0;
    (vehicle player) setActualCollectiveRTD 0;
    (vehicle player) setActualCollectiveRTD 0;
    (vehicle player) setWantedRPMRTD[20000, 15, -1];
    (vehicle player) setWantedRPMRTD[0, 15, -1];
    fza_ah64_l1clicked = 1;
};

if (_heli animationphase "plt_eng1_throttle" == 0 && _heli animationphase "plt_eng2_throttle" == 0 && (_heli animationphase "plt_eng1_start" == 0 && _heli animationphase "plt_eng2_start" == 0) && isEngineOn _heli) then {
    _heli engineOn false;
    fza_ah64_estarted = false;
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