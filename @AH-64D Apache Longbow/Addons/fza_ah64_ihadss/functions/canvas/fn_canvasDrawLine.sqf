/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_canvasDrawLine

Description:
    Draws a line on the canvas

Parameters:
    _canvas - The canvas to draw the velocity vector on
    _from - First point
    _to - Second point
    _width - (Optional) Width of the line
    _color - (Optional) Color of the line

Returns:
    Nothing

Examples:
    --- Code
    [_canvas, [0,0], [1,1]] call fza_ihadss_fnc_flightVelocityVector
    ---

Author:
    mattysmith22
---------------------------------------------------------------------------- */
params ["_canvas", "_from", "_to", ["_width", 0.008]];

_canvas params ["_canvasCtrl", "_canvasCenter", "_canvasVect", "_canvasDefaultColor"];

params ["", "", "", "", ["_color", _canvasDefaultColor]];

private _fromPos = [_canvas, _from] call fza_ihadss_fnc_canvasAdjust;
private _toPos = [_canvas, _to] call fza_ihadss_fnc_canvasAdjust;
private _diff = _toPos vectorDiff _fromPos;

_canvasCtrl drawRectangle
    [(_fromPos vectorAdd _toPos) vectorMultiply 0.5
    , vectorMagnitude (_fromPos vectorDiff _toPos) / 2
    , _width/2*vectorMagnitude _canvasVect
    , -(_diff # 1 atan2 _diff # 0)
    , [1,1,1,1]
    , format (["#(rgb,8,8,3)color(%1,%2,%3,%4)"]+_color)
    ];