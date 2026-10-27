/*----------------------------------------------------------------------------
Function: fza_fcr_fnc_update

Description:
    The FCR's one update, made as each full scan cycle completes
    (fza_fcr_fnc_stateControl): builds the snapshot, correlates it with the
    previous scan's targets, publishes the results and refreshes the NTS.
    Nothing the FCR shows changes between updates. TPM keeps no target file.

Parameters:
    _heli  - The helicopter
    _cycle - Full cycles completed since the scan started

Returns:
    Nothing

fza_ah64_fcrLastScan record, the scan's snapshot, written only here: the FCR
formats draw against it, and moving the centerline leaves it as it is:
    [centerlineDir, scanPos, updateTime, noseDir]
     0              1        2           3

Author:
    BradMick, Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_cycle"];

private _fcrMode   = _heli getVariable "fza_ah64_fcrMode";
private _fcrAzBias = _heli getVariable ["fza_ah64_fcrAzBias", 0];

// Centerline = heading + azimuth bias: the scan frame the targets, the B-scope terrain and the previous centerline caret
// reference
private _lastScan = [(direction _heli + _fcrAzBias + 360) mod 360, getPosASL _heli, CBA_missionTime, direction _heli];

// TPM is a pilotage mode: no target file, no NTS
if (_fcrMode == FCR_DISP_MODE_TPM) exitWith {
    [_heli, "fza_ah64_fcrLastScan", _lastScan] call fza_fnc_updateNetworkGlobal;
    [_heli, "fza_ah64_fcrTargets", []] call fza_fnc_updateNetworkGlobal;
    [_heli, "fza_ah64_fcrNts", [objNull, [0,0,0], []]] call fza_fnc_updateNetworkGlobal;
    [_heli] call fza_dms_fnc_ageShot;
};

private _fcrTargets = [_heli, _fcrMode, _fcrAzBias] call fza_fcr_fnc_buildScanSnapshot;

if (_fcrMode in [FCR_DISP_MODE_GTM, FCR_DISP_MODE_ATM, FCR_DISP_MODE_RMAP]) then {
    _fcrTargets = [_heli, _fcrTargets, _fcrAzBias, _cycle] call fza_fcr_fnc_mergeTargets;
};

// Priority rank by FCR_TYPE value: ADU(5)→0, WHEELED(4)→1, TRACKED(3)→2, HELI(2)→3, FLYER(1)→4, UNKNOWN(0)→5; dim last
private _eval = {
    ([10000, 0] select (_x # 14)) + ([5, 4, 3, 2, 1, 0] select (_x # 1)) * 1000 + (if (_x#6 < 4000) then { _x#4 } else { _x#4 * -1 + 90 })
};
if (_fcrMode == FCR_DISP_MODE_ATM) then {
    _eval = {
        ([10000, 0] select (_x # 14)) + ([5, 4, 3, 2, 1, 0] select (_x # 1)) * 1000 + abs (_x#4)
    };
};
// The radar tracks FCR_TARGET_FILE targets in priority order: the FCR formats and the TSD nav phase show the top
// FCR_PAGE_NAV_PHASE_DISPLAY_TARGETS, the TSD attack phase all of them
_fcrTargets = ([_fcrTargets, [], _eval, "ASCEND"] call BIS_fnc_sortBy) select [0, FCR_TARGET_FILE];

[_heli, "fza_ah64_fcrLastScan", _lastScan] call fza_fnc_updateNetworkGlobal;
[_heli, "fza_ah64_fcrTargets", _fcrTargets] call fza_fnc_updateNetworkGlobal;

// The NTS stays while it is one of the top FCR_PAGE_NAV_PHASE_DISPLAY_TARGETS displayed, at the position shown,
// otherwise the next target is
_heli setVariable ["fza_ah64_fcrDisplayFrame", -1];
_heli call fza_fcr_fnc_resolveDisplay;
private _ntsObj  = (_heli getVariable "fza_ah64_fcrNts") # 0;
private _display = (_heli getVariable ["fza_ah64_fcrDisplayTargets", []]) select [0, FCR_PAGE_NAV_PHASE_DISPLAY_TARGETS];
private _dispIdx = if (isNull _ntsObj) then {-1} else {_display findIf {(_x # 3) isEqualTo _ntsObj}};
if (_dispIdx == -1) then {
    [_heli, "fza_ah64_fcrNts", [objNull, [0,0,0], []]] call fza_fnc_updateNetworkGlobal;
    [_heli] call fza_fcr_fnc_cycleNTS;
} else {
    private _ntsIdx = _fcrTargets findIf {(_x # 3) isEqualTo _ntsObj};
    [_heli, "fza_ah64_fcrNts", [_ntsObj, (_display # _dispIdx) # 0, _fcrTargets param [_ntsIdx, []]]] call fza_fnc_updateNetworkGlobal;
};

[_heli] call fza_dms_fnc_ageShot;
