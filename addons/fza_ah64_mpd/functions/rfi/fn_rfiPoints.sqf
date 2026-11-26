/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_rfiPoints

Description:
    The RFI threat symbols as screen points for the HTML ASE page and TSD, each at its bearing, overlapping any others
    there

Parameters:
    _heli    - the helicopter
    _seat    - "plt" or "cpg", whose selected emitter is shown
    _place   - code, [bearing from _heading] -> [x, y]
    _heading - (optional) heading bearings are drawn from, defaults to the aircraft's

Returns:
    [points, [[x, y, emitter index], ...], tracking emitters' bearings from _heading]

Examples:
    [_heli, "plt", {params ["_b"]; [0.5 + 0.36 * sin _b, 0.5 - 0.36 * cos _b]}] call fza_mpd_fnc_rfiPoints

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
params ["_heli", "_seat", "_place", ["_heading", getDir (_this # 0)]];

private _emitters = _heli getVariable ["fza_ah64_ase_rfiEmitters", []];
private _selected = _heli getVariable ["fza_ah64_ase_rfiSel_" + _seat, objNull];
private _blink    = [] call fza_mpd_fnc_iconBlink;
private _points   = [];
private _picks    = [];
private _tracks   = [];

{
    private _bearing = [_heli, _x] call fza_ase_fnc_rfiBearing;
    if (_bearing isEqualTo []) then {continue;};
    private _rel = (((_bearing # 0) - _heading) % 360 + 360) % 360;
    // A tracking emitter's line runs to its symbol
    if ((_x # ASE_RFI_MODE) >= ASE_TRK && {!(_x # ASE_RFI_STALE)}) then {_tracks pushBack _rel;};
    ([_rel] call _place) params ["_sx", "_sy"];
    private _obj = _x # ASE_RFI_OBJ;
    _points append ([_x, _forEachIndex, !isNull _selected && {_obj isEqualTo _selected}, _blink, [_sx, _sy]] call fza_mpd_fnc_rfiSymbolPoints);
    _picks pushBack [_sx, _sy, _forEachIndex];
} forEach _emitters;

[_points, _picks, _tracks]
