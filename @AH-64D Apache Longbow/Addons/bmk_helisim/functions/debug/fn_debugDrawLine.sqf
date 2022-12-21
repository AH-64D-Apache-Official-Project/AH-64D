/* ----------------------------------------------------------------------------
Function: bmk_debugDrawLine

Description:

Parameters:
	_heli - The apache helicopter to get information from [Unit].

Returns:

Examples:
	...

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_p1", "_p2", "_color"];

drawLine3D [_heli modelToWorldVisual _p1, _heli modelToWorldVisual _p2, _color];