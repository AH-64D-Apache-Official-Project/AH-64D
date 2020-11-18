/* ----------------------------------------------------------------------------
Function: fza_fnc_weaponRocketInfo

Description:
    Gathers rocket inventory information, using given turret to work out whether it is selected or not.

Parameters:
    _heli - The helicopter that fired it

Returns:
    Array - [_rkt1, _rkt2, _rkt3, _rkt4, _rkt5]
    
    where _rktN is either [] or [_name, _qty, _pylons]
    _name - the name of the pylons

Examples:

Author:
	mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\pylons.h"
params["_heli"];

_mags = getPylonMagazines _heli;

_inventory = [[], [], [], [], []];

for "_pylon" from PYLON_1 to PYLON_4 step PYLON_SIZE do {
    for "_zone" from PYLON_ZONEA to PYLON_ZONEE do {
        _magName = _mags select _pylon + _zone;
        if (_magName != "") then {
            _ammoName = getText (configFile >> "CfgMagazines" >> _magName >> "ammo");
            _ammoQty = _heli ammoOnPylon PYLON_FROM_STANDARD(_pylon + _zone);
            
            for "_i" from 0 to 4 do {
                if (_inventory # _i isEqualTo []) exitWith {
                    _inventory set [_i, [_ammoName, _ammoQty, [_pylon]]]
                };
                if (_inventory # _i # 0 == _ammoName) exitWith {
                    _inventory # _i set [1, _ammoQty + _inventory # _i # 1];
                    _inventory # _i # 2 pushBackUnique _pylon;
                };
            };
        };
    };
};