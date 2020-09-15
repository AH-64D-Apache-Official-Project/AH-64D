/* ----------------------------------------------------------------------------
Function: fza_fnc_mpdHandleZoom

Description:
	Zooms in and out the TSD.

Parameters:
	_heli - The helicopter to act on
	_dir - The direction to zoom. *"IN"* or *"OUT"*

Returns:
	Nothing

Examples:
	--- Code
    [_heli, "IN"] call fza_fnc_mpdHandleZoom
	---

Author:
	mattysmith22
---------------------------------------------------------------------------- */
params["_heli", "_dir"];

if(_dir == "IN") then {
	fza_ah64_rangesetting = (fza_ah64_rangesetting) * 2;
    if (fza_ah64_rangesetting == 0.00008) then {
        fza_ah64_rangesetting = 0.0001;
    };
    if (fza_ah64_rangesetting == 0.0004) then {
        fza_ah64_rangesetting = 0.0005;
    };
    if (fza_ah64_rangesetting == 0.002) then {
        fza_ah64_rangesetting = 0.001;
    };
} else {
	fza_ah64_rangesetting = (fza_ah64_rangesetting) * 0.5;
    if (fza_ah64_rangesetting == 0.00025) then {
        fza_ah64_rangesetting = 0.0002;
    };
    if (fza_ah64_rangesetting == 0.00005) then {
        fza_ah64_rangesetting = 0.00004;
    };
    if (fza_ah64_rangesetting == 0.00001) then {
        fza_ah64_rangesetting = 0.00002;
    };
}