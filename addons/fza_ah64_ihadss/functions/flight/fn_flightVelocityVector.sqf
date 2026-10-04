/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_flightVelocityVector

Description:
    Draws the velocity vector on the canvas.

Parameters:
    _heli - The heli object to draw the velocity vector for
    _canvas - The canvas to draw the velocity vector on

Returns:
    Nothing

Examples:
    --- Code
    [_heli, _canvas] call fza_ihadss_fnc_flightVelocityVector
    ---

Author:
    mattysmith22
---------------------------------------------------------------------------- */
params ["_heli", "_canvas", "_mode"];

#define SCALE_MPS_KNOTS 1.94

private _velocityVectorScale =
    switch (_mode) do {
        case "bobup";
        case "hover" : {6};
        case "trans" : {60};
        default {-1};
    }; // Knots

if (_velocityVectorScale == -1) exitWith {};

// Use MODEL-SPACE velocity directly (X = right, Y = forward, Z = up) so the
// lateral sign matches the shared convention used by the MPD / sideslip calc
// (+X = velocity to the RIGHT). Same source both displays now use; fixes the
// vector being drawn on the mirrored side.
//
// The VV line is drawn from screen centre: its LATERAL extent = lateral velocity
// (X, + = right) and its LENGTH along the screen = FORWARD velocity (Y). It
// saturates (reaches the top) at _velocityVectorScale knots of FORWARD speed
// (60 kt trans / 6 kt hover) - so the vertical screen component is forward vel,
// NOT vertical/climb velocity.
private _velMS = velocityModelSpace _heli;
private _scale = SCALE_MPS_KNOTS / _velocityVectorScale;
private _lat = (((_velMS # 0) * _scale) max -1 min 1) * 0.75;   // lateral, + = right
private _fwd = (((_velMS # 1) * _scale) max -1 min 1) * 0.75;   // forward, drives length

// Canvas y is inverted vs screen (up = negative), so forward speed draws the line
// UPWARD from centre.
[_canvas, [0,0], [_lat, -_fwd]] call fza_ihadss_fnc_canvasDrawLine
