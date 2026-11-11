/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_blastDetonate
Description: Server side. Works out who a blast warhead reaches and how hard,
    then sends each machine the damage for the units it owns.

    Overpressure falls off from the lethal radius to the blast radius. Each
    obstruction in the way halves it, except inside the building the missile
    struck, where it is confined and reaches further.
Parameters: _pos      - detonation position ASL
            _velocity - missile velocity at detonation
            _ammo     - ammo class
            _parents  - getShotParents of the missile
Returns: Nothing
Author: Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_pos", "_velocity", "_ammo", "_parents"];
_parents params [["_source", objNull], ["_instigator", objNull]];

private _cfg    = configFile >> "CfgAmmo" >> _ammo;
private _radius = getNumber (_cfg >> "fza_blastRadius");
private _lethal = getNumber (_cfg >> "fza_blastLethalRadius");
private _confine = getNumber (_cfg >> "fza_blastConfinement") max 1;
if (_radius <= 0) exitWith {};

private _dir    = if (vectorMagnitude _velocity > 1) then {vectorNormalized _velocity} else {[0, 0, -1]};
private _origin = _pos vectorDiff (_dir vectorMultiply 0.5);
_origin set [2, (_origin # 2) max (getTerrainHeightASL _origin + 0.5)];

// The building struck, or failing that the one the burst is under the roof of
private _building = objNull;
{
    if ((_x # 2) isKindOf "House") exitWith {_building = _x # 2};
} forEach (
    lineIntersectsSurfaces [_pos vectorDiff _dir, _pos vectorAdd _dir, objNull, objNull, true, 1, "GEOM", "FIRE"]
    + lineIntersectsSurfaces [_origin, _origin vectorAdd [0, 0, 20], objNull, objNull, true, 1, "GEOM", "FIRE"]
);

private _units = [];
{
    if (_x isKindOf "CAManBase") then {
        _units pushBack [_x, 1];
    } else {
        private _veh      = _x;
        private _armoured = _veh isKindOf "Tank" || {_veh isKindOf "Wheeled_APC_F"};
        private _open     = _veh isKindOf "StaticWeapon";
        {
            private _gain = [0.5, 1] select _open;
            if (_armoured) then {_gain = [0, 0.5] select (isTurnedOut _x)};
            if (_gain > 0) then {_units pushBack [_x, _gain]};
        } forEach crew _veh;
    };
} forEach ((ASLToAGL _origin) nearEntities [["CAManBase", "LandVehicle", "Air", "Ship"], _radius * _confine + 5]);

private _local   = [];
private _byOwner = createHashMap;
{
    _x params ["_unit", "_gain"];
    private _target = aimPos _unit;
    private _dist   = _origin distance _target;
    if (!alive _unit || {_dist > _radius * _confine}) then {continue};

    private _veh    = vehicle _unit;
    private _inside = false;
    if (!isNull _building) then {
        private _roof = lineIntersectsSurfaces [_target, _target vectorAdd [0, 0, 20], _unit, _veh, true, 1, "GEOM", "FIRE"];
        _inside = _roof isNotEqualTo [] && {(_roof # 0 # 2) isEqualTo _building};
    };
    if (_inside) then {_dist = _dist / _confine};
    private _damage = _gain * (linearConversion [_lethal, _radius, _dist, 1, 0, true]) ^ 2;
    if (!_inside) then {
        // Terrain counts as an obstruction, other people do not
        private _blocks = {!((_x # 2) isKindOf "CAManBase")} count lineIntersectsSurfaces [_origin, _target, _unit, _veh, true, 4, "GEOM", "FIRE"];
        _damage = _damage * 0.5 ^ _blocks;
    };
    if (_damage < 0.05) then {continue};

    if (local _unit) then {
        _local pushBack [_unit, _damage];
    } else {
        (_byOwner getOrDefault [owner _unit, [], true]) pushBack [_unit, _damage];
    };
} forEach _units;

if (_local isNotEqualTo []) then {
    [_local, _source, _instigator] call fza_hellfire_fnc_blastApply;
};
{
    ["fza_hellfire_blastApply", [_y, _source, _instigator], _x] call CBA_fnc_ownerEvent;
} forEach _byOwner;
