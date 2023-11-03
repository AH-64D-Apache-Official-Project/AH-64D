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

private _heliVelocity = [[velocity _heli, -getDir _heli, 2]
    call BIS_fnc_rotateVector3D
    vectorMultiply (SCALE_MPS_KNOTS/_velocityVectorScale), -1, 1] call BIS_fnc_clampVector
    vectorMultiply 0.75;

[_canvas, [0,0], [_heliVelocity#0, -(_heliVelocity#1)]] call fza_ihadss_fnc_canvasDrawLine