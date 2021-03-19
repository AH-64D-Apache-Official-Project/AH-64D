/* ----------------------------------------------------------------------------
Function: fza_fnc_coreScheduler

Description:
    Schedules updates to all tasks in *fza_ah64_schedarray*

Parameters:
    _heli - The helicopter to modify

Returns:
	Nothing

Examples:
	--- Code
    [_heli] call fza_fnc_coreScheduler
	---

Author:
	Unknown
---------------------------------------------------------------------------- */
if (!(isNil "fza_ah64_nopfsched")) exitwith {};
params["", "_heli", "_ticker"];
_heli = (vehicle player);
_ticker = 0.01;

if ((diag_ticktime - fza_ah64_overallticker) > _ticker && alive _heli && (player == driver _heli || player == gunner _heli) && count fza_ah64_schedarray > 0 && (vehicle player) isKindOf "fza_ah64base" && fza_ah64_pf_daytime < daytime) then {
    fza_ah64_overallticker = diag_ticktime; {
        [_heli] call _x;
    }
    foreach fza_ah64_schedarray;
    fza_ah64_pf_daytime = daytime;
};

_tickerSlow = 2;

if ((diag_ticktime - fza_ah64_overalltickerSlow) > _tickerSlow && alive _heli && (player == driver _heli || player == gunner _heli) && count fza_ah64_Slowschedarray > 0 && (vehicle player) isKindOf "fza_ah64base" && fza_ah64_pf_daytime_Slow < daytime) then {
    fza_ah64_overalltickerSlow = diag_ticktime; {
        [_heli] call _x;
    }
    foreach fza_ah64_Slowschedarray;
    fza_ah64_pf_daytime_Slow = daytime;
}; 