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
switch(fza_ah64_tsdmode) do {
	case "nav": {
		fza_ah64_tsdmode = "atk";
	};
	case "atk": {
		fza_ah64_tsdmode = "nav";
	};
}