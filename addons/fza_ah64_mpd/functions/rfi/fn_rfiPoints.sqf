/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_rfiPoints

Description:
    The RFI threat symbols as screen points for fza_mpd_fnc_drawIcons or the HTML TSD

Parameters:
    _heli    - the helicopter
    _seat    - "plt" or "cpg", whose selected emitter is shown
    _place   - code, [bearing from _heading] -> [x, y]
    _heading - (optional) heading bearings are drawn from, defaults to the aircraft's
    _gap     - (optional) least bearing between two symbols, deg

Returns:
    [points, [[x, y, emitter index], ...], tracking emitters' bearings from _heading]

Examples:
    [_heli, "plt", {params ["_b"]; [0.5 + 0.36 * sin _b, 0.5 - 0.36 * cos _b]}] call fza_mpd_fnc_rfiPoints

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
#include "\fza_ah64_dms\headers\constants.h"
params ["_heli", "_seat", "_place", ["_heading", getDir (_this # 0)], ["_gap", 12]];

private _emitters = _heli getVariable ["fza_ah64_ase_rfiEmitters", []];
private _selected = _heli getVariable ["fza_ah64_ase_rfiSel_" + _seat, objNull];
private _blink    = [] call fza_mpd_fnc_iconBlink;
private _points   = [];
private _picks    = [];
private _tracks   = [];

// [bearing from _heading -180 to 180, emitter index]
private _items = [];
{
    private _bearing = [_heli, _x] call fza_ase_fnc_rfiBearing;
    if (_bearing isEqualTo []) then {continue;};
    private _rel = [(_bearing # 0) - _heading] call CBA_fnc_simplifyAngle180;
    _items pushBack [_rel, _forEachIndex];
} forEach _emitters;

// Symbols too close together are spread apart, in bearing order
private _drawn = [_items apply {_x # 0}, _gap] call fza_mpd_fnc_spreadBearings;
private _drawnOf = [];
_drawnOf resize count _emitters;
{_drawnOf set [_x # 1, _drawn # _forEachIndex];} forEach _items;

{
    private _drawRel = _drawnOf # _forEachIndex;
    if (isNil "_drawRel") then {continue;};
    // A tracking emitter's line runs to its symbol
    if ((_x # ASE_RFI_MODE) >= ASE_TRK && {!(_x # ASE_RFI_STALE)}) then {_tracks pushBack ((_drawRel + 360) % 360);};
    ([_drawRel] call _place) params ["_sx", "_sy"];
    private _obj = _x # ASE_RFI_OBJ;
    _points append ([_x, _forEachIndex, !isNull _selected && {_obj isEqualTo _selected}, _blink, [_sx, _sy]] call fza_mpd_fnc_rfiSymbolPoints);
    _picks pushBack [_sx, _sy, _forEachIndex];
} forEach _emitters;

[_points, _picks, _tracks]
