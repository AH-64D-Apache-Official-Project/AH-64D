/* ----------------------------------------------------------------------------
Function: fza_fnc_targetingTadsLockTo

Description:
    Points the TADS at a world position. The game turns a locked turret the
    short way round, which from one side to the other is through the tail,
    where the TADS stops at its azimuth limit and never gets there. When the
    point is more than 90 deg round the gimbal from where the TADS points now,
    a point 90 deg round towards it, through the nose, is commanded instead,
    so the TADS comes round the front until the point itself is in reach.

Parameters:
    _heli      - The helicopter
    _target    - Position (ASL) to point at, or objNull to unlock
    _temporary - lockCameraTo's temporary flag, default false

Returns:
    Nothing

Examples:
    --- Code
    [_heli, _slavePos] call fza_fnc_targetingTadsLockTo
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_target", ["_temporary", false]];

if (_target isEqualType objNull) exitWith {
    _heli lockCameraTo [_target, [0], _temporary];
};

private _tadsPos = _heli modelToWorldVisualWorld (_heli selectionPosition "laserEnd");
(_heli vectorWorldToModelVisual (_target vectorDiff _tadsPos)) params ["_x", "_y", "_z"];
private _wantAz = _x atan2 _y;
// Where the game's turret points, without the NVS turn (fza_ihadss_fnc_tadsNvsControl): it is the turret being moved
private _az     = -deg (_heli animationPhase "tads_tur");

// Measured round the gimbal, not the short way, so a point behind on the far side is reached through the nose
if (abs (_wantAz - _az) > 90) then {
    private _el = _z atan2 (sqrt (_x * _x + _y * _y));
    _target = _tadsPos vectorAdd (_heli vectorModelToWorldVisual ([1000, _az + ([-90, 90] select (_wantAz > _az)), _el] call CBA_fnc_polar2vect));
};

_heli lockCameraTo [_target, [0], _temporary];
