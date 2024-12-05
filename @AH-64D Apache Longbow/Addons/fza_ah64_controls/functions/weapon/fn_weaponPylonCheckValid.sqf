/* ----------------------------------------------------------------------------
Function: fza_fnc_weaponPylonCheckValid

Description:
    Validates the loadouts on the pylons to make sure that it is valid.

    The following checks are done:

    * On any pylon, either rockets, hellfires or none are selected. If both, remove rockets
    * Ensure all rocket zones have consistent munitions types.

Parameters:
    _heli - The helicopter to validate

Returns:
    Nothing

Examples:
Author:
    mattysmith22
---------------------------------------------------------------------------- */
#define ANY(_arr, _pred) (( _arr ) findIf ( _pred ) != -1)
#define WEP_TYPE(_mag) (if ((_mag) == "") then {""} else {getText (configFile >> "cfgMagazines" >> (_mag) >> "fza_pylonType")})

params["_heli"];
_mags = getPylonMagazines _heli;
_magTypes = _mags apply {WEP_TYPE(_x)};

if (fza_ah64_pylonsLastCheckMags isEqualTo _mags) exitWith {};

// On any pylon, either rockets, hellfires or none are selected. If both, remove rockets
for "_i" from 0 to 15 step 4 do {
    _primaryMagType = _magTypes # _i;
    _otherMags = [_magTypes # (_i+1), _magTypes # (_i+2), _magTypes # (_i+3)];

    switch (true) do {
        case (_primaryMagType == ""): {
            if (ANY(_otherMags, {_x != ""})) then {
                systemChat "Apache Pylon Issue: In order to load items onto a pylon, the top pylon at a minimum must be populated";
                for "_indexToClear" from 1 to 4 do {
                    _heli setPylonLoadout[_i + _indexToClear, "", false, [0]];
                };
            };
        };
        case (_primaryMagType == "hellfire"): {
            if (ANY(_otherMags, {_x == "rocket"})) then {
                systemChat "Apache Pylon Issue: Your first pylon magazine was a hellfire, all subsequent pylons must be empty or hellfires";
                for "_j" from 1 to 3 do {
                    if (_magTypes # (_i+_j) == "rocket") then {
                        _heli setPylonLoadout[_i + _j + 1, "", false, [0]];
                    };
                };
            };
        };
        case (_primaryMagType == "rocket"): {
            if (ANY(_otherMags, {_x == "hellfire"})) then {
                systemChat "Apache Pylon Issue: Your first pylon magazine was a rocket, all subsequent pylons must be empty or rockets";
                for "_j" from 1 to 3 do {
                    if (_magTypes # (_i+_j) == "hellfire") then {
                        _heli setPylonLoadout[_i + _j + 1, "", false, [0]];
                    };
                };
            };
        };
        case (_primaryMagType == "auxTank"): {
            if (ANY(_otherMags, {_x != ""})) then {
                systemChat "Apache Pylon Issue: Your first pylon magazine is an Aux Tank, all subsequent pylons must be empty";
                for "_indexToClear" from 2 to 4 do {
                    _heli setPylonLoadout[_i + _indexToClear, "", false, [0]];
                };
            };
        };
    };
};

_mags = getPylonMagazines _heli;
_magTypes = _mags apply {WEP_TYPE(_x)};
    
_zoneA = [[0, 12], "_zoneA"];
_zoneB = [[1, 13], "_zoneB"];
_zoneC = [[4, 8], "_zoneA"];
_zoneD = [[5, 9], "_zoneB"];
_zoneE = [[2, 6, 10, 14], "_zoneE"];
_rocketZones = [_zoneA, _zoneB, _zoneC, _zoneD, _zoneE];

{
    _x params ["_indices", "_suffix"];
    _zoneAmmoType = -1;
    {
        _mag = _mags # _x;
        _ammo = getText (configFile >> "CfgMagazines" >> _mag >> "ammo");
        if (_magTypes # _x == "rocket") then {
            if (_zoneAmmoType isEqualTo -1) then {
                _zoneAmmoType = _ammo;
            } else {
                if !(_ammo isEqualTo _zoneAmmoType) then {
                    systemChat "Cannot mix rocket types within zones.";
                    _heli setPylonLoadout [_x+1, _zoneAmmoType + _suffix, false, [0]];
                };
            };
        };
    } forEach _indices;
} forEach _rocketZones;

//SFM Weight sim
[_heli] call fza_sfmplus_fnc_fuelSet;

fza_ah64_pylonsLastCheckMags = _mags;