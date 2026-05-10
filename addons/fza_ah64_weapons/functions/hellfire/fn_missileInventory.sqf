/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_MissileInventory

Description:
    Gathers missile pylon information for all 16 HML stations.

Parameters:
    _heli - The helicopter to gather inventory information on

Returns:
    Array of 16 elements [_msl1UL, _msl1UR, _msl1LL, _msl1LR, ... _msl4LR]
    Each element is:
      "AMMO_NAME" - live missile on that station
      ""          - HML present but missile expended
      -1          - no HML on that station

Examples:
    //Aircraft with HML on pylons 2 and 3, AGM-114Ks upper, AGM-114Ls lower
    _ret = [_heli] call fza_weapons_fnc_MissileInventory
    //_ret => [-1,-1,-1,-1,"fza_agm114k","fza_agm114k","fza_agm114l","fza_agm114l",...]

Author:
    mattysmith22
---------------------------------------------------------------------------- */
params ["_heli"];

_mags      = getPylonMagazines _heli;
_inventory = [];

#define WEP_TYPE(_mag) (if ((_mag) == "") then {""} else {getText (configFile >> "cfgMagazines" >> (_mag) >> "fza_pylonType")})
for "_pylon" from 0 to 15 step 4 do {
    for "_hf" from 0 to 3 do {
        _magName = _mags select (_pylon + _hf);
        if (WEP_TYPE(_magName) == "hellfire") then {
            _ammoName = getText (configFile >> "CfgMagazines" >> _magName >> "ammo");
            _ammoQty  = _heli ammoOnPylon (_pylon + _hf + 1);
            _inventory pushBack (["", _ammoName] select (_ammoQty != 0));
        } else {
            _inventory pushBack -1;
        };
    };
};
_inventory
