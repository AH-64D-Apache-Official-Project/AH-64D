/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_handleZoom

Description:
	Zooms in and out the TSD.

Parameters:
	_heli - The helicopter to act on
	_dir - The direction to zoom. *"IN"* or *"OUT"*

Returns:
	Nothing

Examples:
	--- Code
    [_heli] call fza_mpd_fnc_handleZoom
	---

Author:
	mattysmith22
---------------------------------------------------------------------------- */
params["_heli", "_dir"];

_heli setVariable ["fza_ah64_rangesetting", [[5000, 10000, 25000, 50000], _heli getVariable "fza_ah64_rangesetting", 5000] call fza_fnc_cycle];