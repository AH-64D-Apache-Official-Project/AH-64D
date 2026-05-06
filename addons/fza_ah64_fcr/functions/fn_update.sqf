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
params ["_heli"];

if ((player != driver _heli) && (isPlayer driver _heli)) exitWith {};

private _fcrMode   = _heli getVariable "fza_ah64_fcrMode";
private _fcrAzBias = _heli getVariable ["fza_ah64_fcrAzBias", 0];

// Build raw target records
private _fcrTargets = [_heli, _fcrMode, _fcrAzBias] call fza_fcr_fnc_buildScanSnapshot;

// Sort into scan display order
//   GTM: near (<4km) ascending relAzi; far descending relAzi
//   ATM: ascending absolute relAzi
private _eval = { if (_x#6 < 4000) then { _x#4 } else { _x#4 * -1 + 90 }; };
if (_fcrMode == 2) then {
    _eval = { if (_x#4 < 0) then { _x#4 * -1 } else { _x#4 }; };
};
_fcrTargets = [_fcrTargets, [], _eval, "ASCEND"] call BIS_fnc_sortBy;

// Merge with previous scan for persistence and aging
if (_fcrMode == 1 || _fcrMode == 2) then {
    _fcrTargets = [_heli, _fcrTargets] call fza_fcr_fnc_mergeTargets;
};

// Update last scan record first so _time is correct before targets arrive on remote machines
_heli getVariable "fza_ah64_fcrLastScan" params ["_dir"];
[_heli, "fza_ah64_fcrLastScan", [direction _heli, getPosASL _heli, CBA_missionTime, _dir]] call fza_fnc_updateNetworkGlobal;

// Publish merged target list
[_heli, "fza_ah64_fcrTargets", _fcrTargets] call fza_fnc_updateNetworkGlobal;

// Only refresh NTS if the current selection is no longer in the target list
private _ntsObj = (_heli getVariable "fza_ah64_fcrNts") # 0;
private _ntsStillValid = !(_ntsObj isEqualTo objNull) && (_fcrTargets findIf { (_x # 3) isEqualTo _ntsObj } != -1);
if (!_ntsStillValid) then {
    [_heli, "fza_ah64_fcrNts", [objNull, [0,0,0], []]] call fza_fnc_updateNetworkGlobal;
    [_heli] call fza_fcr_fnc_cycleNTS;
};

// Age fired shot records
[_heli] call fza_dms_fnc_ageShot;
