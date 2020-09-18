/* ----------------------------------------------------------------------------
Function: fza_fnc_controlHandleIHADSSMode

Description:
	Switches the helicopter's HMD between the different modes.

Parameters:
	_heli - The apache helicopter to change the autopage setting for.

Returns:
	Nothing

Examples:
	--- Code
    [_heli] call fza_fnc_controlHandleIHADSSMode
	---

Author:
	Unknown
---------------------------------------------------------------------------- */
params ["_heli"];

_heli setVariable ["fza_ah64_hmdfsmode",
	switch (_heli getVariable "fza_ah64_hmdfsmode") do {
		case "trans": {"cruise"};
		case "cruise": {"hover"};
		case "hover": {
			_heli setVariable ["fza_ah64_bobpos", [(getposasl _heli select 0), (getposasl _heli select 1)], true];
			_heli setVariable ["fza_ah64_bobhdg", getdir _heli, true];
			"bobup"
		};
		case "bobup": {"trans"};
	}
	, true];