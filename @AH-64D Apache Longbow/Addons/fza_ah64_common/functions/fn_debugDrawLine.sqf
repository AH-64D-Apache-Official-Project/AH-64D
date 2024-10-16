/* ----------------------------------------------------------------------------
Function: fza_fnc_debugDrawLine

Description:
  Draws a debug line.

Parameters:
  _heli - The helicopter to attach the line to
  _p1   - The start of the line
  _p2   - The end of the line
  _col  - The color of the line

Returns:
  ...

Examples:
  ...

Author:
  BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_p1", "_p2", "_col"];

private _colorRed = [1,0,0,1]; private _colorGreen = [0,1,0,1]; private _colorBlue = [0,0,1,1]; private _colorWhite = [1,1,1,1];

switch (_col) do {
    case "red": {
        _col = _colorRed;
    };
    case "green": {
        _col = _colorGreen;
    };
    case "blue": {
        _col = _colorBlue;
    };
    case "white": {
        _col = _colorWhite;
    };
};

drawLine3D [_heli modelToWorldVisual _p1, _heli modelToWorldVisual _p2, _col];