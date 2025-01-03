/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_interactStartSwitch

Description:
    Sets start switch state for the engine sim.

Parameters:
    _heli   - The helicopter to get information from [Unit].
    _engNum - The desired engine.

Returns:
    Whether to register a click (boolean).

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_engNum"];
#include "\fza_ah64_sfmplus\headers\core.hpp"

//if (_heli getVariable "fza_ah64_rtrbrake") exitWith {};

//New
private _isApuOn     = _heli getVariable "fza_systems_apuOn";
private _switchState = _heli getVariable "fza_sfmplus_engStartSwitchState" select _engNum;

if (!_isApuOn) exitWith {};

switch (_switchState) do {
	case START_SWITCH_OFF: {
		_switchState = START_SWITCH_START;
		[_heli, "fza_sfmplus_engStartSwitchState", _engNum, _switchState, true] call fza_fnc_setArrayVariable;

		true;
	};
	case START_SWITCH_START: {
		_switchState = START_SWITCH_OFF;//START_SWITCH_ORIDE;
		[_heli, "fza_sfmplus_engStartSwitchState", _engNum, _switchState, true] call fza_fnc_setArrayVariable;

		true;
	};
    //case START_SWITCH_ORIDE: {
	//	_switchState = START_SWITCH_OFF;
	//	[_heli, "fza_sfmplus_engStartSwitchState", _engNum, _switchState, true] call fza_fnc_setArrayVariable;

	//	true;
	//};
	default {
		true;
	}
};

//Old
private _engState    = _heli getVariable "fza_sfmplus_engState" select _engNum;

switch (_engState) do {
	case "STARTING": {
		_engState = "OFF";
		[_heli, "fza_sfmplus_engState", _engNum, _engState, true] call fza_fnc_setArrayVariable;

		false;
	};
	case "OFF": {
		_engState = "STARTING";
		[_heli, "fza_sfmplus_engState", _engNum, _engState, true] call fza_fnc_setArrayVariable;

		true;
	};
	default {
		true;
	}
};
