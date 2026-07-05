#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

if ((_heli getVariable ["fza_ah64_fcrDisplayFrame", -1]) == diag_frameNo) exitWith {};
_heli setVariable ["fza_ah64_fcrDisplayFrame", diag_frameNo];

_heli getVariable "fza_ah64_fcrState" params ["_fcrScanState", "_fcrScanStartTime"];
private _fcrTargets    = _heli getVariable ["fza_ah64_fcrTargets", []];
private _lastFullCycle = _heli getVariable ["fza_ah64_fcrLastFullCycle", 0];

private _displayTargets = [];
private _liveCount      = 0;

{
    _x params ["_pos", "_type", "_moving", "_obj", "_aziAngle", "_elevAngle", "_range", "_revealOffset", "_isGhostFlag",
             ["_frozenAzi", 0], ["_frozenRange", 0], ["_frozenPos", []], ["_lastSeenTime", 0]];

    private _isGhost      = (_isGhostFlag > 0);
    private _beforeReveal = (_fcrScanState in [FCR_MODE_ON_SINGLE, FCR_MODE_ON_CONTINUOUS] && (CBA_missionTime - _lastFullCycle) < _revealOffset);

    if (_isGhost && ((CBA_missionTime - _lastSeenTime) >= 30) && !_beforeReveal) then { continue; };

    if (!_isGhost && _beforeReveal) then {
        if (count _x > 9) then {
            _aziAngle = _frozenAzi;
            _range    = _frozenRange;
            _pos      = _frozenPos;
        } else {
            continue;
        };
    };

    _displayTargets pushBack [_pos, _type, _moving, _obj, _aziAngle, _range, _isGhost];
    if (!_isGhost) then { _liveCount = _liveCount + 1; };
} forEach _fcrTargets;

_heli setVariable ["fza_ah64_fcrDisplayTargets", _displayTargets];
_heli setVariable ["fza_ah64_fcrDisplayCount",   _liveCount];
