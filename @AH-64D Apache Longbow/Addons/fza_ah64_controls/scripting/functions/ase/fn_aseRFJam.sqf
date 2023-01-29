/* ----------------------------------------------------------------------------
Function: fza_fnc_aseRFJAM

Description:
	Handles the AN/ALQ-136 RF Jammer 

Parameters:
	heli: Object - Vehicle the event handler is assigned to

Returns:
	Nothing

Examples:
    [_heli] call fza_fnc_aseRFJam

Author:
	BradMick
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"

params ["_heli", "_deltaTime"];

private _rfJamState = _heli getVariable "fza_ah64_ase_rfJamState";
private _rfJamTimer = _heli getVariable "fza_ah64_ase_rfJamTimer";

switch (_rfJamState) do {
	case ASE_RFJAM_STATE_OFF: {
		_heli setVariable ["fza_ah64_ase_rfJamTimer", 0.0];
		_heli setVariable ["fza_ah64_ase_rfJamState", ASE_RFJAM_STATE_OFF];
	};
	case ASE_RFJAM_STATE_WARM_STBY: {
		_rfJamTimer = [_rfJamTimer, 1.0, (1.0 / ASE_RFJAM_PWR_ON_TIME) * _deltaTime] call BIS_fnc_lerp;

		if (_rfJamTimer > 0.99) then {
			
			_rfJamState = ASE_RFJAM_STATE_STBY;
		};
		_heli setVariable ["fza_ah64_ase_rfJamTimer", _rfJamTimer];				
		_heli setVariable ["fza_ah64_ase_rfJamState", _rfJamState];
	};
	case ASE_RFJAM_STATE_STBY: {
		/*
		
			**********DO NOTHING**********

		*/
	};
	case ASE_RFJAM_STATE_WARM_OPER: {
		_rfJamTimer = [_rfJamTimer, 1.0, (1.0 / ASE_RFJAM_PWR_ON_TIME) * _deltaTime] call BIS_fnc_lerp;

		if (_rfJamTimer > 0.99) then {
			_rfJamState = ASE_RFJAM_STATE_OPER;
		};
		_heli setVariable ["fza_ah64_ase_rfJamTimer", _rfJamTimer];				
		_heli setVariable ["fza_ah64_ase_rfJamState", _rfJamState];
	};
	case ASE_RFJAM_STATE_OPER: {
		/*
		
			**********JAMMER CODE HERE**********

		*/
	};
};