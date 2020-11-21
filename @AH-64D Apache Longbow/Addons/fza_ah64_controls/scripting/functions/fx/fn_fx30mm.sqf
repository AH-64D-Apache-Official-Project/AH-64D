/* ----------------------------------------------------------------------------
Function: fza_fnc_fx30mm

Description:
    Causes the camera shake when the 30mm cannon is fired

Parameters:
	_heli - The ammo object to apply the ammo to.

Returns:
    Nothing

Examples:
	--- Code
    [_heli] call fza_fnc_fxMuzzle
    //camera shakes if 30mm was fired 
	---

Author:
    unknown
---------------------------------------------------------------------------- */
private["_heli"];
_selWeapon = currentWeapon _heli;

// M230 SHAKE
if (_selWeapon == "fza_m230" || _selWeapon isKindOf ["fza_hellfire", configFile >> "CfgWeapons"] || _selWeapon isKindOf ["fza_hydra70", configFile >> "CfgWeapons"]) then {
    addCamShake[0.15, 2, 20];
};