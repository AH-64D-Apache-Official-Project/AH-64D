/* ----------------------------------------------------------------------------
Function: fza_fnc_coreScheduler

Description:
    Schedules updates to all tasks in *fza_ah64_schedarray* and performs missile guidance to all missiles in *fza_ah64_misguidearray*

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
    //missiles
    _miscounter = 0; {
        if (!(isnull(_x select 0))) then {
            [_heli, (_x select 0), (_x select 1), (_x select 2), (_x select 3), _miscounter, (_x select 5), (_x select 6), (_x select 7)] call fza_fnc_weaponMissileGuide;
        } else {
            fza_ah64_misguidearray set[_miscounter, -1];
            fza_ah64_misguidearray = fza_ah64_misguidearray - [-1];
        };
        _miscounter = _miscounter + 1;
    }
    foreach fza_ah64_misguidearray;
    fza_ah64_pf_daytime = daytime;
};