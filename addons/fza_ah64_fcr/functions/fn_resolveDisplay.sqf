/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_resolveDisplay

Description:
    Runs every frame to produce a display-ready target list: what each target
    shows now (fza_fcr_fnc_targetShown), its last scan's result once the wiper
    has crossed it. Targets outside the commanded scan sector are dropped.

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

_heli getVariable "fza_ah64_fcrLastScan" params ["_scanDir", "_scanPos"];

private _isAtm    = (_heli getVariable "fza_ah64_fcrMode") == FCR_DISP_MODE_ATM;
private _scanSize = _heli getVariable ["fza_ah64_fcrScanSize", 0];
private _halfCmd  = [[45, 22.5, 15, 7.5] select _scanSize, [180, 90, 45, 22.5] select _scanSize] select _isAtm;

private _displayTargets = [];
{
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
} forEach (_heli getVariable ["fza_ah64_fcrTargets", []]);

_heli setVariable ["fza_ah64_fcrDisplayTargets", _displayTargets];
_heli setVariable ["fza_ah64_fcrDisplayCount",   count _displayTargets];
