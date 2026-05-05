/*----------------------------------------------------------------------------
Function: fza_fcr_fnc_update

Description:
    Orchestrates a single FCR scan cycle update. Builds a fresh snapshot of
    sensor targets, sorts them into scan order, merges with the previous scan
    for GTM persistence, publishes the result, and refreshes NTS selection.

Parameters:
    _heli - the helicopter

Returns:
    Nothing

Examples:
    [_heli] call fza_fcr_fnc_update;

Author:
    BradMick, Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

if ((player != driver _heli) && (isPlayer driver _heli)) exitWith {};

private _fcrMode   = _heli getVariable "fza_ah64_fcrMode";
private _fcrAzBias = _heli getVariable ["fza_ah64_fcrAzBias", 0];

// 1. Build raw target records from the current sensor sweep
private _fcrTargets = [_heli, _fcrMode, _fcrAzBias] call fza_fcr_fnc_buildScanSnapshot;

// 2. Sort into scan display order
//    GTM: close targets (<4km) by ascending relAzi (L->R); far targets by descending (R->L)
//    ATM: by absolute relAzi (nearest to boresight first)
private _eval = { if (_x#6 < 4000) then { _x#4 } else { _x#4 * -1 + 90 }; };
if (_fcrMode == 2) then {
    _eval = { if (_x#4 < 0) then { _x#4 * -1 } else { _x#4 }; };
};
_fcrTargets = [_fcrTargets, [], _eval, "ASCEND"] call BIS_fnc_sortBy;

// 3. Merge with the previous scan for persistence, heading correction, and aging (GTM + ATM)
if (_fcrMode == 1 || _fcrMode == 2) then {
    _fcrTargets = [_heli, _fcrTargets] call fza_fcr_fnc_mergeTargets;
};

// 4. Publish the merged target list
[_heli, "fza_ah64_fcrTargets", _fcrTargets] call fza_fnc_updateNetworkGlobal;
if (count _fcrTargets == 0) then {
    _heli setVariable ["fza_ah64_fcrNts", [objNull, [0,0,0], []], true];
};

// 5. Update last scan record (direction stored twice: current and previous for heading delta)
_heli getVariable "fza_ah64_fcrLastScan" params ["_dir"];
[_heli, "fza_ah64_fcrLastScan", [direction _heli, getPosASL _heli, CBA_missionTime, _dir]] call fza_fnc_updateNetworkGlobal;

// 6. Auto-select NTS if null or if the current NTS target has aged out of known targets
private _ntsObj       = (_heli getVariable "fza_ah64_fcrNts") # 0;
private _knownTargets = _fcrTargets select { (count _x) < 9 || (_x # 8) == 0 };
if (_ntsObj isEqualTo objNull || (_knownTargets findIf { (_x # 3) isEqualTo _ntsObj }) == -1) then {
    _heli call fza_fcr_fnc_cycleNTS;
};

// 7. Age fired shot records
[_heli] call fza_dms_fnc_ageShot;
