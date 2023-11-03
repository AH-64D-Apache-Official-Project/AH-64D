/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_canvasAdjust

Description:
    (Internal)
    Converts a point in canvas coordinates to a point for drawing

Parameters:
    _canvas - The canvas to draw the velocity vector on
    _inp - Point to adjust

Returns:
    Nothing

Examples:
    --- Code
    [_canvas, [0,0]] call fza_ihadss_fnc_flightVelocityVector
    ---

Author:
    mattysmith22
---------------------------------------------------------------------------- */
params ["_canvas", "_inp"];
_canvas params ["", "_center", "_vect"];
[ _inp # 0 * _vect # 0 + _center # 0
, _inp # 1 * _vect # 1 + _center # 1
]