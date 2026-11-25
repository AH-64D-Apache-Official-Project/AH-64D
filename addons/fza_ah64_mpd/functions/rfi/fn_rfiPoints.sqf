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
    _layout  - (optional) code, [bearings from _heading] -> [[x, y], ...]: lays the symbols out, spread apart, in
               place of _place and _gap (fza_mpd_fnc_rectSpread)

Returns:
    [points, [[x, y, emitter index], ...], tracking emitters' bearings from _heading]

Examples:
    [_heli, "plt", {params ["_b"]; [0.5 + 0.36 * sin _b, 0.5 - 0.36 * cos _b]}] call fza_mpd_fnc_rfiPoints
    [_heli, "plt", {}, getDir _heli, 0, {[_this, [0.5, 0.75], [0.15, 0.85, 0.15, 0.85], 0.07] call fza_mpd_fnc_rectSpread}] call fza_mpd_fnc_rfiPoints

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
#include "\fza_ah64_dms\headers\constants.h"
params ["_heli", "_seat", "_place", ["_heading", getDir (_this # 0)], ["_gap", 12], ["_layout", {}]];

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

// Symbols too close together are spread apart, in bearing order: round a ring by bearing, or as _layout lays them out
private _rels  = _items apply {_x # 0};
private _ring  = _layout isEqualTo {};
private _drawn = if (_ring) then {[_rels, _gap] call fza_mpd_fnc_spreadBearings} else {_rels};
private _at    = if (_ring) then {_drawn apply {[_x] call _place}} else {_rels call _layout};
private _drawnOf = [];
_drawnOf resize count _emitters;
{_drawnOf set [_x # 1, [_drawn # _forEachIndex, _at # _forEachIndex]];} forEach _items;

{
    private _drawnAt = _drawnOf # _forEachIndex;
    if (isNil "_drawnAt") then {continue;};
    _drawnAt params ["_drawRel", "_pos"];
    // A tracking emitter's line runs to its symbol
    if ((_x # ASE_RFI_MODE) >= ASE_TRK && {!(_x # ASE_RFI_STALE)}) then {_tracks pushBack ((_drawRel + 360) % 360);};
    _pos params ["_sx", "_sy"];
    private _obj = _x # ASE_RFI_OBJ;
    _points append ([_x, _forEachIndex, !isNull _selected && {_obj isEqualTo _selected}, _blink, [_sx, _sy]] call fza_mpd_fnc_rfiSymbolPoints);
    _picks pushBack [_sx, _sy, _forEachIndex];
} forEach _emitters;

[_points, _picks, _tracks]
