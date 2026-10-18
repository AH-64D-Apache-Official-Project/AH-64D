/*----------------------------------------------------------------------------
Function: fza_fcr_fnc_update

Description:
    The FCR's one update, made as each full scan cycle completes
    (fza_fcr_fnc_stateControl): builds the snapshot, correlates it with the
    previous scan's targets, publishes the results and refreshes the NTS.
    Nothing the FCR shows changes between updates. TPM keeps no target file.

Parameters:
    _heli - The helicopter

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
params ["_heli"];

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
    _fcrTargets = [_heli, _fcrTargets, _fcrAzBias] call fza_fcr_fnc_mergeTargets;
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
_fcrTargets = [_fcrTargets, [], _eval, "ASCEND"] call BIS_fnc_sortBy;
if (count _fcrTargets > 16) then {
    _fcrTargets = _fcrTargets select [0, 16];
};

[_heli, "fza_ah64_fcrLastScan", _lastScan] call fza_fnc_updateNetworkGlobal;
[_heli, "fza_ah64_fcrTargets", _fcrTargets] call fza_fnc_updateNetworkGlobal;

// The NTS stays while it is still shown, at the position shown, otherwise the next target is
private _ntsObj = (_heli getVariable "fza_ah64_fcrNts") # 0;
private _ntsIdx = _fcrTargets findIf {(_x # 3) isEqualTo _ntsObj};
private _shown  = if (isNull _ntsObj || {_ntsIdx == -1}) then {[]} else {[_fcrTargets # _ntsIdx, CBA_missionTime] call fza_fcr_fnc_targetShown};
if (_shown isEqualTo []) then {
    [_heli, "fza_ah64_fcrNts", [objNull, [0,0,0], []]] call fza_fnc_updateNetworkGlobal;
    [_heli] call fza_fcr_fnc_cycleNTS;
} else {
    [_heli, "fza_ah64_fcrNts", [_ntsObj, _shown # 0, _fcrTargets # _ntsIdx]] call fza_fnc_updateNetworkGlobal;
};

[_heli] call fza_dms_fnc_ageShot;
