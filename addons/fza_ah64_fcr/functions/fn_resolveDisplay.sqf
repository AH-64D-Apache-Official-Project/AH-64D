/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_resolveDisplay

Description:
    Runs every frame to produce a display-ready target list: what each target
    shows now (fza_fcr_fnc_targetShown), its last scan's result once the wiper
    has crossed it. Targets outside the commanded scan sector are dropped.

    The list only changes with a new target file or scan, the mode or scan size,
    or as a target's reveal comes due, so it is rebuilt only then, for reveals
    at most 15 times a second.

    Output variable fza_ah64_fcrDisplayTargets contains only targets that should
    currently be visible. Output variable fza_ah64_fcrDisplayCount is their
    number.

Parameters:
    _heli - The helicopter to act upon

Returns:
    Nothing. Writes fza_ah64_fcrDisplayTargets and fza_ah64_fcrDisplayCount.

Record format (7 elements):
    [pos, type, moving, obj, aziAngle, range, dim]
     0    1     2       3    4         5      6

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

if ((_heli getVariable ["fza_ah64_fcrDisplayFrame", -1]) == diag_frameNo) exitWith {};
_heli setVariable ["fza_ah64_fcrDisplayFrame", diag_frameNo];

private _targets  = _heli getVariable ["fza_ah64_fcrTargets", []];
private _lastScan = _heli getVariable ["fza_ah64_fcrLastScan", []];
private _fcrMode  = _heli getVariable "fza_ah64_fcrMode";
private _scanSize = _heli getVariable ["fza_ah64_fcrScanSize", 0];
(_heli getVariable ["fza_fcr_displayBuilt", [[], [], -1, -1, -1, -1]]) params ["_builtTargets", "_builtScan", "_builtMode", "_builtSize", "_nextReveal", "_builtAt"];
if ((_targets isEqualRef _builtTargets) && {(_lastScan isEqualRef _builtScan) && {_fcrMode == _builtMode && {_scanSize == _builtSize
    && {CBA_missionTime < _nextReveal || {CBA_missionTime - _builtAt < 1 / 15}}}}}) exitWith {};

_lastScan params ["_scanDir", "_scanPos"];

private _isAtm    = _fcrMode == FCR_DISP_MODE_ATM;
private _halfCmd  = [[45, 22.5, 15, 7.5] select _scanSize, [180, 90, 45, 22.5] select _scanSize] select _isAtm;

private _displayTargets = [];
private _next = 1e9;
{
    // The soonest reveal still to come
    if (CBA_missionTime < (_x # 9)) then {_next = _next min (_x # 9)};
    private _shown = [_x, CBA_missionTime] call fza_fcr_fnc_targetShown;
    if (_shown isEqualTo []) then { continue; };
    _shown params ["_pos", "_aziAngle", "_range", "_bright"];

    // Outside the commanded scan sector: clear instantly.
    // Measured in the scan frame, so yawing the aircraft after a scan does not drop targets.
    if (_halfCmd < 180) then {
        private _relCmd = [(_scanPos getDir _pos) - _scanDir] call CBA_fnc_simplifyAngle180;
        if (abs _relCmd > _halfCmd + 1) then { continue; };
    };

    _displayTargets pushBack [_pos, _x # 1, _x # 2, _x # 3, _aziAngle, _range, !_bright];
} forEach _targets;

_heli setVariable ["fza_fcr_displayBuilt", [_targets, _lastScan, _fcrMode, _scanSize, _next, CBA_missionTime]];
_heli setVariable ["fza_ah64_fcrDisplayTargets", _displayTargets];
_heli setVariable ["fza_ah64_fcrDisplayCount",   count _displayTargets];
