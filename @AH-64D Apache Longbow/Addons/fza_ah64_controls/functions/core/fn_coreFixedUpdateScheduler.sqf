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

private _fixedTimeStep  = 0.02;

fza_ah64_currentTime    = diag_tickTime;
fza_ah64_deltaTime      = fza_ah64_currentTime - fza_ah64_previousTime;
fza_ah64_previousTime   = fza_ah64_currentTime;
fza_ah64_accumulator    = fza_ah64_accumulator + fza_ah64_deltaTime;

while {fza_ah64_accumulator >= _fixedTimeStep} do {
    
    [_heli] call fza_sfmplus_fnc_coreUpdate;

    fza_ah64_accumulator = fza_ah64_accumulator - _fixedTimeStep;
};