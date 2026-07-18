#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

if ((_heli getVariable ["fza_ah64_fcrDisplayFrame", -1]) == diag_frameNo) exitWith {};
_heli setVariable ["fza_ah64_fcrDisplayFrame", diag_frameNo];

_heli getVariable "fza_ah64_fcrState" params ["_fcrScanState", "_fcrScanStartTime"];
private _fcrTargets    = _heli getVariable ["fza_ah64_fcrTargets", []];
private _lastFullCycle = _heli getVariable ["fza_ah64_fcrLastFullCycle", 0];

private _displayTargets = [];
private _liveCount      = 0;
private _scanning       = _fcrScanState in [FCR_MODE_ON_SINGLE, FCR_MODE_ON_CONTINUOUS];
// Reveal progress freezes at the moment the scan stops (state stamp) — targets the wiper
// never reached stay hidden instead of popping in when the scan is cancelled
private _revealRefTime  = [_fcrScanStartTime, CBA_missionTime] select _scanning;

// Commanded footprint — symbols outside it clear immediately (TM is silent; crew decision)
private _fcrMode  = _heli getVariable "fza_ah64_fcrMode";
private _isAtm    = _fcrMode == FCR_DISP_MODE_ATM;
private _scanSize = _heli getVariable ["fza_ah64_fcrScanSize", 0];
private _azBias   = _heli getVariable ["fza_ah64_fcrAzBias", 0];
private _halfCmd  = [[45, 22.5, 15, 7.5] select _scanSize, [180, 90, 45, 22.5] select _scanSize] select _isAtm;

{
    _x params ["_pos", "_type", "_moving", "_obj", "_aziAngle", "_elevAngle", "_range", "_revealOffset", "_isGhostFlag",
             ["_frozenAzi", 0], ["_frozenRange", 0], ["_frozenPos", []], ["_lastSeenTime", 0], ["_ghostRemoveTime", 0]];

    private _isGhost      = (_isGhostFlag > 0);
    private _beforeReveal = (_revealRefTime - _lastFullCycle) < _revealOffset;

    // No time purge — radar off persists the picture; scanning drops each ghost as the wiper re-covers it (removal time from mergeTargets)
    if (_isGhost && _scanning && CBA_missionTime >= _ghostRemoveTime) then { continue; };
    // TM 4.35.11: ATM target data is purged at the start of each scan — no ghost persistence
    if (_isGhost && _scanning && _isAtm) then { continue; };
    // Outside the commanded scan sector: clear instantly
    if (_halfCmd < 180) then {
        private _relNow = [(_heli getRelDir _pos) - _azBias] call CBA_fnc_simplifyAngle180;
        if (abs _relNow > _halfCmd + 1) then { continue; };
    };

    if (!_isGhost && _beforeReveal) then {
        // Only targets that completed a previous cycle have frozen data — fresh ones stay hidden until revealed
        if (_frozenPos isNotEqualTo []) then {
            _aziAngle = _frozenAzi;
            _range    = _frozenRange;
            _pos      = _frozenPos;
        } else {
            continue;
        };
    };

    // Field 7 = time the wiper painted the symbol (merge stamp + reveal offset) so stale dimming staggers per TM 4.44.4
    _displayTargets pushBack [_pos, _type, _moving, _obj, _aziAngle, _range, _isGhost, _lastSeenTime + _revealOffset];
    if (!_isGhost) then { _liveCount = _liveCount + 1; };
} forEach _fcrTargets;

_heli setVariable ["fza_ah64_fcrDisplayTargets", _displayTargets];
_heli setVariable ["fza_ah64_fcrDisplayCount",   _liveCount];
