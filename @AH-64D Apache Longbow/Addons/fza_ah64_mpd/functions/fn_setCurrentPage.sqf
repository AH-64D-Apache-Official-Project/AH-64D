/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_setCurrentPage

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
	_ret = [_heli 0, "fuel"] call fza_mpd_fnc_setCurrentPage;
	// _ret => true
    ---

	--- Code
	_ret = [_heli 0, "tsd"] call fza_mpd_fnc_setCurrentPage;
	// _ret => false (left MPD can't show the TSD)
    ---

Author:
	mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\script_common.hpp"
params ["_heli", "_side", "_page"];

// fza_mpd_mpdState = [[_pageName, _pageIndex, _drawFunc, _state],[again]]

private _mpdState = _heli getVariable "fza_mpd_mpdState";

private _config = configFile >> "CfgVehicles" >> typeof _heli >> "FzaMpdPages" >> _page;

if (!isClass _config) exitWith {
	["Invalid MPD page for %1 : %2", typeof _heli, _page] call BIS_fnc_error;
};

private _mfdIndex = 0;
if (isNumber (_config >> "index")) then {
	_mfdIndex = getNumber (_config >> "index");
};

private _drawFunc = {};
if (isText (_config >> "draw")) then {
	_drawFunc = missionNamespace getVariable getText (_config >> "draw");
};

private _handleControlFunc = {};
if (isText (_config >> "handleControl")) then {
	_handleControlFunc = missionNamespace getVariable getText (_config >> "handleControl");
};


private _state = createHashMap;
if (isClass (_config >> "InitState")) then {
	_stateCfg = configProperties [_config >> "InitState", "true", true];
	_state = createHashMapFromArray (_stateCfg apply {
		private _ret = nil;
		if (isNumber _x) then {_ret = getNumber _x};
		if (isText _x) then {_ret = getText _x};
		if (isArray _x) then {_ret = getArray _x};
		[configName _x, _ret];
	});
};

private _newState = [_page, _mfdIndex, _drawFunc, _state, _handleControlFunc];

_heli setUserMfdValue [_side + 1, _mfdIndex];
_mpdState set [_side, _newState];