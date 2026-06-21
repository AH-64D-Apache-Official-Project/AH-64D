/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_checkLos
Description: Local clone of ace_missileguidance_fnc_checkLos. Checks LOS from
    the seeker's visual center of mass rather than its raw getPosASL origin,
    which (for the helicopter pre-launch, or off-center projectile models) can
    sit far from where the seeker/sensor actually "looks" from.
Parameters:
    _seeker             - Seeker object (helicopter pre-launch or projectile)
    _target             - Target object
    _checkVisibilityTest - (Optional) Use checkVisibility instead of raw
                            terrain/object intersection [true]
Returns: Has LOS <BOOL>
Author: Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_seeker", "_target", ["_checkVisibilityTest", true]];

private _seekerPos = _seeker modelToWorldVisualWorld (getCenterOfMass _seeker);

if (_checkVisibilityTest) exitWith {
    private _visibility = [_seeker, "VIEW", _target] checkVisibility [_seekerPos, aimPos _target];
    _visibility > 0.001
};

private _targetPos    = getPosASL _target;
private _targetAimPos = aimPos _target;
private _return = true;

if ((terrainIntersectASL [_seekerPos, _targetPos]) && {terrainIntersectASL [_seekerPos, _targetAimPos]}) then {
    _return = false;
} else {
    if (lineIntersects [_seekerPos, _targetPos, _seeker, _target]) then {
        _return = false;
    };
};

_return
