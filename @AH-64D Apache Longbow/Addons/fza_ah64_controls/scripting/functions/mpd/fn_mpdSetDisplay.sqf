/* ----------------------------------------------------------------------------
Function: fza_fnc_mpdSetDisplay

Description:
	Sets the display on each page.

Parameters:
	_heli - the apache to show the correct values for.
	_side - 0 for left MPD, 1 for right MPD
	_page - page name

Returns:
	True if change was made, false if not.

Examples:
    (begin example)
	_ret = [_heli 0, "fuel"] call fza_fnc_mpdSetDisplay;
	// _ret => true
    (end)

	(begin example)
	_ret = [_heli 0, "tsd"] call fza_fnc_mpdSetDisplay;
	// _ret => false (left MPD can't show the TSD)
    (end)

Author:
	mattysmith22
---------------------------------------------------------------------------- */
params ["_heli", "_side", "_page"];

switch (_side) do {
	case 0 : {
		if (_side in ["off", "fail", "dms", "flt", "fuel", "wca", "wpn"]) then {
			_heli setVariable ["fza_ah64_mpdPage", (_heli getVariable "fza_ah64_mpdPage") set [0, _page]];
			true;
		} else {false};
	};
	case 1 : {
		if (_side in ["off", "fail", "ase", "dms", "eng", "fcr", "tsd", "wca"]) then {
			_heli setVariable ["fza_ah64_mpdPage", (_heli getVariable "fza_ah64_mpdPage") set [1, _page]];
			true;
		} else {false};
	};
	default {
		false
	};
};

