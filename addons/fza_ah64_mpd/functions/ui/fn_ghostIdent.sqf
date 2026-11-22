/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_ghostIdent

Description:
    A threat symbol ghosted, at partial intensity: its ident with the colour dimmed, registered in
    fza_dms_pointIdents the first time it is asked for

Parameters:
    _base - the symbol's ident

Returns:
    Ident, or _base if it is unknown

Examples:
    ["RLWR_SA6_ACQ_TRK"] call fza_mpd_fnc_ghostIdent

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_base"];

private _ident = _base + "_GHOST";
if (_ident in fza_dms_pointIdents) exitWith {_ident};
private _details = [_base] call fza_dms_fnc_pointGetIdentDetails;
if (isNil "_details") exitWith {_base};
_details = +_details;
(_details # 3) params [["_r", 1], ["_g", 1], ["_b", 1], ["_a", 1]];
// As MPD_ICON_COLOR_YELLOW_DIM against MPD_ICON_COLOR_YELLOW
_details set [3, [_r * 0.55, _g * 0.55, _b * 0.55, _a]];
fza_dms_pointIdents set [_ident, _details];
_ident
