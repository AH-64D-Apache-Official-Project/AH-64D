/* ----------------------------------------------------------------------------
Function: fza_fnc_aseIRJAM

Description:
	Handles the AN/ALQ-144 IR Jammer

Parameters:
	heli: Object - Vehicle the event handler is assigned to

Returns:
	Nothing

Examples:
    [_heli] call fza_fnc_aseIRJam

Author:
	BradMick
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"

params ["_heli", "_deltaTime"];

private _irJamPwr   = _heli getVariable "fza_ah64_ase_irJamPwr";
private _irJamState = _heli getVariable "fza_ah64_ase_irJamState";
private _irJamTimer = _heli getVariable "fza_ah64_ase_irJamTimer";

systemChat format ["IR Jam Pwr / State = %1 / %2", _irJamPwr, _irJamState];

switch (_irJamState) do {
	case ASE_IRJAM_STATE_OFF: {
		if (_irJamPwr == "on") then {
			_irJamState = ASE_IRJAM_STATE_WARM;
			_heli setVariable ["fza_ah64_ase_irJamState", _irJamState];	
		};
	};
	case ASE_IRJAM_STATE_WARM: {
		_irJamTimer = [_irJamTimer, 1.0, (1.0 / ASE_RFJAM_PWR_ON_TIME) * _deltaTime] call BIS_fnc_lerp;

		if (_irJamTimer > 0.99) then {
			_irJamState = ASE_IRJAM_STATE_OPER;
		};
		_heli setVariable ["fza_ah64_ase_irJamTimer", _irJamTimer];			
		_heli setVariable ["fza_ah64_ase_irJamState", _irJamState];	
	};
	case ASE_IRJAM_STATE_OPER: {
		if (_irJamPwr == "off") then {
			_irJamTimer = 0.0;
			_irJamState = ASE_IRJAM_STATE_OFF;
			_heli setVariable ["fza_ah64_ase_irJamTimer", _irJamTimer];			
			_heli setVariable ["fza_ah64_ase_irJamState", _irJamState];	
		} else {
		/*
		
			********** JAMMER CODE HERE**********

		*/
		};
	};
};

