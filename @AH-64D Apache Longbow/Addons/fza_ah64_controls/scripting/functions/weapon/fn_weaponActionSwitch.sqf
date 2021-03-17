/* ----------------------------------------------------------------------------
Function: fza_fnc_weaponActionSwitch

Description:
	Switches the player between different weapon types

Parameters:
    _heli - The helicopter to act upon

Returns:
	Nothing

Examples:
	--- Code
    [_heli] call fza_fnc_weaponActionSwitch
	---

Author:
	Unknown
---------------------------------------------------------------------------- */
params["_heli"];

if (!(player in _heli)) exitwith {};

_selectedweapon = 0;
_wpncounter = 1;
_emptywep = "";

//gun if none
if (_selectedweapon == 0 && !(currentweapon _heli == "fza_m230" || currentweapon _heli isKindOf ["fza_hydra70", configFile >> "CfgWeapons"] || currentweapon _heli isKindOf ["fza_hellfire", configFile >> "CfgWeapons"] || currentweapon _heli == "fza_atas_2")) then {
    if (_heli hasweapon "fza_m230") then {
        _heli selectweapon "fza_m230";
    };
    _selectedweapon = 1;
};

//rockets from gun
if ((currentweapon _heli == "fza_m230") && _selectedweapon == 0) then {
    {
        if (_x isKindOf ["fza_hydra70", configFile >> "CfgWeapons"]) then {
            _emptywep = _x;
        };
        if ((_x isKindOf ["fza_hydra70", configFile >> "CfgWeapons"]) && _heli ammo _x > 0 && _selectedweapon == 0) then {
            _selectedweapon = 1;
            _heli selectweapon _x;
        };
        if (_selectedweapon == 1) exitwith {};
        _wpncounter = _wpncounter + 1;
        if (_wpncounter >= count(weapons _heli)) then {
            _selectedweapon = 1;
            _heli selectweapon _emptywep;
        };
    }
    foreach(weapons _heli);
};

_wpncounter = 1;

//missiles from rockets
if (currentweapon _heli isKindOf ["fza_hydra70", configFile >> "CfgWeapons"] && _selectedweapon == 0) then {
    {
        if (_x isKindOf ["fza_hellfire", configFile >> "CfgWeapons"]) then {
            _emptywep = _x;
        };
        if ((_x isKindOf ["fza_hellfire", configFile >> "CfgWeapons"]) && _heli ammo _x > 0 && _selectedweapon == 0) then {
            _selectedweapon = 1;
            _heli selectweapon _x;
        };
        if (_selectedweapon == 1) exitwith {};
        _wpncounter = _wpncounter + 1;
        if (_wpncounter >= count(weapons _heli)) then {
            _selectedweapon = 1;
            _heli selectweapon _emptywep;
        };
    }
    foreach(weapons _heli);
};

_wpncounter = 1;

//ata from hellfire
if (currentweapon _heli isKindOf ["fza_hellfire", configFile >> "CfgWeapons"] && _heli hasweapon "fza_atas_2" && _selectedweapon == 0) then {
    _heli selectweapon "fza_atas_2";
    _selectedweapon = 1;
};

//lsr from ata
if (currentweapon _heli == "fza_atas_2" && _heli hasweapon "laserdesignator_mounted" && _selectedweapon == 0) then {
    if (_heli hasweapon "laserdesignator_mounted") then {
        _heli selectweapon "laserdesignator_mounted";
    };
    _selectedweapon = 1;
};

//lsr from hellfire
if (_selectedweapon == 0 && currentweapon _heli isKindOf ["fza_hellfire", configFile >> "CfgWeapons"] && _heli hasweapon "laserdesignator_mounted" && !(_heli hasweapon "fza_atas_2")) then {
    if (_heli hasweapon "laserdesignator_mounted") then {
        _heli selectweapon "laserdesignator_mounted";
    };
    _selectedweapon = 1;
};

//gun from lsr
if (currentweapon _heli == "laserdesignator_mounted" && _selectedweapon == 0) then {
    if (_heli hasweapon "fza_m230") then {
        _heli selectweapon "fza_m230";
    };
    _selectedweapon = 1;
};

//gun from ata
if (currentweapon _heli == "fza_atas_2" && _selectedweapon == 0) then {
    if (_heli hasweapon "fza_m230") then {
        _heli selectweapon "fza_m230";
    };
    _selectedweapon = 1;
};

//gun from hellfire
if (_selectedweapon == 0 && currentweapon _heli isKindOf ["fza_hellfire", configFile >> "CfgWeapons"] && !(_heli hasweapon "fza_atas_2")) then {
    if (_heli hasweapon "fza_m230") then {
        _heli selectweapon "fza_m230";
    };
    _selectedweapon = 1;
};