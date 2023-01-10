/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_pylonSetOwner

Description:
	Updates a pylon to be on a respective turret.
	
Parameters:
	_heli - The helicopter to swap pylons for
    _pylons - The pylon IDs to swap (1-indexed, number)
    _turret - The turret ID to swap pylons to

Returns:
	Nothing

Examples:
	[_heli, [1], [0]] call fza_weapons_fnc_pylonSetOwner

Author:
	mattysmith22
---------------------------------------------------------------------------- */
params ["_heli", "_pylons", "_turret", "_data"];

if !(isNil "_data") exitWith {
    {
        _x params ["_pylId", "", "_pylTurret", "_pylMag", "_pylAmmo"];
        _heli setPylonLoadout [_pylId, _pylMag, true, _turret];
        _heli setAmmoOnPylon [_pylId, _pylAmmo];
    } forEach _data;
};

private _pylonsToUpdate = getAllPylonsInfo _heli select
    { _x params ["_pylId", "", "_pylTurret"]; _pylId in _pylons && _pylTurret isNotEqualTo _turret };

private _turretsToUpdate = (_pylonsToUpdate apply {_x # 2}) arrayIntersect (_pylonsToUpdate apply {_x # 2});

if (count _turretsToUpdate == 0) exitWith {};
assert (count _turretsToUpdate == 1);

private _turretToUpdate = _turretsToUpdate # 0;

if !(_heli turretLocal _turretToUpdate) exitWith {
    _this remoteExecCall ["fza_weapons_fnc_pylonSetOwner", _heli turretUnit _turretToUpdate];
};

private _targets =
    [ _heli turretUnit [-1]
    , _heli turretUnit [0]
    ];
[_heli, _pylons, _turret, _pylonsToUpdate] remoteExecCall ["fza_weapons_fnc_pylonSetOwner", _targets, false]