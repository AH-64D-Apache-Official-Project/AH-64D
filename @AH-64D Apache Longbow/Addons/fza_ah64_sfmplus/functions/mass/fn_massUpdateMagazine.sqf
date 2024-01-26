
/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_massUpdateStation

Description:
    Updates the mass and moment of a wing station

Parameters:
    _heli - The helicopter to get information from [Unit].

Returns:
    ...

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

private _30mmMass = 0.35;  //kg - 103lbs (99lbs to 106lbs, average of 102.5lbs = 103lbs)
private _curAmmo  = 0;
private _magMass  = 0;
{
    _x params ["_magName","", "_magAmmo"];
    if (["m230", str _magName] call BIS_fnc_inString) then {
        private _magConfig = configFile >> "cfgMagazines" >> _magName;
        _curAmmo           = getNumber (_magConfig >> "count");
    };
} foreach magazinesAllTurrets _heli;

_magMass = _30mmMass * _curAmmo;

systemChat format ["Mag Ammo = %1 -- Mag Mass = %2 lbs (%3 kg)", _curAmmo, (_magMass * 2.20462) toFixed 1, _magMass toFixed 1];

_magMass;