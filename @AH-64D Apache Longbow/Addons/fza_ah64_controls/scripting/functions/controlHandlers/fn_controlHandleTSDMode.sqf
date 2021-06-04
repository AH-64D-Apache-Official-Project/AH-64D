/* ----------------------------------------------------------------------------
Function: fza_fnc_controlHandleTSDMode

Description:
    Switches between the two TSD modes - ATK and NAV - for the selected heli

Parameters:
    _heli - The helicopter to modify

Returns:
	Nothing

Examples:
	--- Code
    [_heli] call fza_fnc_controlHandleTSDMode
	---

Author:
	Unknown
---------------------------------------------------------------------------- */
params ["_heli"];
switch(_heli getVariable "fza_ah64_tsdmode") do {
	case "nav": {
		_heli setVariable ["fza_ah64_tsdmode", "atk"];
		[_heli] call fza_fnc_targetingVariable;
	};
	case "atk": {
		_heli setVariable ["fza_ah64_tsdmode", "nav"];
	};
}