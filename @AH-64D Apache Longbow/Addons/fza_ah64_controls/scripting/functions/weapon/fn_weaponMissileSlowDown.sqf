params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

if(!local _projectile)exitWith{}; 
_heli = (getShotParents _projectile) # 0;
if !(_projectile isKindOf "fza_agm114l" || _projectile isKindOf "fza_agm114k" || _projectile isKindOf "fza_fim92") exitwith {};

if (_projectile isKindOf "fza_agm114l") then {
	private _targinfo       = _heli getVariable "fza_ah64_fcrNts";
	private _targObj        = _targinfo #0;
	private _targPos        = _targinfo #1;
    private _distance       = _heli distance _targObj;
	private _targetType     = _targobj call BIS_fnc_objectType;
    private _armaRadarOn    = isVehicleRadarOn _heli;

    //Min range
    if (_distance < 500) exitwith {
		_projectile setmissiletarget objnull;
    };
	if (!(isNull _targObj) && _heli getVariable "fza_ah64_missleLOBL" == true) then {
		_projectile setmissiletarget _targObj;
	} else {
        //Lima LOAL Logic
		//private _LoalTarget = "O_UAV_01_F" createvehiclelocal [0,0,100];
		private _LoalTarget = createVehicle ["O_UAV_01_F", [0,0,100]];
		_LoalTarget enableSimulationglobal false;
		_LoalTarget hideobjectglobal true;

        if (_armaRadarOn == true) then {
            _loaltarget setposasl (getposasl _targObj vectoradd [0,0,2]);
        } else {
            _loaltarget setposasl (_targPos vectoradd [0,0,2]);
        };
        if (_distance > 6000) exitwith {
            _projectile setmissiletarget objnull;
        };

		_projectile setMissileTarget _loaltarget;

        //delate Search point target and seek new target
		[_loaltarget,_projectile,_targetType] spawn {
    		params ["_loaltarget", "_projectile","_targetType"];
            private _searchRadius = 300;
			private _lastscantarget = _loaltarget;
            while {
                (alive _projectile)
            } do {
				if (_projectile distance _LoalTarget < 2500) then {
					private _lastscantarget = missileTarget _projectile;
					private _distance = _projectile distance _lastscantarget;
					private _finalScanTarget = objNull;
					private _validTargets = objNull;
					//Radar Lock check
					if !(_lastscantarget == _LoalTarget) then {
						private _terrainobscure = terrainIntersectasl[getPosASL _projectile, getPosASL _lastscantarget vectoradd [0,0,1]];
						private _obscureobjs = lineIntersectsSurfaces [getPosASL _projectile, getPosASL _lastscantarget vectoradd [0,0,2], _projectile, _lastscantarget, false, -1, "view", "geom", false];

						if ((_terrainobscure || (_obscureobjs - nearestObjects [getpos _lastscantarget, ["All"], 20]) isNotEqualTo []) && _distance > 250) then {
							_projectile setmissiletarget _loaltarget;
						};
					} else {
						_projectile setmissiletarget objnull;
						private _newScanTargets  = nearestObjects [_loaltarget, ["allvehicles"],_searchRadius];
						if (_LoalTarget in _newscantargets && count _newScanTargets > 1) then {
							_newScanTargets = _newScanTargets - [_LoalTarget];
						};
						private _validTargets  = _newScanTargets select {
							private _terrainobscure = terrainIntersectasl[getPosASL _projectile, getPosASL _x vectoradd [0,0,1]];
							
							//private _obscureobjs = lineIntersectsWith [getPosASL _projectile, getPosASL _x vectoradd [0,0,1], _projectile, _x];
							//private _obscureobjs = lineIntersectsObjs [getPosASL _projectile, getPosASL _x vectoradd [0,0,1], _projectile, _x, false, 32];
							//private _obscureobjs = [_projectile, "GEOM", _x] checkVisibility [getPosASL _projectile, getPosASL _x vectoradd [0,0,1]];
							private _obscureobjs = lineIntersectsSurfaces [getPosASL _projectile, getPosASL _x vectoradd [0,0,2], _projectile, _x, false, -1, "view", "geom", false];

							_results = "terrain check: " + str _terrainobscure + " /Obj Check: " + str _obscureobjs;
							//hint str _results;
							(!_terrainobscure && (_obscureobjs - nearestObjects [getpos _x, ["All"], 20]) isEqualTo [])
						};
						private _Primarytargets = _validTargets select {
							private _targTypeCompair = _x call BIS_fnc_objectType;
							(_targetType isEqualTo _targTypeCompair)
						};
						private _secondarytargets = _validTargets select {
							private _targTypeCompair = _x call BIS_fnc_objectType;
							!(_targetType isEqualTo _targTypeCompair)
						};
						If (_Primarytargets isNotEqualTo []) then {
							_finalScanTarget = [_Primarytargets, _lastscantarget] call BIS_fnc_nearestPosition;
						} else {
							If (_secondarytargets isNotEqualTo []) then {
								_finalScanTarget = [_secondarytargets, _lastscantarget] call BIS_fnc_nearestPosition;
							} else {
								_finalScanTarget = _LoalTarget;
							};
						};

						If (_distance < 1000 && _finalScanTarget == _LoalTarget) then {
							_searchRadius = 500;
						};

						_test = "valid targets: " + str _validTargets + "Primary targets: " + str _Primarytargets + "Final targets; " + str _finalScanTarget;
						hint str _test ;
						copyToClipboard _test;

						if (_finalScanTarget isNotEqualTo []) then {
							_projectile setmissiletarget _finalScanTarget;
						};
					};
				};
            };
            deleteVehicle _loaltarget;
		};
	};

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