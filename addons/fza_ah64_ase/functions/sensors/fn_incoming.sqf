/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_incoming

Description:
    Whether a munition is incoming: guided at the aircraft, or passing close to it soon.

Parameters:
    _heli     - The helicopter
    _munition - The munition

Returns:
    Boolean

Examples:
    [_heli, _missile] call fza_ase_fnc_incoming

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
params ["_heli", "_munition"];

private _relPos = (getPosASL _munition) vectorDiff (getPosASL _heli);
private _relVel = (velocity _munition) vectorDiff (velocity _heli);
// Once past, it is no longer incoming, guided at the aircraft or not
if (missileTarget _munition == _heli) exitWith {(_relPos vectorDotProduct _relVel) < 0};
private _speed2 = _relVel vectorDotProduct _relVel;
if (_speed2 < 1) exitWith {false};
private _ttg = -(_relPos vectorDotProduct _relVel) / _speed2;
_ttg > 0 && {_ttg < ASE_MWS_MAX_TTG} && {vectorMagnitude (_relPos vectorAdd (_relVel vectorMultiply _ttg)) < ASE_MWS_MISS_DIST}
