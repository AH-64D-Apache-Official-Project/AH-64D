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
    --- Code
	_ret = [_heli 0, "fuel"] call fza_fnc_mpdSetDisplay;
	// _ret => true
    ---

	--- Code
	_ret = [_heli 0, "tsd"] call fza_fnc_mpdSetDisplay;
	// _ret => false (left MPD can't show the TSD)
    ---

Author:
	mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\script_common.hpp"
params ["_heli", "_side", "_page"];

switch (_side) do {
	case 0 : {
		if (_page in ["off", "fail", "dms", "flt", "fuel", "wca", "wpn"]) then {
			(_heli getVariable ["fza_ah64_mpdPage", []]) set [0, _page
			];
			TRACE_1("Successfully managed to change page on left MPD to", _page);
			true;
		} else {
			WARNING(format["Failed to change page on left MPD to %1", _page]);
			false;
		};
	};
	case 1 : {
		if (_page in ["off", "fail", "ase", "dms", "eng", "fcr", "tsd", "wca"]) then {
			(_heli getVariable ["fza_ah64_mpdPage", []]) set [1, _page];
			TRACE_1("Successfully managed to change page on right MPD to", _page);
			true;
		} else {
			WARNING(format["Failed to change page on right MPD to %1", _page]);
			false;
		};
	};
	default {
		ERROR("Tried to change page of invalid MPD");
		false;
	};
};

