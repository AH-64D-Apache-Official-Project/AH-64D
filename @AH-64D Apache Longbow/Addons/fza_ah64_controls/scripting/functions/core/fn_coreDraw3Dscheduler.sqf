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
	mattysmith22, Rosd6(Dryden)
---------------------------------------------------------------------------- */
if (!(isNil "fza_ah64_nopfsched")) exitwith {};
params["", "_heli", "_ticker"];
_heli = (vehicle player);
_ticker = 2;

if !(alive _heli && (player == driver _heli || player == gunner _heli) && (vehicle player) isKindOf "fza_ah64base" && _heli getVariable ["fza_ah64_aircraftInitialised",false]) exitwith {};

{
    [_heli] call _x;
}
foreach fza_ah64_draw3Darray;
[_heli] spawn fza_fnc_playQuedAudio;

if ((diag_ticktime - fza_ah64_overallticker) > _ticker) then {
    fza_ah64_overallticker = diag_ticktime; 
    {
        [_heli] call _x;
    }
    foreach fza_ah64_draw3DarraySlow;
    [_heli] spawn fza_fnc_targetingSensorUpdate;
};

if (!(vehicle cameraOn isKindOf "fza_ah64base") || !(alive cameraon) || (driver _heli == player && !isNull curatorCamera)) then {
    1 cuttext["", "PLAIN"];
    2 cuttext["", "PLAIN"];
    3 cuttext["", "PLAIN"];
    4 cuttext["", "PLAIN"];
    fza_ah64_bweff ppEffectEnable false;
    fza_ah64_pnvsgreff ppEffectEnable false;
};