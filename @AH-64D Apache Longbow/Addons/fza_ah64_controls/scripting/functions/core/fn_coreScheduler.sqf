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
	mattysmith22, Rosd6(Dryden)
---------------------------------------------------------------------------- */
if (!(isNil "fza_ah64_nopfsched")) exitwith {};
params["", "_heli", "_ticker"];
_heli = (vehicle player);
_ticker = 2;


if (alive _heli && (player == driver _heli || player == gunner _heli) && (vehicle player) isKindOf "fza_ah64base") then {
    {
        [_heli] call _x;
    }
    foreach fza_ah64_schedarray;
};

if ((diag_ticktime - fza_ah64_overallticker) > _ticker && alive _heli && (player == driver _heli || player == gunner _heli) && count fza_ah64_slowschedarray > 0 && (vehicle player) isKindOf "fza_ah64base") then {
    fza_ah64_overallticker = diag_ticktime; 
    {
        [_heli] call _x;
    }
    foreach fza_ah64_slowschedarray;
    [_heli] spawn fza_fnc_fcrLongbow;
};

//radar general list start
_tickerSlow = 10;
_datalinkarray = [];

if ((diag_ticktime - fza_ah64_overalltickerSlow) > _tickerSlow && alive _heli && (player == driver _heli || player == gunner _heli) && (vehicle player) isKindOf "fza_ah64base") then {
    if (isVehicleRadarOn _heli && (_heli animationPhase "fcr_enable" == 1) && _heli getHit "radar" < 0.8) then {
        [] spawn {
            _datalinkarray = vehicles - allDead;
            {
                _adaunit = [_x] call fza_fnc_targetIsADA;
                if (!(_x isKindOf "helicopter" || _x isKindOf "plane" || _x isKindOf "car" || _x isKindOf "tank" || _x isKindOf "ship" || _x isKindOf "StaticCannon" || _adaunit)) then {
                    _datalinkarray = _datalinkarray - [_x];
                };
                sleep 0.10
            }
            foreach _dataLinkArray;
            fza_ah64_dataLinkArray = _datalinkarray
        };
    };
};
//radar general list end

if (!(vehicle cameraOn isKindOf "fza_ah64base") || !(alive cameraon) || (driver _heli == player && !isNull curatorCamera)) then {
    1 cuttext["", "PLAIN"];
    2 cuttext["", "PLAIN"];
    3 cuttext["", "PLAIN"];
    4 cuttext["", "PLAIN"];
    fza_ah64_bweff ppEffectEnable false;
    fza_ah64_pnvsgreff ppEffectEnable false;
};