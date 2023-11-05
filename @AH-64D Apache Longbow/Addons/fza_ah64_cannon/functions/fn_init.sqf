/* ----------------------------------------------------------------------------
Function: fza_cannon_fnc_init


Description:
    initilizes the values for the helicopter

Parameters:
    Heli: Object - The helicopter to modify

Returns:
    Nothing

Examples:
    [_heli] call fza_cannon_fnc_init

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

if (!(_heli getVariable ["fza_ah64_cannonInitialised", false]) && local _heli) then {
    _heli setVariable ["fza_ah64_cannonInitialised", true, true];

    _heli setVariable ["fza_ah64_burst_limit", 10];
};