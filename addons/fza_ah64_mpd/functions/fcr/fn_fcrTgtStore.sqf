/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_fcrTgtStore

Description:
    Stores FCR targets in the target file (fza_fnc_targetingStore) while TGT
    is selected, and lists their addresses in the store status window. A
    target already stored since TGT was selected is not stored again, though
    a scan has moved it. The target file is broadcast once, after all of them.

Parameters:
    _heli    - The helicopter
    _state   - The FCR format's page state
    _targets - The targets as the FCR displays them, [position, target object]

Returns:
    Nothing

Examples:
    --- Code
    [_heli, _state, [[_pos, _target]]] call fza_mpd_fnc_fcrTgtStore
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_state", "_targets"];

private _stored = _state getOrDefault ["tgtStored", []];
private _storedTargets = _state getOrDefault ["tgtStoredTargets", []];
private _count = count _stored;
{
    _x params ["_pos", ["_target", objNull]];
    // The object while it has one, else where it is
    private _key = [_pos, _target] select (_target isEqualType objNull && {!isNull _target});
    if (_key in _storedTargets) then {continue};
    _storedTargets pushBack _key;
    _stored pushBack (([_heli, _pos, false] call fza_fnc_targetingStore) call fza_dms_fnc_pointToString);
} forEach _targets;
_state set ["tgtStored", _stored];
_state set ["tgtStoredTargets", _storedTargets];
if (count _stored == _count) exitWith {};

{
    private _value = _heli getVariable _x;
    if (!isNil "_value") then {_heli setVariable [_x, _value, true]};
} forEach ["fza_dms_targetsThreats", "fza_ah64_targetStoreOverwrite", "fza_ah64_targetStoreMsg"];
