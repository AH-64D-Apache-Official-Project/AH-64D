/*----------------------------------------------------------------------------
Function: fza_fnc_targetingSensorCycle

Description:
    cycle the targeting system to the next FCR target

Parameters:
    _heli - the heli to act upon

Returns:
    Nothing
    
Examples:
    [_heli] call fza_fnc_targetingsensorCycle;

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params["_heli"];

private _fcrTargets = _heli getVariable "fza_ah64_fcrTargets";
if (count _fcrTargets == 0) then {
    _heli setVariable ["fza_ah64_fcrNts", [objNull,[0,0,0]], true];
} else {
    private _oldNts = _heli getVariable "fza_ah64_fcrNts";
    private _oldNts = _oldNts # 0;
    private _oldNtsIndex = _fcrTargets findIf {_x # 3 == _oldNts};
    private _newNtsIndex = (_oldNtsIndex + 1) mod count _fcrTargets;
    _heli setVariable ["fza_ah64_fcrNts", [_fcrTargets # _newNtsIndex # 3,_fcrTargets # _newNtsIndex # 0], true];
};
