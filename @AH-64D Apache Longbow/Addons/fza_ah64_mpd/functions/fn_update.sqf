/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_update

Description:
	Updates the MPDs inside the apache to show the correct visuals. Should be run regularly.

Parameters:
	_heli - the apache to show the correct values for.

Returns:
	Nothing.

Examples:
    --- Code
	[_heli] call fza_mpd_fnc_update
    ---

Author:
	mattysmith22
---------------------------------------------------------------------------- */
params ["_heli"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _lmpdCurr = [_heli, 0] call fza_mpd_fnc_currentPage;
private _rmpdCurr = [_heli, 0] call fza_mpd_fnc_currentPage;

private _mpdsHavePower = (_heli animationphase "plt_apu" > 0.5) || (_heli animationphase "plt_eng1_throttle" >= 0.5) || (_heli animationphase "plt_eng2_throttle" >= 0.5);

if (_mpdsHavePower && _lmpdCurr == "off") then {
	[_heli, 0, "eng"] call fza_mpd_fnc_setCurrentPage;
};
if (!_mpdsHavePower && _lmpdCurr != "off") then {
	[_heli, 0, "off"] call fza_mpd_fnc_setCurrentPage;
};

if (_mpdsHavePower && _rmpdCurr == "off") then {
	[_heli, 1, "fuel"] call fza_mpd_fnc_setCurrentPage;
};
if (!_mpdsHavePower && _rmpdCurr != "off") then {
	[_heli, 1, "off"] call fza_mpd_fnc_setCurrentPage;
};

(_heli getVariable "fza_mpd_mpdState") # 0 params ["", "", "_ldrawFunc", "_lState"];
(_heli getVariable "fza_mpd_mpdState") # 1 params ["", "", "_rdrawFunc", "_rState"];

[_heli,0,_lState] call _ldrawFunc;
[_heli,1,_rState] call _rdrawFunc;