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
    [_heli, "IN"] call fza_mpd_fnc_handleZoom
	---

Author:
	mattysmith22
---------------------------------------------------------------------------- */
params["_heli", "_dir"];

_range = _heli getVariable "fza_ah64_rangesetting";
if(_dir == "IN") then {
	_range = (_range) * 2;
    if (_range == 0.00008) then {
        _range = 0.0001;
    };
    if (_range == 0.0004) then {
        _range = 0.0005;
    };
    if (_range == 0.002) then {
        _range = 0.001;
    };
} else {
	_range = (_range) * 0.5;
    if (_range == 0.00025) then {
        _range = 0.0002;
    };
    if (_range == 0.00005) then {
        _range = 0.00004;
    };
    if (_range == 0.00001) then {
        _range = 0.00002;
    };
};
_heli setVariable ["fza_ah64_rangesetting", _range];