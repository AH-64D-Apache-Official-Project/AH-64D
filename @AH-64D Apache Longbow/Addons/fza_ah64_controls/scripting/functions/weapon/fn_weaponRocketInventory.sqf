/* ----------------------------------------------------------------------------
Function: fza_fnc_weaponRocketInventory

Description:
    Gathers rocket inventory information, using given turret to work out whether it is selected or not.

Parameters:
    _heli - The helicopter that fired it

Returns:
    Array - [_rkt1, _rkt2, _rkt3, _rkt4, _rkt5]
    
    where _rktN is either [] or [_name, _qty, _pylons, _shortCode]
    _name - the name of the pylons

Examples:

Author:
    mattysmith22
---------------------------------------------------------------------------- */
params["_heli"];

_mags = getPylonMagazines _heli;

_inventory = [[], [], [], [], []];
#define WEP_TYPE(_mag) (if ((_mag) == "") then {""} else {getText (configFile >> "cfgMagazines" >> (_mag) >> "fza_pylonType")})
for "_pylon" from 0 to 12 step 4 do {
    for "_zone" from 0 to 3 do {
        _magName = _mags select (_pylon + _zone);
        if (WEP_TYPE(_magName) == "rocket") then {
            _ammoName = getText (configFile >> "CfgMagazines" >> _magName >> "ammo");
            _ammoQty = _heli ammoOnPylon (_pylon + _zone + 1);
            
            for "_i" from 0 to 4 do {
                if ((_inventory # _i) isEqualTo []) exitWith {
                    _ammoText = getText (configFile >> "CfgAmmo" >> _ammoName >> "fza_shortCode");
                    _inventory set [_i, [_ammoName, _ammoQty, [_pylon], _ammoText]];
                };
                if (_inventory # _i # 0 == _ammoName) exitWith {
                    _inventory # _i set [1, _ammoQty + _inventory # _i # 1];
                    _inventory # _i # 2 pushBackUnique _pylon;
                };
            };
        };
    };
};
_inventory;