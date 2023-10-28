/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_pylonSetRocket

Description:
    grabs the pylon indexes for hellfire and sets them with pylonSetOwner
    
Parameters:
    _heli - The helicopter to swap pylons for
    _turret - The turret ID to swap pylons to

Returns:
    Nothing

Examples:
    [_heli, [-1]] call fza_weapons_fnc_pylonSetRocket

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_turret"];

if !(_turret in [[0]] || _turret in [[-1]]) then {};

private _rktPylonIndex = [];
private _rocketPylons = getAllPylonsInfo _heli select {
    _x params ["_pylId", "", "", "_pylMagName"];
    ("fza_275" in _pylMagName)
};
{
    _x params ["_pylId"];
    _rktPylonIndex pushBack _pylId;
} forEach _rocketPylons;

[_heli, _rktPylonIndex, _turret] call fza_weapons_fnc_pylonSetOwner;