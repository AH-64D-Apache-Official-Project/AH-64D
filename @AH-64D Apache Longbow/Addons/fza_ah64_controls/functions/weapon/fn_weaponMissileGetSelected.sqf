/* ----------------------------------------------------------------------------
Function: fza_fnc_weaponMissileGetSelected

Description:
    Returns the index of the missile that will be fired next, if the given ammo type is selected

Parameters:
    _heli - The helicopter to gather inventory information on

Returns:
    Array - [_msl1UL, _msl1UR, _msl1LL, _msl1LR, ... , _msl4LR] (size 16)
    
    where _mslNXX is the state of the current pylon:

    * "AMMO_NAME" where ammo is on that pylon
    * "" where there was a hellfire, but it has been shot (the HML is still there)
    * -1 where there is no hellfire and no  HML (on the WPN page a rail should not be shown)

Examples:
    //On an aircraft with a HML on pylons 2 and 3, with AGM-114Ks on the upper half and AGM-114L on the lower half
    _ret = [_heli] call fza_fnc_weaponMissileInventory
    //_ret => [-1,-1,-1,-1,"fza_agm114k","fza_agm114k","fza_agm114l","fza_agm114l","fza_agm114k","fza_agm114k","fza_agm114l","fza_agm114l",-1,-1,-1,-1]

    //The same aircraft as above, but with all the outboard rockets fired off
    _ret2 = [_heli] call fza_fnc_weaponMissileInventory
    \\_ret2 => [-1,-1,-1,-1,"","fza_agm114k","","fza_agm114l","","fza_agm114k","","fza_agm114l",-1,-1,-1,-1]
Author:
    mattysmith22
---------------------------------------------------------------------------- */
params ["_inventory", "_ammo"];
_priorities = [0,12,1,13,2,14,3,15,4,8,5,9,6,10,7,11];
_index = _priorities findIf {_inventory # _x isEqualTo _ammo};

if (_index == -1) exitWith {-1};
_priorities # _index