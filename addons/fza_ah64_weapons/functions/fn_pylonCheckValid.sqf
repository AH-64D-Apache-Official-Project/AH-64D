/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_pylonCheckValid

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

//ensure the pylons are loaded on the gunner
if (local _heli) then {
    {
        _x params ["_pylId", "", "_pylTurr", "_pylMag", "_pylAmmo"];
        if (_pylTurr isNotEqualTo [0]) then {
            systemChat "Apache Pylon Issue: The pylons must be loaded from the gunner position, not the pilot. Attempting to move pylons to gunner...";
            [[_heli, _pylId, _pylMag, _pylAmmo], {
                params["_heli", "_pylId", "_pylMag", "_pylAmmo"];

                _heli setPylonLoadout [_pylId, _pylMag, true, [0]];
                _heli setAmmoOnPylon [_pylId, _pylAmmo];
            }] remoteExec ["call", crew _heli];
        };
    } foreach getAllPylonsInfo _heli;
};

_mags     = getPylonMagazines _heli;
_magTypes = _mags apply {WEP_TYPE(_x)};

if (fza_ah64_pylonsLastCheckMags isEqualTo _mags) exitWith {};

// On any pylon, either rockets, hellfires or none are selected. If both, remove rockets
for "_i" from 0 to 15 step 4 do {
    _primaryMagType = _magTypes # _i;
    _otherMags = [_magTypes # (_i+1), _magTypes # (_i+2), _magTypes # (_i+3)];
    if (_primaryMagType in ["rocket", "hellfire"]) then {
        {
            if (WEP_TYPE(_mags#(_i + _forEachIndex + 1)) in ["rocket","hellfire"] && WEP_TYPE(_mags#(_i + _forEachIndex + 1)) != _primaryMagType) then {
                _heli setPylonLoadout [_i + _forEachIndex + 2, "", true, [0]];
            };
        } forEach _otherMags;
    };
};

_mags     = getPylonMagazines _heli;
_magTypes = _mags apply {WEP_TYPE(_x)};

// Ensure all rocket zones have consistent munitions types
for "_i" from 0 to 15 step 4 do {
    if (_magTypes # _i == "rocket") then {
        private _zoneAmmoTypes = [];
        for "_j" from 0 to 3 do {
            private _mag = _mags # (_i + _j);
            if (_mag != "") then {
                _zoneAmmoTypes pushBackUnique (getText (configFile >> "CfgMagazines" >> _mag >> "ammo"));
            };
        };
        if (count _zoneAmmoTypes > 1) then {
            // Mixed types in zone - keep only the innermost consistent type
            for "_j" from 3 to 0 step -1 do {
                private _mag     = _mags # (_i + _j);
                private _ammoTpe = getText (configFile >> "CfgMagazines" >> _mag >> "ammo");
                if (_ammoTpe != _zoneAmmoTypes # 0) then {
                    _heli setPylonLoadout [_i + _j + 1, "", true, [0]];
                };
            };
        };
    };
};

fza_ah64_pylonsLastCheckMags = getPylonMagazines _heli;
