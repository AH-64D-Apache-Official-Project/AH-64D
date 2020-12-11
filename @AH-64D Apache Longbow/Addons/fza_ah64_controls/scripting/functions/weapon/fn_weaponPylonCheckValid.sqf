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
#include "\fza_ah64_controls\headers\pylons.h"
#define ANY(_arr, _pred) (( _arr ) findIf ( _pred ) != -1)

params["_heli"];

_mags = getPylonMagazines _heli;

if (fza_ah64_pylonsLastCheckMags isEqualTo _mags) exitWith {};

// On any pylon, either rockets, hellfires or none are selected. If both, remove rockets
for "_i" from PYLON_1 to PYLON_4 step PYLON_SIZE do {
    if ( ANY(PYLON_MISSILES(_i) , {_mags # _x != ""}) && ANY(PYLON_ROCKETS(_i) , {_mags # _x != ""}) ) then {
        systemChat "Hellfires and rockets were doubled up on a pylon, correcting.";
        {
        _heli setPylonLoadout [PYLON_FROM_STANDARD(_x), "", false, [0]];
        } forEach (PYLON_ROCKETS(_i));
    };
};

_zoneA = [[PYLON_1 + PYLON_ZONEA, PYLON_4 + PYLON_ZONEA], "_zoneA"];
_zoneB = [[PYLON_1 + PYLON_ZONEB, PYLON_4 + PYLON_ZONEB], "_zoneB"];
_zoneC = [[PYLON_2 + PYLON_ZONEA, PYLON_3 + PYLON_ZONEA], "_zoneA"];
_zoneD = [[PYLON_2 + PYLON_ZONEB, PYLON_3 + PYLON_ZONEB], "_zoneB"];
_zoneE = [[PYLON_1 + PYLON_ZONEE, PYLON_2 + PYLON_ZONEE, PYLON_3 + PYLON_ZONEE, PYLON_4 + PYLON_ZONEE], "_zoneE"];
_rocketZones = [_zoneA, _zoneB, _zoneC, _zoneD, _zoneE];

{
    _x params ["_indices", "_suffix"];
    _zoneAmmoType = -1;
    {
        _mag = _mags # _x;
        _ammo = getText (configFile >> "CfgMagazines" >> _mag >> "ammo");
        if (_mags # _x != "") then {
            if (_zoneAmmoType isEqualTo -1) then {
                _zoneAmmoType = _ammo;
            } else {
                if !(_ammo isEqualTo _zoneAmmoType) then {
                    systemChat "Cannot mix rocket types within zones.";
                    _heli setPylonLoadout [PYLON_FROM_STANDARD(_x), _zoneAmmoType + _suffix, false, [0]];
                };
            };
        };
    } forEach _indices;
} forEach _rocketZones;

fza_ah64_pylonsLastCheckMags = _mags;