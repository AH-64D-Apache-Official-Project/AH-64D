/* ----------------------------------------------------------------------------
Function: fza_fnc_aseController


Description:
	Handles all ASE systems on the aircraft

Parameters:
	heli: Object - Vehicle the event handler is assigned to

Returns:
	Nothing

Examples:
    [_heli] call fza_fnc_aseController

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

private _deltaTime = ["ase_deltaTime"] call BIS_fnc_deltaTime;

[_heli] call fza_fnc_aseRLWR;
[_heli, _deltaTime] call fza_fnc_aseIRJam;
[_heli, _deltaTime] call fza_fnc_aseRFJam;
[_heli] call fza_fnc_aseChaff;
[_heli] call fza_fnc_aseAudioController;
