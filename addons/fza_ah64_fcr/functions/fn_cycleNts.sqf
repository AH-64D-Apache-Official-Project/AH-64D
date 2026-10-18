/*----------------------------------------------------------------------------
Function: fza_fcr_fnc_cycleNTS

Description:
    Cycles the NTS to the next target the FCR is showing
    (fza_fcr_fnc_targetShown), at the position shown.

Parameters:
    _heli - The helicopter to act upon

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params["_heli"];

private _known = [];
{
    private _shown = [_x, CBA_missionTime] call fza_fcr_fnc_targetShown;
    if (_shown isNotEqualTo []) then {_known pushBack [_x, _shown # 0]};
} forEach (_heli getVariable "fza_ah64_fcrTargets");
if (_known isEqualTo []) exitWith {
    [_heli, "fza_ah64_fcrNts", [objNull,[0,0,0],[]]] call fza_fnc_updateNetworkGlobal;
};

private _oldNts      = (_heli getVariable "fza_ah64_fcrNts") # 0;
private _oldNtsIndex = _known findIf {(_x # 0 # 3) == _oldNts};
(_known # ((_oldNtsIndex + 1) mod (count _known min 16))) params ["_rec", "_pos"];
[_heli, "fza_ah64_fcrNts", [_rec # 3, _pos, _rec]] call fza_fnc_updateNetworkGlobal;
