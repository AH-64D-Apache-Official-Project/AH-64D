/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_isTargetInSeekerCone
Description: Returns true if the target falls inside the seeker boresight cone.
Parameters:
    _seeker         - Seeker object
    _targetPos      - World position of the target
    _seekerMaxAngle - Cone half-angle (degrees)
Returns: Boolean
Author: Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_seeker", "_targetPos", "_seekerMaxAngle"];

private _sensorPos  = getPosASL _seeker;
private _toTarget   = _sensorPos vectorFromTo _targetPos;
private _dotProduct = (vectorDir _seeker) vectorDotProduct _toTarget;

(_dotProduct >= cos _seekerMaxAngle)
