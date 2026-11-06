/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_fcrTgtDraw

Description:
    TGT on an FCR format: whether it is shown and selected, and the store status window,
    the target file address the next target is stored at and the ones stored
    since TGT was selected, the latest last.

Parameters:
    _heli     - The helicopter
    _mpdIndex - 0 left MPD, 1 right
    _state    - The FCR format's page state

Returns:
    Nothing

Examples:
    --- Code
    [_heli, _mpdIndex, _state] call fza_mpd_fnc_fcrTgtDraw
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
params ["_heli", "_mpdIndex", "_state"];

private _tgt = _state getOrDefault ["tgt", 0];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_TGT_MODE), _tgt];
// TGT is hidden until a scan has given targets to store (fza_mpd_fnc_fcrTgtHandleControl)
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_TGT_AVAIL), parseNumber (_tgt == 1 || {(_heli getVariable ["fza_ah64_fcrDisplayTargets", []]) isNotEqualTo []})];
if (_tgt == 0) exitWith {};

// Where fza_fnc_targetingStore stores the next one: the first free address, or the one it overwrites next
private _next = [_heli, POINT_TYPE_TG] call fza_dms_fnc_pointNextFree;
if (_next isEqualTo []) then {_next = [POINT_TYPE_TG, _heli getVariable ["fza_ah64_targetStoreOverwrite", 1]]};
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_TGT_NEXT), _next call fza_dms_fnc_pointToString];

private _stored = _state getOrDefault ["tgtStored", []];
_stored = _stored select [(count _stored - MFD_FCR_TGT_LIST_LINES) max 0, MFD_FCR_TGT_LIST_LINES];
for "_i" from 0 to MFD_FCR_TGT_LIST_LINES - 1 do {
    _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_TGT_LIST_1 + _i), _stored param [_i, ""]];
};
