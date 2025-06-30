/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_steeringCursorDraw

Description:
    Controlls and draws the rocket steering cursor of the ihadss

Parameters:
    _heli - The apache

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_ihadss_fnc_steeringCursorDraw
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_ihadss\headers\dimensions.h"
params ["_heli"];

private _steeringCursorControl = ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 131);
private _sight = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
private _pylonelev = _heli getVariable "fza_ah64_rocketPylonElev";
private _screenPos = [-100, -100];
private _conW = 2*14*SYMB_DEG_SCALING_FACTOR;
private _conH = 2*19*SYMB_DEG_SCALING_FACTOR;
private _Offset = -0.35;

if (WAS_WEAPON_RKT != [_heli, "fza_ah64_was"] call fza_fnc_getSeatVariable) exitwith {};    
if (cameraView != "GUNNER") then {_Offset = 0.14;};

private _tex = "\fza_ah64_model\tex\HDU\ah64_rkt.paa";
_steeringCursorControl ctrlSetText _tex;
private _tadsAzimuth = _heli getVariable "fza_ah64_tadsAzimuth";
_screenPos = [_Offset + _tadsAzimuth*4, -8 + (-_pylonelev/0.64)] call fza_ihadss_fnc_angleToScreen;

_steeringCursorControl ctrlSetPosition [_screenPos#0 - _conW/2, _screenPos#1 - _conH/2, _conW, _conH];
_steeringCursorControl ctrlCommit 0;