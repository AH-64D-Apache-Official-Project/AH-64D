/* ----------------------------------------------------------------------------
Function: fza_fnc_mpdUpdateMap

Description:
	Does the maths and animations to correctly line up the moving map on the right MPD.

	Note: it only does it for the seat the player is in.

Parameters:
	_heli - The helicopter to act on

Returns:
	Nothing

Examples:
	--- Code
    [_heli] call fza_fnc_mpdUpdateMap
	---

Author:
	Unknown, mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\selections.h"

params ["_heli"];
if (fza_ah64_tsdmap > 0) then {
	_heli setobjecttexture [SEL_MPD_PR_TSD_MMAP, fza_ah64_maplist select(fza_ah64_tsdmap - 1)];
	_heli setobjecttexture [SEL_MPD_PR_TSD_IMAP, "\fza_ah64_us\tex\mpd\tsd.paa"];
	_mapscale = 1 - ((_heli getVariable "fza_ah64_rangesetting") * (fza_ah64_mapsizearea / 8));
	_zoom = (1 - _mapscale) / (fza_ah64_mapsizearea * 2);
	_helidir = (1 / 360) * getdir _heli;
	_helixpos = _zoom * (getposasl _heli select 0);
	_heliypos = _zoom * (getposasl _heli select 1);
	if (player == driver _heli) then {
		_heli animate["mpd_pr_mmap_z", _helidir];
		_heli animate["mpd_pr_mmap_h", _helixpos];
		_heli animate["mpd_pr_mmap_v", _heliypos];
		_heli animate["mpd_pr_mmap_s1", _mapscale];
		_heli animate["mpd_pr_mmap_s2", _mapscale];
		_heli animate["mpd_pr_mmap_s3", _mapscale];
	};
	//cpg//
	if (player == gunner _heli) then {
		_heli setobjecttexture [SEL_MPD_GR_TSD_MMAP, fza_ah64_maplist select(fza_ah64_tsdmap - 1)];
		_heli animate["mpd_gr_mmap_z", _helidir];
		_heli animate["mpd_gr_mmap_h", _helixpos];
		_heli animate["mpd_gr_mmap_v", _heliypos];
		_heli animate["mpd_gr_mmap_s1", _mapscale];
		_heli animate["mpd_gr_mmap_s2", _mapscale];
		_heli animate["mpd_gr_mmap_s3", _mapscale];
	};
} else {
	_heli setobjecttexture [SEL_MPD_GR_TSD_MMAP, ""];
	_heli setobjecttexture [SEL_MPD_PR_TSD_MMAP, ""];
	_heli setobjecttexture [SEL_MPD_PR_TSD_IMAP, ""];
};
if (player == driver _heli) then {
	_heli animate["mpd_pl_obj1_v", 0.25];
	_heli animate["mpd_pl_obj1_h", 0.5];
	_heli animate["mpd_pl_obj1_z", 0.005];
};
if (player == gunner _heli) then {
	_heli animate["mpd_gr_obj1_v", 0.25];
	_heli animate["mpd_gr_obj1_h", 0.5];
	_heli animate["mpd_gr_obj1_z", 0.005];
};