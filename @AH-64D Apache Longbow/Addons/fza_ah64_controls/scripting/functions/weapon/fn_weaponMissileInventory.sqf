/* ----------------------------------------------------------------------------
Function: fza_fnc_weaponMissileInventory

Description:
    Gathers missile pylon information information.

Parameters:
    _heli - The helicopter to gather inventory information on

Returns:
    Array - [_msl1UL, _msl1UR, _msl1LL, _msl1LR, ... , _msl4LR] (size 16)
    
    where _mslNXX is the state of the current pylon:

    * "AMMO_NAME" where ammo is on that pylon
    * "" where there was a hellfire, but it has been shot (the HML is still there)
    * -1 where there is no hellfire and no  HML (on the WPN page a rail should not be shown)

Examples:
    (start code)
    //On an aircraft with a HML on pylons 2 and 3, with AGM-114Ks on the upper half and AGM-114L on the lower half
    _ret = [_heli] call fza_fnc_weaponMissileInventory
    //_ret => [-1,-1,-1,-1,"fza_agm114k","fza_agm114k","fza_agm114l","fza_agm114l","fza_agm114k","fza_agm114k","fza_agm114l","fza_agm114l",-1,-1,-1,-1]

    //The same aircraft as above, but with all the outboard rockets fired off
    _ret2 = [_heli] call fza_fnc_weaponMissileInventory
    \\_ret2 => [-1,-1,-1,-1,"","fza_agm114k","","fza_agm114l","","fza_agm114k","","fza_agm114l",-1,-1,-1,-1]
    (end)
Author:
	mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\pylons.h"
params["_heli"];

_mags = getPylonMagazines _heli;

_inventory = [];

for "_pylon" from PYLON_1 to PYLON_4 step PYLON_SIZE do {
    for "_hf" from PYLON_HF_UL to PYLON_HF_LR do {
        _magName = _mags select (_pylon + _hf);
        if (_magName != "") then {
            _ammoName = getText (configFile >> "CfgMagazines" >> _magName >> "ammo");
            _ammoQty = _heli ammoOnPylon PYLON_FROM_STANDARD(_pylon + _hf);
            _inventory pushBack (["", _ammoName] select (_ammoQty != 0));
        } else {
            _inventory pushBack -1;
        };
    };
};
_inventory