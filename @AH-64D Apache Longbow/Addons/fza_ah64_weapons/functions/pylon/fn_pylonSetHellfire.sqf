/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_pylonSetHellfire

Description:
    grabs the pylon indexes for hellfire and sets them with pylonSetOwner
    
Parameters:
    _heli - The helicopter to swap pylons for
    _turret - The turret ID to swap pylons to

Returns:
    Nothing

Examples:
    [_heli, [1]] call fza_weapons_fnc_pylonSetHellfire

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_turret"];

if !(_turret == 0 || _turret == -1) then {};

private _hfPylonIndex = [];
private _HellfirePylons = getAllPylonsInfo _heli select {
    _x params ["_pylId", "", "", "_pylMagName"];
    ("fza_agm114" in _pylMagName)
};
{
    _x params ["_pylId"];
    _hfPylonIndex pushBack _pylId;
} forEach _HellfirePylons;

[_heli, _hfPylonIndex, _turret] call fza_weapons_fnc_pylonSetOwner;