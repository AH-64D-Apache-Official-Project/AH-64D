/*----------------------------------------------------------------------------
Function: fza_fcr_fnc_cycleNTS

Description:
    Cycles the NTS to the next known FCR target.

Parameters:
    _heli - The helicopter to act upon

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params["_heli"];

private _fcrTargets = _heli getVariable "fza_ah64_fcrTargets";

_heli getVariable "fza_ah64_fcrState"    params ["_fcrScanState", "_fcrScanStartTime"];
_heli getVariable "fza_ah64_fcrLastScan" params ["_dir", "_scanPos"];
private _fcrMode = _heli getVariable "fza_ah64_fcrMode";
private _fullCycle = [3.2, 6.4] select (_fcrMode == 2);
private _lastFullCycle = _heli getVariable ["fza_ah64_fcrLastFullCycle", 0];

private _knownTargets = _fcrTargets select {
    ((count _x) < 9 || (_x # 8) == 0)
    && (_fcrScanState == 0 || (CBA_missionTime - _lastFullCycle) >= (_x # 7) || count _x > 9)
};
if (count _knownTargets == 0) exitWith {
    [_heli, "fza_ah64_fcrNts", [objNull,[0,0,0],[]]] call fza_fnc_updateNetworkGlobal;
};

private _oldNts      = (_heli getVariable "fza_ah64_fcrNts") # 0;
private _oldNtsIndex = _knownTargets findIf { _x # 3 == _oldNts };
private _newNtsIndex = (_oldNtsIndex + 1) mod (count _knownTargets min 16);
[_heli, "fza_ah64_fcrNts", [_knownTargets # _newNtsIndex # 3, _knownTargets # _newNtsIndex # 0, _knownTargets # _newNtsIndex]] call fza_fnc_updateNetworkGlobal;
