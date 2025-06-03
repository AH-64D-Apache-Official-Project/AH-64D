/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_constraintBoxDraw

Description:
    Controlls and draws the contraint box of the ihadss

Parameters:
    _heli - The apache

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_ihadss_fnc_constraintBoxDraw
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_ihadss\headers\dimensions.h"
params ["_heli"];

private _constraintBoxCtrl = (uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 131;
private _conW = 0;
private _conH = 0;
private _indicateLobl = false;
private _vector = [];
private _allowableAngle = 20;
private _constraintBoxUseTads = false;

if (WAS_WEAPON_MSL != _heli getVariable "fza_ah64_was") exitwith {};

if (_heli getVariable "fza_ah64_selectedMissile" == "fza_agm114l_wep") then {
	_heli getVariable "fza_ah64_fcrNts" params ["_ntsObj", "_ntsPos"];
	if !isNull _ntsObj then {
		_indicateLobl = ([_heli, [_ntsPos, speed _ntsObj, _ntsObj], true] call fza_hellfire_fnc_limaLoblCheck) # 1;
		_vector = _heli worldToModelVisual (aslToAgl _ntsPos);
		if _indicateLobl then {
			_vector = _heli worldToModelVisual (aslToAgl getPosASL _ntsObj);
			_allowableAngle = 5;
		};
	};
} else {
	private _lasePos = [_heli] call fza_hellfire_fnc_salLasePos;
	if !isNil "_lasePos" then {
		_vector = _heli worldToModelVisual (aslToAgl _lasePos);
		_indicateLobl = true;
	} else {
		if (_heli getVariable "fza_ah64_hellfireTrajectory" == "DIR") then {
			_constraintBoxUseTads = true;
		} else {
			//If we don't have a selected point, place the constraints box at the center
			_vector = [0,1,0]
		};
	};
	if !_indicateLobl then {_allowableAngle = 7.5};
};

private _angleOffAxis = [];
if _constraintBoxUseTads then {
	private _tadsAzimuth = _heli getVariable "fza_ah64_tadsAzimuth";
	private _tadsElevation = _heli getVariable "fza_ah64_tadsElevation";
	_angleOffAxis = [_tadsAzimuth, _tadsElevation];
	_angleOffAxis set [1, -(_angleOffAxis # 1)];
} else {
	if (_vector isNotEqualTo []) then {
		_angleOffAxis = [_vector#0 atan2 _vector#1, -(_vector#2) atan2 _vector#1];
	};
};

if (_angleOffAxis isNotEqualTo []) then {
	_angleOffAxis set [0, [_angleOffAxis # 0] call CBA_fnc_simplifyAngle180];
};

private _distOffAxis = if (_angleOffAxis isEqualTo []) then {1000} else {abs (_angleOffAxis#0) max abs (_angleOffAxis#1)};

if (_heli ammo (_heli getVariable "fza_ah64_selectedMissile") == 0) then {
	_indicateLobl = false;
};

private _inConstraints = _distOffAxis < _allowableAngle;

if _indicateLobl then {
	_conW = 2*20*SYMB_DEG_SCALING_FACTOR/4*3;
	_conH = 2*20*SYMB_DEG_SCALING_FACTOR;
	private _tex = ["\fza_ah64_us\tex\HDU\ah64_lobl_nolos.paa", "\fza_ah64_us\tex\HDU\ah64_lobl.paa"] select _inConstraints;
	_constraintBoxCtrl ctrlSetText _tex;
} else {
	_conW = 2*7.5*SYMB_DEG_SCALING_FACTOR/4*3;
	_conH = 2*7.5*SYMB_DEG_SCALING_FACTOR;
	private _tex = ["\fza_ah64_us\tex\HDU\f16_rsc_jhmcs_targ_nolos.paa", "\fza_ah64_us\tex\HDU\f16_rsc_jhmcs_targ.paa"] select _inConstraints;
	_constraintBoxCtrl ctrlSetText _tex;
};

private _screenPos = [-100, -100];
if (_angleOffAxis isNotEqualTo []) then {
	_screenPos = _angleOffAxis call fza_ihadss_fnc_angleToScreen;
};
_constraintBoxCtrl ctrlSetPosition [_screenPos#0 - _conW/2, _screenPos#1 - _conH/2, _conW, _conH];
_constraintBoxCtrl ctrlCommit 0;
