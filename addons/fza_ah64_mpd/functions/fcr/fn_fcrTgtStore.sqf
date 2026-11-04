/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_fcrTgtStore

Description:
    Stores FCR targets in the target file (fza_fnc_targetingStore) while TGT
    is selected, and lists their addresses in the store status window. A
    target already stored since TGT was selected is not stored again. The
    target file is broadcast once, after all of them.

Parameters:
    _heli      - The helicopter
    _state     - The FCR format's page state
    _positions - The targets' positions, as the FCR displays them

Returns:
    Nothing

Examples:
    --- Code
    [_heli, _state, [_pos]] call fza_mpd_fnc_fcrTgtStore
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_state", "_positions"];

private _stored = _state getOrDefault ["tgtStored", []];
private _storedPos = _state getOrDefault ["tgtStoredPos", []];
private _count = count _stored;
{
    if (_x in _storedPos) then {continue};
    _storedPos pushBack _x;
    _stored pushBack (([_heli, _x, false] call fza_fnc_targetingStore) call fza_dms_fnc_pointToString);
} forEach _positions;
_state set ["tgtStored", _stored];
_state set ["tgtStoredPos", _storedPos];
if (count _stored == _count) exitWith {};

{
    private _value = _heli getVariable _x;
    if (!isNil "_value") then {_heli setVariable [_x, _value, true]};
} forEach ["fza_dms_targetsThreats", "fza_ah64_targetStoreOverwrite", "fza_ah64_targetStoreMsg"];
