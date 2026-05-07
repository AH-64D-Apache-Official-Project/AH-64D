/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_resolveDisplay

Description:
    Runs every frame to produce a display-ready
    target list from the raw scan data. Applies the sweep reveal gate once here so
    no draw function needs reveal logic.

    Output variable fza_ah64_fcrDisplayTargets contains only targets that should
    currently be visible. Positions are already resolved (frozen world/polar for
    tracked targets before reveal, live positions after). Ghost targets aged past
    the sweep are excluded.

    Output variable fza_ah64_fcrDisplayCount is the number of live (non-ghost)
    targets in the display list — used for the FCR target counter on all pages.

Parameters:
    _heli - The helicopter to act upon

Returns:
    Nothing. Writes fza_ah64_fcrDisplayTargets and fza_ah64_fcrDisplayCount.

Record format (7 elements):
    [pos, type, moving, obj, aziAngle, range, isGhost]
     0    1     2      3    4         5      6

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

if ((_heli getVariable ["fza_ah64_fcrDisplayFrame", -1]) == diag_frameNo) exitWith {};
_heli setVariable ["fza_ah64_fcrDisplayFrame", diag_frameNo];

_heli getVariable "fza_ah64_fcrState" params ["_fcrScanState", "_fcrScanStartTime"];
private _fcrTargets    = _heli getVariable "fza_ah64_fcrTargets";
private _lastFullCycle = _heli getVariable ["fza_ah64_fcrLastFullCycle", 0];

private _displayTargets = [];
private _liveCount      = 0;

{
    _x params ["_pos", "_type", "_moving", "_obj", "_aziAngle", "_elevAngle", "_range", "_revealOffset", "_scanAge",
             ["_frozenAzi", 0], ["_frozenRange", 0], ["_frozenPos", []]];

    private _isGhost      = (_scanAge > 0);
    private _beforeReveal = (_fcrScanState != FCR_MODE_OFF && (CBA_missionTime - _lastFullCycle) < _revealOffset);

    // Age 3+ ghost: cleared once the sweep bar reaches its last-known position
    if (_isGhost && (_scanAge >= 3) && !_beforeReveal) then { continue; };

    if (!_isGhost && _beforeReveal) then {
        if (count _x > 9) then {
            // Tracked: hold at frozen position until bar sweeps past
            _aziAngle = _frozenAzi;
            _range    = _frozenRange;
            _pos      = _frozenPos;
        } else {
            continue; // Fresh: hidden until bar sweeps past
        };
    };

    _displayTargets pushBack [_pos, _type, _moving, _obj, _aziAngle, _range, _isGhost];
    if (!_isGhost) then { _liveCount = _liveCount + 1; };
} forEach _fcrTargets;

_heli setVariable ["fza_ah64_fcrDisplayTargets", _displayTargets];
_heli setVariable ["fza_ah64_fcrDisplayCount",   _liveCount];
