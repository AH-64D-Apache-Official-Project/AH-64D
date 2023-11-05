/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_init

Description:
    initilizes the values for the helicopter

Parameters:
    Heli: Object - The helicopter to modify

Returns:
    Nothing

Examples:
    [_heli] call fza_hellfire_fnc_init

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

if (!(_heli getVariable ["fza_ah64_hellfireInitialised", false]) && local _heli) then {
    _heli setVariable ["fza_ah64_hellfireInitialised", true, true];
    
    _heli setVariable ["fza_ah64_hellfireTrajectory", "DIR", true];
};