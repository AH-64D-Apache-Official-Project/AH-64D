params ["_wpnMuzzleVelocity", "_wpnDragCoef", "_wpnArea"];

private _drag = 0.5 * _wpnDragCoef * _wpnArea * (_wpnMuzzleVelocity * _wpnMuzzleVelocity);

_drag;