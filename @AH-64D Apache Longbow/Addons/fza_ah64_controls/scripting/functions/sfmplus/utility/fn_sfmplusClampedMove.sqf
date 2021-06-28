/* ----------------------------------------------------------------------------
Function: BMK_fn_setArrayClampedMove

Description:

Parameters:
  ...

Returns:
  ...

Examples:
  ...

Author:
  BradMick
---------------------------------------------------------------------------- */
params ["_maxVal", "_curVal", "_deltaTime", "_valPerUnitTime"];

private _delta        = _maxVal - _curVal;
private _clampedDelta = [_delta, -_deltaTime * _valPerUnitTime, _deltaTime * _valPerUnitTime] call BIS_fnc_clamp;

_curVal + _clampedDelta;