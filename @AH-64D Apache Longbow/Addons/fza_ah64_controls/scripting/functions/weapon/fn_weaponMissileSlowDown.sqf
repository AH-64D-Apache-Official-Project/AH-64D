params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

if(!local _projectile)exitWith{}; 
_heli = (getShotParents _projectile) # 0;
if !(_projectile isKindOf "fza_agm114l" || _projectile isKindOf "fza_agm114k" || _projectile isKindOf "fza_fim92") exitwith {};

if (_projectile isKindOf "fza_agm114l") then {
	private _targinfo       = _heli getVariable "fza_ah64_fcrNts";
	private _targObj        = _targinfo #0;
	private _targPos        = _targinfo #1;
    private _distance       = _heli distance _targObj;
    private _armaRadarOn    = isVehicleRadarOn _heli;

    //Min range
    if (_distance < 500) exitwith {
		_projectile setmissiletarget objnull;
    };
	_projectile setmissiletarget _targObj;

	private _fcrTargets = _heli getVariable "fza_ah64_fcrTargets";
	if (count _fcrTargets == 0) then {
		_heli setVariable ["fza_ah64_fcrNts", [objNull,[0,0,0]], true];
	} else {
		private _oldNts = _heli getVariable "fza_ah64_fcrNts";
		private _oldNts = _oldNts # 0;
		private _oldNtsIndex = _fcrTargets findIf {_x # 3 == _oldNts};
		private _newNtsIndex = (_oldNtsIndex + 1) mod count _fcrTargets;
		_heli setVariable ["fza_ah64_fcrNts", [_fcrTargets # _newNtsIndex # 3,_fcrTargets # _newNtsIndex # 0], true];
	};
};

if (_projectile isKindOf "fza_agm114k" || _projectile isKindOf "fza_fim92") then {
    _targ = (_heli getVariable "fza_ah64_currentLase");
	_distOffAxis = abs ([[_heli, (getposatl _heli select 0), (getposatl _heli select 1), (getposatl _targ select 0), (getposatl _targ select 1)] call fza_fnc_relativeDirection] call CBA_fnc_simplifyAngle180);
	if (!(isNull _targ) && _distOffAxis < 40) then {
		_projectile setMissileTarget _targ;
	};
};

_heli setVariable ["fza_ah64_shotat_list", (_heli getVariable "fza_ah64_shotat_list")+[_targ], true];
_heli setVariable ["fza_ah64_shotmissile_list", (_heli getVariable "fza_ah64_shotmissile_list")+[_projectile], true];
private _pfh = "fza_pfh_agm114_helper_" + str _projectile;

[_pfh, "onEachFrame", {
	params["_projectile","_pfh"];

	if(!alive _projectile)exitWith{
		[_pfh, "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
		_heli setVariable ["fza_ah64_shotat_list", (_heli getVariable "fza_ah64_shotat_list")-[_targ, objNull], true];
		_heli setVariable ["fza_ah64_shotmissile_list", (_heli getVariable "fza_ah64_shotmissile_list")-[_projectile, objNull], true];
	};
	
}, [_projectile,_pfh, _heli, _targ]] call BIS_fnc_addStackedEventHandler;