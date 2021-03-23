/* ----------------------------------------------------------------------------
Function: fza_fnc_fcrLongbow

Description:
    Fire control Radar script that takes target from sens radar and adds it to 
    fza_ah64_targetlist & fza_ah64_fcrlist

Parameters:

Returns:
    Nothing
    
Examples:
    [_heli] spawn fza_fnc_fcrLongbow;

Author:
    Unknown
---------------------------------------------------------------------------- */
#define AGMODE_GND 0
#define AGMODE_AIR 1
#define AGMODE_FNI 2 //FCR Not Installed (FNI)

if (!(isNil "fza_ah64_nofcr")) exitwith {};
_heli = objNull;
_targetArray = [];
_detectchance = 0.00834;
_adaunit = false;
_datalinkArray = [];

while {
    (time > -1)
}
do {
    waituntil {
        (vehicle player) iskindof "fza_ah64base"
    };

    _heli = vehicle player;

    waitUntil {
        ((driver(vehicle player) == player || gunner(vehicle player) == player) && isengineon(vehicle player))
    };

    if (isVehicleRadarOn _heli && (_heli animationPhase "fcr_enable" == 1) && _heli getHit "radar" < 0.8) then {

        _datalinkArray = listRemoteTargets west;
        {
            _targetArray pushback(_x select 0);
        }
        foreach _datalinkArray;

        {
            if (_x == _heli) then {
                _targetArray = _targetArray - [_x];
            };
        }
        foreach _targetArray;

        {
            if (!(_x in fza_ah64_targetlist)) then {
                fza_ah64_targetlist = fza_ah64_targetlist + [_x];
                _heli reveal _x;
            };
        }
        foreach _targetArray;
        {
            if (!(_x in fza_ah64_fcrlist)) then {
                fza_ah64_fcrlist = fza_ah64_fcrlist + [_x];
            };
        }
        foreach _targetArray;
    } else {
        fza_ah64_fcrlist = [];
    };
    sleep 2;
};