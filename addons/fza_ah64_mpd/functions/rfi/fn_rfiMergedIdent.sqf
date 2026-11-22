/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_rfiMergedIdent

Description:
    An FCR target symbol merged with an RFI emitter: its own ident with the emitter's type characters over the
    apex, registered in fza_dms_pointIdents the first time it is asked for

Parameters:
    _base  - the target's FCR ident
    _chars - [left, right] type modifier characters (fza_ase_fnc_rfiChars)

Returns:
    Ident, or _base if it is unknown

Examples:
    ["FCR_ADU_LOAL", ["S", "6"]] call fza_mpd_fnc_rfiMergedIdent

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_base", "_chars"];

private _ident = format ["%1_RFI_%2_%3", _base, _chars # 0, _chars # 1];
if (_ident in fza_dms_pointIdents) exitWith {_ident};
private _details = [_base] call fza_dms_fnc_pointGetIdentDetails;
if (isNil "_details") exitWith {_base};
_details = +_details;
_details set [4, [_chars # 0, [0.45, 0.28], "right", "center"]];
_details set [5, [_chars # 1, [0.55, 0.28], "left", "center"]];
fza_dms_pointIdents set [_ident, _details];
_ident
