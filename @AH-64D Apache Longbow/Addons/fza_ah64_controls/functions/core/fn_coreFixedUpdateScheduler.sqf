/* ----------------------------------------------------------------------------
Function: fza_fnc_coreFixedUpdatecheduler
Description:
    Provides a fixed time interval to smooth out physics calculations while also handling
    frame drops to ensure consistency.

Parameters:
    _heli - The helicopter to modify

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_fnc_coreFixedUpdateScheduler
    ---
Author:
    BradMick
---------------------------------------------------------------------------- */
if (!(isNil "fza_ah64_nopfsched")) exitwith {};
params["", "_heli"];
_heli = (vehicle player);

if !(alive _heli && (player == driver _heli || player == gunner _heli) && (vehicle player) isKindOf "fza_ah64base" && _heli getVariable ["fza_ah64_aircraftInitialised",false]) exitwith {};

fza_ah64_fixedTimeStepVal = 0.02;
fza_ah64_fixedTimeStep    = fza_ah64_fixedTimeStepVal * accTime;

fza_ah64_currentTime    = diag_tickTime;
fza_ah64_deltaTime      = fza_ah64_currentTime - fza_ah64_previousTime;
fza_ah64_previousTime   = fza_ah64_currentTime;
fza_ah64_accumulator    = fza_ah64_accumulator + fza_ah64_deltaTime;

while {fza_ah64_accumulator >= fza_ah64_fixedTimeStepVal} do {
    
    [_heli] call fza_sfmplus_fnc_coreFixedUpdate;

    fza_ah64_accumulator = fza_ah64_accumulator - fza_ah64_fixedTimeStepVal;
};