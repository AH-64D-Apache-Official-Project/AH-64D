/* ----------------------------------------------------------------------------
Function: fza_fnc_fxMuzzle

Description:
    Runs the script in the "muzzleEffect" property of the ammo config. Used for launch / firing effects

Parameters:
	_amm - The ammo object to apply the ammo to.

Returns:
    Nothing

Examples:
	(begin example)
    [_ammo] call fza_fnc_fxMuzzle
    //Smoke / rocket launch / missile firing effect occurs.
	(end)

Author:
    unknown
---------------------------------------------------------------------------- */
private["_amm"];
_amm = _this select 4;
_this call(call compile GetText(configFile >> "CfgAmmo" >> _amm >> "muzzleEffect"));