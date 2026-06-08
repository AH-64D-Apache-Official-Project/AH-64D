/*----------------------------------------------------------------------------
Function: fza_fcr_fnc_update

Description:
    Orchestrates a single FCR scan cycle: builds snapshot, merges targets,
    publishes results, and refreshes NTS.

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Author:
    BradMick, Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", ["_isFullCycle", true]];

private _fcrMode   = _heli getVariable "fza_ah64_fcrMode";
private _fcrAzBias = _heli getVariable ["fza_ah64_fcrAzBias", 0];

private _fcrTargets = [_heli, _fcrMode, _fcrAzBias] call fza_fcr_fnc_buildScanSnapshot;

private _eval = { if (_x#6 < 4000) then { _x#4 } else { _x#4 * -1 + 90 }; };
if (_fcrMode == 2) then {
    _eval = { if (_x#4 < 0) then { _x#4 * -1 } else { _x#4 }; };
};
_fcrTargets = [_fcrTargets, [], _eval, "ASCEND"] call BIS_fnc_sortBy;

if (_fcrMode == 1 || _fcrMode == 2) then {
    _fcrTargets = [_heli, _fcrTargets, _isFullCycle] call fza_fcr_fnc_mergeTargets;
};

_heli getVariable "fza_ah64_fcrLastScan" params ["_dir"];
[_heli, "fza_ah64_fcrLastScan", [direction _heli, getPosASL _heli, CBA_missionTime, _dir]] call fza_fnc_updateNetworkGlobal;

[_heli, "fza_ah64_fcrTargets", _fcrTargets] call fza_fnc_updateNetworkGlobal;

private _ntsObj  = (_heli getVariable "fza_ah64_fcrNts") # 0;
private _antsObj = _heli getVariable ["fza_ah64_fcrAnts", objNull];

private _ntsStillValid  = _ntsObj isNotEqualTo objNull && (_fcrTargets findIf { (_x # 3) isEqualTo _ntsObj } != -1);
private _antsStillValid = _antsObj isNotEqualTo objNull && (_fcrTargets findIf { (_x # 3) isEqualTo _antsObj } != -1);

if (!_ntsStillValid) then {
    [_heli, "fza_ah64_fcrNts", [objNull, [0,0,0], []]] call fza_fnc_updateNetworkGlobal;
    // Auto-assign only on the first scan (NTS never set) or when ANTS has also left the scan
    if (_isFullCycle && (_ntsObj isEqualTo objNull || !_antsStillValid)) then {
        [_heli] call fza_fcr_fnc_cycleNTS;
    };
};

// Update lastFullCycle after cycleNTS so its reveal-offset filter sees the previous cycle's elapsed time.
// Also refresh ANTS to the target right after the current NTS in the sorted list.
if (_isFullCycle) then {
    [_heli, "fza_ah64_fcrLastFullCycle", CBA_missionTime] call fza_fnc_updateNetworkGlobal;

    private _currentNtsObj = (_heli getVariable "fza_ah64_fcrNts") # 0;
    if (_currentNtsObj isNotEqualTo objNull && count _fcrTargets > 1) then {
        private _ntsIdx  = _fcrTargets findIf { (_x # 3) isEqualTo _currentNtsObj };
        private _newAnts = if (_ntsIdx != -1) then {
            _fcrTargets # ((_ntsIdx + 1) mod (count _fcrTargets min 16)) # 3
        } else { objNull };
        [_heli, "fza_ah64_fcrAnts", _newAnts] call fza_fnc_updateNetworkGlobal;
    };
};

[_heli] call fza_dms_fnc_ageShot;
