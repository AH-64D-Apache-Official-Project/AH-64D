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

// Priority rank by FCR_TYPE value: ADU(5)→0, WHEELED(4)→1, TRACKED(3)→2, HELI(2)→3, FLYER(1)→4, UNKNOWN(0)→5
private _eval = {
    ([5, 4, 3, 2, 1, 0] select (_x # 1)) * 1000 + (if (_x#6 < 4000) then { _x#4 } else { _x#4 * -1 + 90 })
};
if (_fcrMode == 2) then {
    _eval = {
        ([5, 4, 3, 2, 1, 0] select (_x # 1)) * 1000 + abs (_x#4)
    };
};
_fcrTargets = [_fcrTargets, [], _eval, "ASCEND"] call BIS_fnc_sortBy;

if (_fcrMode == 1 || _fcrMode == 2) then {
    _fcrTargets = [_heli, _fcrTargets, _isFullCycle] call fza_fcr_fnc_mergeTargets;
};
if (count _fcrTargets > 16) then {
    _fcrTargets = _fcrTargets select [0, 16];
};

_heli getVariable "fza_ah64_fcrLastScan" params ["_dir"];
[_heli, "fza_ah64_fcrLastScan", [direction _heli, getPosASL _heli, CBA_missionTime, _dir]] call fza_fnc_updateNetworkGlobal;

[_heli, "fza_ah64_fcrTargets", _fcrTargets] call fza_fnc_updateNetworkGlobal;

if (_isFullCycle) then {
    private _cycleCount = (_heli getVariable ["fza_ah64_fcrFullCycleCount", 0]) + 1;
    [_heli, "fza_ah64_fcrFullCycleCount", _cycleCount] call fza_fnc_updateNetworkGlobal;

    if (_cycleCount >= 2) then {
        private _ntsObj        = (_heli getVariable "fza_ah64_fcrNts") # 0;
        private _ntsStillValid = _ntsObj isNotEqualTo objNull && (_fcrTargets findIf { (_x # 3) isEqualTo _ntsObj } != -1);

        if (!_ntsStillValid) then {
            [_heli, "fza_ah64_fcrNts", [objNull, [0,0,0], []]] call fza_fnc_updateNetworkGlobal;
            [_heli] call fza_fcr_fnc_cycleNTS;
        };
    };

    // lastFullCycle updated after cycleNTS so the reveal-offset filter sees the previous cycle's elapsed time
    [_heli, "fza_ah64_fcrLastFullCycle", CBA_missionTime] call fza_fnc_updateNetworkGlobal;
};

[_heli] call fza_dms_fnc_ageShot;
