/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_pylonSetRockets

Description:
    grabs the pylon indexes for hellfire and sets them with pylonSetOwner
    
Parameters:
    _heli - The helicopter to swap pylons for
    _turret - The turret ID to swap pylons to

Returns:
    Nothing

Examples:
    [_heli, -1] call fza_weapons_fnc_pylonSetRockets

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_turret"];

if !(_turret == 0 || _turret == -1) then {};

private _rktPylonIndex = [];
private _rocketPylons = getAllPylonsInfo _heli select {
    _x params ["_pylId", "", "", "_pylMagName"];
    ("fza_275" in _pylMagName)
};
{
    _x params ["_pylId"];
    _rktPylonIndex pushBack _pylId;
} forEach _rocketPylons;

[_heli, _rktPylonIndex, [_turret]] call fza_weapons_fnc_pylonSetOwner;