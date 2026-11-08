/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_iatAcquire

Description:
    Finds what the image auto tracker captures on engagement: the vehicle or
    man nearest the TADS reticle that it can track (fza_ihadss_fnc_iatCheck),
    near it or inside the gates when they were sized, or failing one the
    object under the reticle, a building, tree or rock, held as the point on
    it. Bare terrain and sky give it nothing to track.

Parameters:
    _heli   - The helicopter
    _vision - The TADS vision mode (fza_ihadss_fnc_getVisionMode)
    _size   - Sized gates' half size, a fraction of the field of view's half width; 0 unsized (default: 0)

Returns:
    [object, ASL point ([] for a vehicle or man), half size [across, up] m], [] for nothing

Examples:
    --- Code
    private _acq = [_heli, _vision] call fza_ihadss_fnc_iatAcquire;
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_vision", ["_size", 0]];

([_heli] call fza_ihadss_fnc_tadsLos) params ["_losPos", "_losDir"];
private _tadsPos = _heli modelToWorldVisualWorld _losPos;
private _dir     = _heli vectorModelToWorldVisual _losDir;
private _fov     = fza_ah64_tadsFOVs select (_heli getVariable ["fza_ihadss_tadsOpticsMode", _heli getTurretOpticsMode [0]]);

private _halfOf = {
    ([_this] call fza_ihadss_fnc_iatBounds) params ["_p1", "_p2"];
    [(abs ((_p2 # 0) - (_p1 # 0))) max (abs ((_p2 # 1) - (_p1 # 1))), abs ((_p2 # 2) - (_p1 # 2))] vectorMultiply 0.5
};

private _best     = objNull;
private _bestOff  = 1e9;
private _bestHalf = [0, 0];
// No farther off the LOS than one at the largest size it tracks (fza_ihadss_fnc_iatCheck) could reach
private _maxReach = [(IAT_SEARCH + IAT_GATE_MAX) * _fov, _size * _fov] select (_size > 0);
{
    private _pos = (getPosASLVisual _x) vectorAdd ((aimPos _x) vectorDiff (getPosASL _x));
    private _v   = _pos vectorDiff _tadsPos;
    private _f   = _v vectorDotProduct _dir;
    if (_f <= 1) then {continue};
    private _off = (vectorMagnitude (_v vectorDiff (_dir vectorMultiply _f))) / _f;
    if (_off > _maxReach || {_off >= _bestOff}) then {continue};
    private _half  = _x call _halfOf;
    private _reach = if (_size > 0) then {_size * _fov} else {IAT_SEARCH * _fov + ((_half # 0) max (_half # 1)) / _f};
    if (_off <= _reach && {[_heli, _x, _pos, _half, _vision] call fza_ihadss_fnc_iatCheck}) then {
        _best     = _x;
        _bestOff  = _off;
        _bestHalf = _half;
    };
} forEach ((_heli nearEntities [["LandVehicle", "Ship", "Air", "CAManBase"], IAT_RANGE]) - [_heli]);

if (!isNull _best) exitWith {[_best, [], _bestHalf]};

private _hit = lineIntersectsSurfaces [_tadsPos, _tadsPos vectorAdd (_dir vectorMultiply IAT_RANGE), _heli, objNull, true, 1, "VIEW", "FIRE"];
if (_hit isEqualTo []) exitWith {[]};
(_hit # 0) params ["_hitPos", "", "_hitObj", "_parent"];
if (!isNull _parent) then {_hitObj = _parent};
if (isNull _hitObj || {_hitObj isKindOf "AllVehicles"}) exitWith {[]};

private _half = _hitObj call _halfOf;
if !([_heli, _hitObj, _hitPos, _half, _vision] call fza_ihadss_fnc_iatCheck) exitWith {[]};
[_hitObj, _hitPos, _half]
