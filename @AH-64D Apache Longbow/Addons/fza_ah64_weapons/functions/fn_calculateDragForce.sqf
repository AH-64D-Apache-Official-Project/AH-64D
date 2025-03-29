params ["_wpnVel", "_wpnDragCoef", "_wpnArea"];

private _drag = 0.5 * _wpnDragCoef * _area * (_wpnEffVel * _wpnVel);

drag;