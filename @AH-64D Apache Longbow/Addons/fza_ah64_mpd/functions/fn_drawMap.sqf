/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_drawMap

Description:
	Does the maths and animations to correctly line up the moving map on the right MPD.

	Note: it only does it for the seat the player is in.

Parameters:
	_heli - The helicopter to act on

Returns:
	Nothing

Examples:
	--- Code
    [_heli] call fza_mpd_fnc_drawMap
	---

Author:
	Unknown, mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\selections.h"

params ["_heli"];
/*
if !(player == driver _heli || player == gunner _heli) exitWith {};
_seat = ["cpg", "plt"] select (player == driver _heli);

if (fza_ah64_tsdmap > 0) then {
	_map = configFile >> "CfgWorlds" >> worldName >> "pictureMap";
	if (isText _map) then {
		_map = getText _map;
	} else {
		_map = "\fza_ah64_US\tex\mpd\notfound_2.paa";
	};

	_heli setobjecttexture [SEL_PR_MPD_BACK, _map];
	_heli setobjecttexture [SEL_MPD_PR_TSD_IMAP, "\fza_ah64_us\tex\mpd\tsd.paa"];
	_size = [] call BIS_fnc_mapSize;
	_heli animateSource [_seat+"_mmap_tx", - (0.5 - (getPos _heli # 0) / _size), true];
    _heli animateSource [_seat+"_mmap_ty", - (0.75 - (1 - (getPos _heli # 1) / _size)), true];
	_heli animateSource [_seat+"_mmap_r", direction _heli % 360, true];
	_heli animateSource [_seat+"_mmap_sc", (1/(_heli getVariable "fza_ah64_rangesetting"))/_size , true];
} else {
	_heli setobjecttexture [SEL_PR_MPD_BACK, "\fza_ah64_us\tex\mpd\tsd-b.paa"];
	_heli setobjecttexture [SEL_MPD_PR_TSD_IMAP, "\fza_ah64_us\tex\mpd\tsd.paa"];
	_heli animateSource [_seat+"_mmap_tx", 0, true];
    _heli animateSource [_seat+"_mmap_ty", 0, true];
	_heli animateSource [_seat+"_mmap_r", 0, true];
	_heli animateSource [_seat+"_mmap_sc", 1 , true];
};
*/