/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_targetShown

Description:
    What an FCR target record shows at a time. Until the wiper crosses the
    target (its reveal time) it shows the previous scan's picture; from then
    this scan's: its position, bright or dim by its scanburst results
    (fza_fcr_fnc_mergeTargets), or nothing.

Parameters:
    _rec  - A fza_ah64_fcrTargets record
    _time - The time, CBA_missionTime

Returns:
    [pos, aziAngle, range, bright], or [] when not shown

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_rec", "_time"];
_rec params ["_pos", "", "", "", "_azi", "", "_range", "", "", "_revealTime", "_dispPos", "_dispAzi", "_dispRange", "_dispBright", "_bright", "_shown"];

if (_time < _revealTime) exitWith {
    [[_dispPos, _dispAzi, _dispRange, _dispBright], []] select (_dispPos isEqualTo [])
};
[[], [_pos, _azi, _range, _bright]] select _shown
