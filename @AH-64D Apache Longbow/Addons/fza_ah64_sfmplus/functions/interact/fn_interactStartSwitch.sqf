/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_interactStartSwitch

Description:
	Handles start switch animations.

Parameters:
	...

Returns:
	Whether to register a click (boolean)

Examples:
	...

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_engNum"];

if(_heli animationphase "plt_rtrbrake" != 0) exitWith {};

private _engState    = _heli getVariable "fza_sfmplus_engState" select _engNum;

switch (_engState) do {
	case "STARTING": {
		_engState = "OFF";
		[_heli, "fza_sfmplus_engState", _engNum, _engState] call fza_sfmplus_fnc_setArrayVariable;

		true;
	};
	case "OFF": {
		_engState = "STARTING";
		[_heli, "fza_sfmplus_engState", _engNum, _engState] call fza_sfmplus_fnc_setArrayVariable;

		true;
	};
	default {
		false;
	}
};
