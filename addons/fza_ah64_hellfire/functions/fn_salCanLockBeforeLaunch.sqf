/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_salCanLockBeforeLaunch
Description: Returns true when a lockable laser spot is visible pre-launch.
Parameters: _heli - The helicopter
Returns: Boolean
Author: Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

private _laserPos = [_heli] call fza_hellfire_fnc_salFindLaserDesignation;
!isNil "_laserPos"
