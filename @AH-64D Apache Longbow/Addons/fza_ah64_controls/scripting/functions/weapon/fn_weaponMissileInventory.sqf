/* ----------------------------------------------------------------------------
Function: fza_fnc_weaponRocketInventory

Description:
    Gathers rocket inventory information, using given turret to work out whether it is selected or not.

Parameters:
    _heli - The helicopter that fired it

Returns:
    Array - [_rkt1, _rkt2, _rkt3, _rkt4, _rkt5]
    
    where _rktN is either [] or [_name, _qty, _pylons, _tex]
    _name - the name of the pylons

Examples:

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
        }
    };
};
_inventory