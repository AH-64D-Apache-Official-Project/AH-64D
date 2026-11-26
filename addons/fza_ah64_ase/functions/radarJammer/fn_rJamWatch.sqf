/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_rJamWatch

Description:
    On the server: puts back what a radar jam turned off if whoever held it off never did,
    as when they disconnected during the jam. Checked a moment after the jam, extended or
    not, should have ended; the vehicle's owner then restores it (fza_ase_fnc_rJamEffect).

Parameters:
    _emitter: Object - The jammed vehicle

Returns:
    Nothing

Examples:
    [_emitter] remoteExecCall ["fza_ase_fnc_rJamWatch", 2]

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params [["_emitter", objNull, [objNull]]];

if (!isServer || {isNull _emitter} || {_emitter getVariable ["fza_ah64_rJamWatched", false]}) exitWith {};
_emitter setVariable ["fza_ah64_rJamWatched", true];

[
    {
        params ["_emitter"];
        isNull _emitter || {CBA_missionTime >= (_emitter getVariable ["fza_ah64_rJamUntil", -1]) + 2}
    },
    {
        params ["_emitter"];
        if (isNull _emitter) exitWith {};
        _emitter setVariable ["fza_ah64_rJamWatched", nil];
        private _restore = _emitter getVariable ["fza_ah64_rJamRestore", []];
        if (_restore isEqualTo [] || {!alive _emitter}) exitWith {};
        [_emitter, 0, _restore] remoteExecCall ["fza_ase_fnc_rJamEffect", _emitter];
    },
    [_emitter]
] call CBA_fnc_waitUntilAndExecute;
