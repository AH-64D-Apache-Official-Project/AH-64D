/* ----------------------------------------------------------------------------
Function: fza_fnc_hellfireCheckSeekerAngle

Description:
    returns true,false if target is in seeker angle of the object
    Derived from the ace check seeker angle but to use model vectoring instead of flight vector

Parameters:
    _seeker - object Considered to be the seeker head
    _targetpos - Intended target to check LOS
    _seekerMaxAngle - the cfg seeker angle for hellfire
    
Returns:
	true || false

Examples:

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_seeker", "_targetPos", "_seekerMaxAngle"];

private _sensorPos = getPosASL _seeker;

private _testPointVector = _sensorPos vectorFromTo _targetPos;
private _testDotProduct = (_seeker vectorModelToWorld [0,1,0]) vectorDotProduct _testPointVector;

if (_testDotProduct < (cos _seekerMaxAngle)) exitWith {
    false
};

true