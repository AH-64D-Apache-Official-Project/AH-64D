/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_fcrTgtStore

Description:
    Stores an FCR target in the target file (fza_fnc_targetingStore) while TGT
    is selected, and lists its address in the store status window.

Parameters:
    _heli  - The helicopter
    _state - The FCR format's page state
    _pos   - The target's position, as the FCR displays it

Returns:
    Nothing

Examples:
    --- Code
    [_heli, _state, _pos] call fza_mpd_fnc_fcrTgtStore
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_state", "_pos"];

private _id = [_heli, _pos] call fza_fnc_targetingStore;
private _stored = _state getOrDefault ["tgtStored", []];
_stored pushBack (_id call fza_dms_fnc_pointToString);
_state set ["tgtStored", _stored];
