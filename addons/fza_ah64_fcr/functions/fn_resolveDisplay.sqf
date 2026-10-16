/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_resolveDisplay

Description:
    Runs every frame to produce a display-ready target list from the raw scan
    data. A target's fresh data is revealed the moment the wiper crosses it
    (revealTime from fza_fcr_fnc_mergeTargets); before that it shows its last
    revealed picture. Expired ghosts and targets outside the commanded scan
    sector are dropped.

    Output variable fza_ah64_fcrDisplayTargets contains only targets that should
    currently be visible. Output variable fza_ah64_fcrDisplayCount is the number
    of live (non-ghost) targets in that list.

Parameters:
    _heli - The helicopter to act upon

Returns:
    Nothing. Writes fza_ah64_fcrDisplayTargets and fza_ah64_fcrDisplayCount.

Record format (8 elements):
    [pos, type, moving, obj, aziAngle, range, isGhost, paintedTime]
     0    1     2       3    4         5      6        7

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

if ((_heli getVariable ["fza_ah64_fcrDisplayFrame", -1]) == diag_frameNo) exitWith {};
_heli setVariable ["fza_ah64_fcrDisplayFrame", diag_frameNo];

_heli getVariable "fza_ah64_fcrState" params ["_fcrScanState", "_fcrScanStartTime"];
_heli getVariable "fza_ah64_fcrLastScan" params ["_scanDir", "_scanPos"];
private _fcrTargets    = _heli getVariable ["fza_ah64_fcrTargets", []];

private _displayTargets = [];
private _liveCount      = 0;
private _scanning       = _fcrScanState in [FCR_MODE_ON_SINGLE, FCR_MODE_ON_CONTINUOUS];
// Reveal freezes when the scan stops (state stamp); what the wiper never reached stays pending
private _refTime        = [_fcrScanStartTime, CBA_missionTime] select _scanning;
private _cycleLen       = ([_heli] call fza_fcr_fnc_getScanTiming) # 1;

private _fcrMode  = _heli getVariable "fza_ah64_fcrMode";
private _isAtm    = _fcrMode == FCR_DISP_MODE_ATM;
private _scanSize = _heli getVariable ["fza_ah64_fcrScanSize", 0];
private _halfCmd  = [[45, 22.5, 15, 7.5] select _scanSize, [180, 90, 45, 22.5] select _scanSize] select _isAtm;

{
    _x params ["_pos", "_type", "_moving", "_obj", "_aziAngle", "_elevAngle", "_range", "_revealOffset", ["_isGhostFlag", 0],
             ["_dispAzi", 0], ["_dispRange", 0], ["_dispPos", []], ["_lastSeenTime", 0], ["_ghostRemoveTime", 0], ["_revealTime", 1e9]];

    private _isGhost = (_isGhostFlag > 0);

    // No time purge — radar off persists the picture; scanning drops each ghost as the wiper re-covers it (removal time from mergeTargets)
    if (_isGhost && _scanning && CBA_missionTime >= _ghostRemoveTime) then { continue; };
    // ATM target data is purged at the start of each scan — no ghost persistence
    if (_isGhost && _scanning && _isAtm) then { continue; };

    // Painted time drives stale dimming
    private _painted = _revealTime;
    if (_isGhost || { _revealTime > _refTime }) then {
        // Wiper not there yet: hold the last revealed picture, or stay hidden if there is none
        if (_dispPos isEqualTo []) then { continue; };
        _pos      = _dispPos;
        _aziAngle = _dispAzi;
        _range    = _dispRange;
        _painted  = [_revealTime - _cycleLen, _lastSeenTime] select _isGhost;
    };

    // Outside the commanded scan sector: clear instantly.
    // Measured in the scan frame, so yawing the aircraft after a scan does not drop targets.
    if (_halfCmd < 180) then {
        private _relCmd = [(_scanPos getDir _pos) - _scanDir] call CBA_fnc_simplifyAngle180;
        if (abs _relCmd > _halfCmd + 1) then { continue; };
    };

    _displayTargets pushBack [_pos, _type, _moving, _obj, _aziAngle, _range, _isGhost, _painted];
    if (!_isGhost) then { _liveCount = _liveCount + 1; };
} forEach _fcrTargets;

_heli setVariable ["fza_ah64_fcrDisplayTargets", _displayTargets];
_heli setVariable ["fza_ah64_fcrDisplayCount",   _liveCount];
