
#include "\fza_ah64_sfmplus\headers\core.hpp"

params ["_heli", "_center", "_coords", "_locVelX", "_locVelY", "_locVelZ"];

if (!local _heli) exitWith {};

private _v1 = _coords select 0;
private _v2 = _coords select 1;
private _v3 = _coords select 2;
private _v4 = _coords select 3;

for "_i" from 0 to (_count - 1) do {
    private _verts = _coords select _i;
	[_heli, _center, _locVelX, _locVelY, _locVelZ, _v1, _v2, _v3, _v4] call fza_sfmplus_fnc_aeroSurface;


    [_heli, _center, _vecRight, _vecFwd, _vecUp, _relWind, _angVel, _verts select 0, _verts select 1, _verts select 2, _verts select 3] call fza_sfmplus_fnc_aeroSurface;
};