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
params ["_heli"];

private _steeringCursorControl = ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 131);
private _sight = [_heli] call fza_fnc_targetingGetSightSelect;
private _screenPos = [-100, -100];
private _conW  = 0.1468;
private _conH  = 0.2;
private _apx   = 0.072;
private _apy   = 0.1;

if (WAS_WEAPON_RKT != _heli getVariable "fza_ah64_was") exitwith {};

private _tex = ["\fza_ah64_us\tex\HDU\ah64_rkt.paa", "\fza_ah64_us\tex\HDU\ah64_rkt_fxd"] select (_sight == 3);
_steeringCursorControl ctrlSetText _tex;
if (_sight == 3) then { //FXD
	_screenPos = worldToScreen (_heli modelToWorldVisual [0, 1000, 0]);
	if (_screenPos isEqualTo []) then {
		_screenPos = [-100, -100];
	};
} else {
	_screenPos = [0.5 - deg (_heli animationPhase "tads_tur")*3/64/4, 0.5-deg (_heli animationPhase "tads")*3/64/4];
};
_steeringCursorControl ctrlSetPosition [_screenPos#0 - _apx, _screenPos#1 - _apy, _conW, _conH];
_steeringCursorControl ctrlCommit 0;