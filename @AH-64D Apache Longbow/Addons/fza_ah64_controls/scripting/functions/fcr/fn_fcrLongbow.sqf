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

                if ((_heli getVariable "fza_ah64_agmode" == AGMODE_GND) && (_distOffAxis > 45)) then {
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

/****
[] spawn  
{ 
 runLoop = true; 
 while {runLoop} do  
 { 
    _targetList     = [];
    _targetListSize = 0;
    _targetList = (listRemoteTargets west select {_x # 1 > 6 && _x # 0 != vehicle player}) apply {_x # 0};
    _targetListSize = count _targetList;
    hintSilent format [ "Array Size = %1\n
                        Item Name = %2\n
                        Item Name = %3\n
                        Item Name = %4\n",
                        _targetListSize, _targetList select 0, _targetList select 1, _targetList select 2];
    sleep 0.03; 
 } 
};
[] spawn  
{ 
 runLoop = true; 
 while {runLoop} do  
 { 
    _targetList     = [];
    _targetListSize = 0;
    _dataLinkArray = listRemoteTargets west;
    {
        if ((_x select 1) > 6) then
        {
            _targetList pushBack(_x);
        }
    }
    foreach _dataLinkArray;
    _targetListSize = count _targetList;
    hintSilent format [ "Array Size = %1\n
                        Item Name = %2\n
                        Item Name = %3\n
                        Item Name = %4\n
                        Test = %5",
                        _targetListSize, _targetList select 0, _targetList select 1, _targetList select 2, _targetList select 0 select 1];
    _targetList deleteRange [0, _targetListSize];
    sleep 0.03; 
 } 
};
****/