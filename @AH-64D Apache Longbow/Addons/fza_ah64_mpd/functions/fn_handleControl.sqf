/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_handleControl

Description:
	Handles any mpd-related cockpit controls.
	
	Works out what MPD is currently open, and calls that respective page's handler

Parameters:
	_heli - The helicopter to act on
	_system - the name of the system that the touched control belongs to
	_control - the name of the control that has been touched

Returns:
	Nothing

Examples:
	--- Code
    [_heli, "lmpd", "r3"] call fza_mpd_fnc_handleControl
	---

Author:
	mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\script_common.hpp"
#include "\fza_ah64_controls\headers\selections.h"
params ["_heli", "_system", "_control"];

private _mpdIndex = [0,1] select (_system == "rmpd");

switch (_control) do {
	case "wpn": {
		[_heli, _mpdIndex, "wpn"] call fza_mpd_fnc_setCurrentPage;
	};
	case "tsd": {
		[_heli, _mpdIndex, "tsd"] call fza_mpd_fnc_setCurrentPage;
	};
	case "fcr": {
		[_heli, _mpdIndex, "fcr"] call fza_mpd_fnc_setCurrentPage;
	};
	case "ac": {
		private _curPage = [_heli, _mpdIndex] call fza_mpd_fnc_currentPage;
		if (_curPage == "eng") then {
			[_heli, _mpdIndex, "flt"] call fza_mpd_fnc_setCurrentPage;
		} else {
			[_heli, _mpdIndex, "eng"] call fza_mpd_fnc_setCurrentPage;
		};
	};
};

(_heli getVariable "fza_mpd_mpdState") # _mpdIndex params ["","","","_state", "_handleControl"];

[_heli, _mpdIndex, _control, _state] call _handleControl;