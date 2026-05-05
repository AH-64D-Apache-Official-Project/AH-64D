/*----------------------------------------------------------------------------
Function: fza_fcr_fnc_cycleNTS

Description:
    cycle the targeting system to the next FCR target

Parameters:
    _heli - the heli to act upon

Returns:
    Nothing
    
Examples:
    [_heli] call fza_fcr_fnc_cycleNTS;

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params["_heli"];

private _fcrTargets = _heli getVariable "fza_ah64_fcrTargets";
private _knownTargets = _fcrTargets select { (count _x) < 9 || (_x # 8) == 0 };
if (count _knownTargets == 0) then {
    [_heli, "fza_ah64_fcrNts", [objNull,[0,0,0]], []] call fza_fnc_updateNetworkGlobal;
} else {
    private _oldNts = _heli getVariable "fza_ah64_fcrNts";
    private _oldNts = _oldNts # 0;
    private _oldNtsIndex = _knownTargets findIf {_x # 3 == _oldNts};
    private _newNtsIndex = (_oldNtsIndex + 1) mod (count _knownTargets min 16);
    [_heli, "fza_ah64_fcrNts", [_knownTargets # _newNtsIndex # 3, _knownTargets # _newNtsIndex # 0, _knownTargets # _newNtsIndex]] call fza_fnc_updateNetworkGlobal;
};
