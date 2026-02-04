params ["_ctrl", "_pos"];

private _screenCoord = worldToScreen _pos;
if (_screenCoord isEqualTo []) exitWith{nil};

ctrlPosition _ctrl params ["_x", "_y", "_w", "_h"];
[ linearConversion [_x, _x+_w, _screenCoord#0, 0, 1]
, linearConversion [_y, _y+_h, _screenCoord#1, 0, 1]
];