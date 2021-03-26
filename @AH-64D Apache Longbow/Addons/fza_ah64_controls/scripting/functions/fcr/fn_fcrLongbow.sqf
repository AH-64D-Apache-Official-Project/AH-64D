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
            if (alive _x && !(_x in fza_ah64_fcrlist)) then {
                _distOffAxis = abs ([[_heli, (getposatl _heli select 0), (getposatl _heli select 1), (getposatl _x select 0), (getposatl _x select 1)] call fza_fnc_relativeDirection] call CBA_fnc_simplifyAngle180);

                if (_x == _heli) then {
                    _targetArray = _targetArray - [_x];
                };

                if ((_heli getVariable "fza_ah64_agmode" == AGMODE_GND || _heli getVariable "fza_ah64_agmode" == AGMODE_FNI) && (_distOffAxis > 60)) then {
                    _targetArray = _targetArray - [_x];
                };
                
                if (_heli getVariable "fza_ah64_agmode" == AGMODE_AIR && !((_x isKindOf "plane") || (_x isKindOf "helicopter"))) then {
                    _targetArray = _targetArray - [_x];
                };
                sleep 0.03;
            };
        }
        foreach _targetArray;

        {
            if (!(_x in fza_ah64_fcrlist)) then {
                fza_ah64_fcrlist = fza_ah64_fcrlist + [_x];
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
        /*
        {
            if (_x in fza_ah64_fcrlist && !(_X in _targetarray)) then {
                fza_ah64_fcrlist = fza_ah64_fcrlist - [_x];
            };
        }
        foreach fza_ah64_fcrlist;*/

    } else {
        fza_ah64_fcrlist = [];
    };
    sleep 2;
};