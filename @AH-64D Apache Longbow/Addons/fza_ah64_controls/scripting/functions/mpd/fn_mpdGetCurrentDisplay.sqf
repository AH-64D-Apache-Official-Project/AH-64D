/* ----------------------------------------------------------------------------
Function: fza_fnc_mpdGetCurrentDisplay

Description:
	Gets the displays that are being displayed on the MPDs

Parameters:
	_heli - the apache to show the correct values for.

Returns:
	[_leftMpd, _rightMpd]
	The two MPDs that are being displayed.

Examples:
    --- Code
	_ret = [_heli, 0] call fza_fnc_mpdGetCurrentDisplay;
	// _ret => "fuel"
    ---

	--- Code
	_ret = [_heli, 1] call fza_fnc_mpdGetCurrentDisplay;
	// _ret => "eng"
	---
Author:
	mattysmith22
---------------------------------------------------------------------------- */
params ["_heli", "_side"];

(_heli getVariable "fza_ah64_mpdPage") # _side