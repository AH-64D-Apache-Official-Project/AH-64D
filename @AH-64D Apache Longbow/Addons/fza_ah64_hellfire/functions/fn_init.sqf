/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_init

Description:
    Initialize public variables on mission startup
    To set up information accessible by all crew members

Parameters:
     _heli - the helicopter upon which to execute the code

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