/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_rJamAcreSignal

Description:
    ACRE's signal for a received transmission, from the custom signal function that was
    there before ours (another mod's) or else ACRE's own, weakened by this player's radar
    jammer comms jamming (fza_ase_fnc_rJamComms).

Parameters:
    ACRE's custom signal function parameters: frequency, power, receiving and sending radio

Returns:
    Array - [signal 0-1, signal dBm]

Examples:
    [fza_ase_commsAcreWrapper] call acre_api_fnc_setCustomSignalFunc

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
// A mod that wraps ours in turn calls back into it; that call goes straight to ACRE's own
private _core = if (isNil "fza_ase_commsAcreBase" || {!isNil "fza_ase_commsAcreInside"}) then {
    _this call acre_sys_signal_fnc_getSignalCore
} else {
    fza_ase_commsAcreInside = true;
    private _signal = _this call fza_ase_commsAcreBase;
    fza_ase_commsAcreInside = nil;
    _signal
};

private _jam = missionNamespace getVariable ["fza_ase_commsAcreJam", 0];
if (_jam <= 0 || {!(_core isEqualType [])}) exitWith {_core};

_core params [["_px", 0, [0]], ["_maxSignal", -992, [0]]];
[(_px - _jam / 110) max 0, _maxSignal - _jam]
