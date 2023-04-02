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
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

if !(_was == _heli getVariable "fza_ah64_was") exitwith {};

private _nts = _heli getVariable "fza_ah64_fcrNts";
private _nts = _nts # 0;
private _apx = 0;
private _apy = 0;
private _W = 0;
private _h = 0;

private ["_missileTarget"];
if (_heli getVariable "fza_ah64_selectedMissile" == "fza_agm114l_wep") then {
	_missileTarget = _nts;
} else {
	_missileTarget = _heli getVariable "fza_ah64_currentlase";
};

_scPos = worldToScreen(getpos _missileTarget);
if (count _scPos < 1) then {
	_scPos = [-100, -100];
} else {
	_scPos = [
		[_scPos # 0, 0, 1] call BIS_fnc_clamp,
		[_scPos # 1, 0, 1] call BIS_fnc_clamp
	];
};
_targpos = _scPos;

if (isNull _missileTarget) then {
	((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 131) ctrlSetText "";
} else {
	private _loblCheck = [_heli] call fza_fnc_hellfireSALShouldStartLobl;
	private _distOffAxis = abs (_heli getRelDir _missileTarget call CBA_fnc_simplifyAngle180);
	private _loalLimitOffset = 7.5;

	if (_heli getVariable "fza_ah64_selectedMissile" == "fza_agm114l_wep") then {
		_loblCheck = ([_heli, [getpos _missileTarget, "", speed _missileTarget, _missileTarget]] call fza_fnc_hellfireLimaLoblCheck) # 1;
		_loalLimitOffset = 5;
	};
		
	if (_heli ammo (_heli getVariable "fza_ah64_selectedMissile") > 0 && _LoblCheck) then {
		_w = 0.2202;
		_h = 0.3;
		_apx = 0.108;
		_apy = 0.15;
		if (_distOffAxis <= 20) then {
			((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 131) ctrlSetText "\fza_ah64_us\tex\HDU\ah64_lobl.paa";
		} else {
			((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 131) ctrlSetText "\fza_ah64_us\tex\HDU\ah64_lobl_nolos.paa";
		};
	} else {
		_w = 0.0734;
		_h = 0.1;
		_apx = 0.036;
		_apy = 0.05;
		if (_distOffAxis <= _LoalLimitOfset) then {
			((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 131) ctrlSetText "\fza_ah64_us\tex\HDU\f16_rsc_jhmcs_targ.paa";
		} else {
			((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 131) ctrlSetText "\fza_ah64_us\tex\HDU\f16_rsc_jhmcs_targ_nolos.paa";
		};
	};
};
systemchat str _scPos;
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 131) ctrlSetPosition [(_scPos select 0) - (_apx), (_scPos select 1) - (_apy), _w, _h];
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 131) ctrlCommit 0;
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 132) ctrlSetPosition ([(_targpos select 0)-0.036,(_targpos select 1)-0.05] call fza_fnc_compensateSafezone);
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 132) ctrlCommit 0;