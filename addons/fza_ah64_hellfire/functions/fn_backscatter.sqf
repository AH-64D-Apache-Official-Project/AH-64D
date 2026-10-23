/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_backscatter

Description:
    BACKSCATTER: with a SAL missile on the aircraft's own designation, the
    seeker is not tracking where the TADS designates. Either the spot it sees
    is off the TADS line of sight, or the laser stops on foliage (the spot
    inside a tree or bush, top to bottom) with nothing solid within 10 m
    behind it, so the missile would guide on the leaves short of whatever is
    further on. Only the metres behind the spot are cast, so the range of the
    target makes no difference. Checked four times a second.

Parameters:
    _heli - The helicopter

Returns:
    True while BACKSCATTER applies

Examples:
    --- Code
    [_heli] call fza_hellfire_fnc_backscatter
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
// Seeker off the TADS line of sight (deg), the backdrop that makes a difference behind the foliage (m), how far
// outside a plant's bounds the spot still counts as on it (m), check rate (s)
#define BACKSCATTER_OFF_LOS   2
#define BACKSCATTER_BACKDROP  10
#define BACKSCATTER_MARGIN    0.5
#define BACKSCATTER_EVERY     0.25

params ["_heli"];

(_heli getVariable ["fza_hellfire_backscatter", [-1, false]]) params ["_checkedAt", "_result"];
if (CBA_missionTime - _checkedAt < BACKSCATTER_EVERY) exitWith {_result};

_result = call {
    // The aircraft's own laser, on the priority channel's code (otherwise REMOTE)
    if (isNull laserTarget _heli) exitWith {false};
    private _pri = _heli getVariable ["fza_ah64_laserMissilePrimaryCode", -1];
    if (_pri == -1 || {((_heli getVariable ["fza_ah64_laserChannelCodes", []]) param [_pri, ""]) != (_heli getVariable ["fza_ah64_laserLRFDCode", ""])}) exitWith {false};
    private _spot = [_heli] call fza_hellfire_fnc_salFindLaserDesignation;
    if (isNil "_spot") exitWith {false};

    ([_heli] call fza_ihadss_fnc_tadsLos) params ["_losPos", "_losDir"];
    private _tadsPos = _heli modelToWorldVisualWorld _losPos;
    private _tadsDir = _heli vectorModelToWorldVisual _losDir;
    private _toSpot  = _tadsPos vectorFromTo _spot;
    if (acos ((_toSpot vectorDotProduct _tadsDir) min 1) > BACKSCATTER_OFF_LOS) exitWith {true};

    // The spot inside a plant's bounds: a plant's fire geometry is often only its lower part, where the laser stops
    // on all of it
    private _spotAGL = ASLToAGL _spot;
    private _foliage = nearestTerrainObjects [_spotAGL, ["TREE", "SMALL TREE", "BUSH"], BACKSCATTER_BACKDROP + 15, false, true];
    private _plant = _foliage findIf {
        (boundingBoxReal _x) params ["_min", "_max"];
        (_x worldToModel _spotAGL) params ["_mx", "_my", "_mz"];
        _mx > (_min # 0) - BACKSCATTER_MARGIN && {_mx < (_max # 0) + BACKSCATTER_MARGIN}
            && {_my > (_min # 1) - BACKSCATTER_MARGIN} && {_my < (_max # 1) + BACKSCATTER_MARGIN}
            && {_mz > (_min # 2) - BACKSCATTER_MARGIN} && {_mz < (_max # 2) + BACKSCATTER_MARGIN}
    };
    if (_plant == -1) exitWith {false};
    // Anything solid within the backdrop distance behind it (the ground, a vehicle, a building) is what the energy
    // also reaches; more foliage is not
    private _behind = lineIntersectsSurfaces [
        _spot vectorAdd (_toSpot vectorMultiply 0.2), _spot vectorAdd (_toSpot vectorMultiply BACKSCATTER_BACKDROP),
        _foliage # _plant, objNull, true, 5, "FIRE", "GEOM"
    ];
    (_behind findIf {!((_x # 2) in _foliage)}) == -1
};

_heli setVariable ["fza_hellfire_backscatter", [CBA_missionTime, _result]];
_result
