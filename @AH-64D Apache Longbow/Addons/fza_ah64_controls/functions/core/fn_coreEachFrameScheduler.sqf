/* ----------------------------------------------------------------------------
Function: fza_fnc_coreEachFramescheduler
Description:
    Schedules updates to all tasks in fza_ah64_eachFrameArray*
Parameters:
    _heli - The helicopter to modify
Returns:
    Nothing
Examples:
    --- Code
    [_heli] call fza_fnc_eachFrameScheduler
    ---
Author:
    mattysmith22, Snow(Dryden), BradMick
---------------------------------------------------------------------------- */
if (!(isNil "fza_ah64_nopfsched")) exitwith {};
params["", "_heli"];
_heli = (vehicle player);

if !(alive _heli && (player == driver _heli || player == gunner _heli) && (vehicle player) isKindOf "fza_ah64base" && _heli getVariable ["fza_ah64_aircraftInitialised",false]) exitwith {};

{
    [_heli] call _x;
}
foreach fza_ah64_eachFrameArray;