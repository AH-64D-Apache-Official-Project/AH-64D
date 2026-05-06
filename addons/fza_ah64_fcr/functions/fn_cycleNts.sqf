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
private _knownTargets = _fcrTargets select { (count _x) < 9 || (_x # 8) == 0 };
if (count _knownTargets == 0) exitWith {
    [_heli, "fza_ah64_fcrNts", [objNull,[0,0,0],[]]] call fza_fnc_updateNetworkGlobal;
};

private _oldNts      = (_heli getVariable "fza_ah64_fcrNts") # 0;
private _oldNtsIndex = _knownTargets findIf { _x # 3 == _oldNts };
private _newNtsIndex = (_oldNtsIndex + 1) mod (count _knownTargets min 16);
[_heli, "fza_ah64_fcrNts", [_knownTargets # _newNtsIndex # 3, _knownTargets # _newNtsIndex # 0, _knownTargets # _newNtsIndex]] call fza_fnc_updateNetworkGlobal;
