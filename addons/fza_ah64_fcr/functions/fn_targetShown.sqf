/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_targetShown

Description:
    What an FCR target record shows at a time. Until the wiper crosses the
    target (its reveal time) it shows the previous scan's picture; from then
    the result of this scan's pass: the position it was detected at, or on a
    miss the position it was last shown at, bright or dim by scan-to-scan
    correlation (fza_fcr_fnc_mergeTargets). With its correlation gone, or
    never shown, it is not shown.

Parameters:
    _rec  - A fza_ah64_fcrTargets record
    _time - The time, CBA_missionTime

Returns:
    [pos, aziAngle, range, bright], or [] when not shown

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_rec", "_time"];
_rec params ["_pos", "", "", "", "_azi", "", "_range", "", "_memory", "_revealTime", "_dispPos", "_dispAzi", "_dispRange", "_dispBright", "_bright", "_lastHit"];

if (_time < _revealTime) exitWith {
    [[_dispPos, _dispAzi, _dispRange, _dispBright], []] select (_dispPos isEqualTo [])
};
// The correlation: a moving target's last scanburst of passes, or a stationary target's count
private _correlated = if (_memory isEqualType []) then {_memory findIf {_x} != -1} else {_memory > 0};
if (!_correlated) exitWith {[]};
if (_lastHit) exitWith {[_pos, _azi, _range, _bright]};
[[_dispPos, _dispAzi, _dispRange, _bright], []] select (_dispPos isEqualTo [])
