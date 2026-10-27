/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_canvasAdjust

Description:
    (Internal)
    Converts a point in canvas coordinates to a point for drawing

Parameters:
    _canvas - The canvas [control, centre, scale vector]
    _inp - Point to adjust

Returns:
    The point for drawing

Examples:
    --- Code
    [_canvas, [0,0]] call fza_mpd_fnc_canvasAdjust
    ---

Author:
    mattysmith22
---------------------------------------------------------------------------- */
params ["_canvas", "_inp"];
_canvas params ["", "_center", "_vect"];
[ _inp # 0 * _vect # 0 + _center # 0
, _inp # 1 * _vect # 1 + _center # 1
]
