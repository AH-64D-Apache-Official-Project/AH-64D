/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_buildTPMData

Description:
    Harvests the structures around the helicopter that qualify as TPM obstacles
    into fza_ah64_fcrTPMObstacles as [[x, y, topASL], ...], nearest
    first, at most 64. Safe to call every frame: it only re-harvests after 200 m
    of travel and never while a previous harvest is still running.

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

private _heliPosASL = getPosASL _heli;
private _maxRange   = 2500;

// Structures don't move — rebuild only after >200m of travel; world pos stored, sector cull happens at snapshot time.
private _lastObsPos = _heli getVariable ["fza_ah64_fcrTPMLastObsPos", [0,0,-9999]];
if (_heliPosASL distance2D _lastObsPos <= 200) exitWith {};

// One harvest at a time; the 30 s escape covers a harvest script that died
(_heli getVariable ["fza_ah64_fcrTPMHarvest", [false, -100]]) params ["_busy", "_startTick"];
if (_busy && { diag_tickTime - _startTick < 30 }) exitWith {};

_heli setVariable ["fza_ah64_fcrTPMLastObsPos", _heliPosASL];
_heli setVariable ["fza_ah64_fcrTPMHarvest", [true, diag_tickTime]];

// Scheduled so the per-object ray checks spread over frames. The two object queries
// are single engine commands and still run within one frame each.
[_heli, _heliPosASL, _maxRange] spawn {
    params ["_heli", "_heliPosASL", "_maxRange"];

    // Curated map tower categories are missed by nearestObjects (terrain objects without CfgVehicles classes)
    private _towers  = nearestTerrainObjects [_heliPosASL,
        ["TRANSMITTER", "STACK", "VIEW-TOWER", "WATERTOWER", "LIGHTHOUSE", "POWERWIND", "CHURCH"], _maxRange];
    private _generic = nearestObjects [_heliPosASL, ["Building", "PowerLine", "Lamps_base_F"], _maxRange];

    // Tower-like (height dominates footprint) at 8m+, or any shape at 13m+
    private _gate = {
        params ["_h", "_fp", "_curated"];
        if (_curated) exitWith { _h >= FCR_OBST_TOWER_MIN_HEIGHT_M };
        (_h >= FCR_OBST_TOWER_MIN_HEIGHT_M && _h >= FCR_OBST_TOWER_RATIO * _fp)
        || _h >= FCR_OBST_TALL_HEIGHT_M
    };

    private _obstacles = [];
    private _added     = [];
    {
        _x params ["_objs", "_curated"];
        {
            if (count _obstacles >= 64) exitWith {};
            if (isNull _x || { (_added find _x) != -1 }) then { continue; };
            private _obj      = _x;
            private _objPos   = getPosASL _obj;
            private _objRange = _heliPosASL distance2D _objPos;
            if (_objRange < 100) then { continue; };

            (boundingBoxReal _obj) params ["_minBB", "_maxBB"];
            private _ext    = _maxBB#2;
            private _topASL = (_objPos#2) + _ext;
            private _fp     = ((_maxBB#0) - (_minBB#0)) max ((_maxBB#1) - (_minBB#1));

            // Over water the sea surface is the height reference — pier decks read their ~3m above the waterline
            private _bbH = _ext;
            if (surfaceIsWater [_objPos#0, _objPos#1]) then { _bbH = _bbH min _topASL };
            if !([_bbH, _fp, _curated] call _gate) then { continue; };

            // Bounding boxes overstate some models (nav piers claim 24m of air) — verify the top
            // with a 3x3 vertical ray grid, capped at the bb extent so wire spans over valleys
            // stay excluded; if no ray touches the object (open lattice) the bb value stands
            private _ref    = (getTerrainHeightASL [_objPos#0, _objPos#1]) max 0;
            private _rayTop = -1e6;
            for "_i" from 0 to 2 do {
                if (_rayTop >= _topASL - 0.5) exitWith {};
                for "_j" from 0 to 2 do {
                    if (_rayTop >= _topASL - 0.5) exitWith {};
                    private _w = _obj modelToWorld [
                        (_minBB#0) + ((_maxBB#0) - (_minBB#0)) * (0.1 + 0.4 * _i),
                        (_minBB#1) + ((_maxBB#1) - (_minBB#1)) * (0.1 + 0.4 * _j), 0];
                    private _hits = lineIntersectsSurfaces [[_w#0, _w#1, _topASL + 5],
                        [_w#0, _w#1, _ref - 1], objNull, objNull, true, 8, "VIEW", "FIRE"];
                    {
                        if ((_x#2) isEqualTo _obj || (_x#3) isEqualTo _obj) exitWith {
                            _rayTop = _rayTop max ((_x#0)#2);
                        };
                    } forEach _hits;
                };
            };

            private _h    = _bbH;
            private _topZ = _topASL;
            if (_rayTop > -1e5) then {
                _h    = _bbH min (_rayTop - _ref);
                _topZ = _rayTop;
            };
            if !([_h, _fp, _curated] call _gate) then { continue; };

            _added     pushBack _obj;
            _obstacles pushBack [_objPos#0, _objPos#1, _topZ];
        } forEach _objs;
    } forEach [[_towers, true], [_generic, false]];

    _heli setVariable ["fza_ah64_fcrTPMObstacles", _obstacles];
    _heli setVariable ["fza_ah64_fcrTPMHarvest", [false, diag_tickTime]];
};
