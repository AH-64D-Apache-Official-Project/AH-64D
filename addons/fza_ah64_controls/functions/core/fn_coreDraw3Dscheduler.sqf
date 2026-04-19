/* ----------------------------------------------------------------------------
Function: fza_fnc_coreDraw3Dscheduler

Description:
    Schedules updates to all tasks in *fza_ah64_schedarray*

Parameters:
    _heli - The helicopter to modify

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_fnc_coreDraw3Dscheduler
    ---

Author:
    mattysmith22, Snow(Dryden)
---------------------------------------------------------------------------- */
if (!(isNil "fza_ah64_nopfsched")) exitWith {};
params["", "_heli", "_ticker"];
_heli = (vehicle player);
_ticker = 2;

if !(alive _heli && (player == driver _heli || player == gunner _heli) && (vehicle player) isKindOf "fza_ah64base" && _heli getVariable ["fza_ah64_aircraftInitialised",false]) exitWith {};

{
    [_heli] call _x;
}
forEach fza_ah64_draw3Darray;

if ((diag_tickTime - fza_ah64_overallticker) > _ticker) then {
    fza_ah64_overallticker = diag_tickTime; 
    {
        [_heli] call _x;
    }
    forEach fza_ah64_draw3DarraySlow;
    [_heli] spawn fza_fnc_targetingSensorUpdate;
};
