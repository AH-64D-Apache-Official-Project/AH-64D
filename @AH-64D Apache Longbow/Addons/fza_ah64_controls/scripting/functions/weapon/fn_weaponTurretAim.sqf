/* ----------------------------------------------------------------------------
Function: fza_fnc_weaponTurretAim

Description:
	Points turrets, sensors and weaponry at the correct positions according to acquisition sources.

Parameters:
    _heli - the heli to fix the turret for.

Returns:
	Nothing

Examples:
    [_heli] call fza_fnc_weaponTurretAim

Author:
	Unknown
---------------------------------------------------------------------------- */
params["_heli"];
if (!(player in _heli)) exitwith {};
if (!(isnil "fza_ah64_enableturrets")) exitwith {};
private _inhibit = "";

private _weaponsProcessorFailed = _heli getVariable "fza_ah64_rwp_fail" && _heli getVariable "fza_ah64_lwp_fail";

private _usingRocket = currentweapon _heli isKindOf["fza_hydra70", configFile >> "CfgWeapons"];
private _usingCannon = currentweapon _heli in ["fza_m230", "fza_burstlimiter"];
private _sight = [_heli] call fza_fnc_targetingGetSightSelect;
private _targVel = [0, 0, 0];
private _targPos = -1;
private _lockCameraForwards = false;
switch (_sight) do {
    case 0:{
       if (!isNull fza_ah64_mycurrenttarget) then {
            _targPos = fza_ah64_mycurrenttarget modelToWorldWorld (fza_ah64_mycurrenttarget selectionPosition "zamerny");
            _targVel = velocity fza_ah64_mycurrenttarget;
        } else {
            _lockCameraForwards = true;
        };
	};
    case 1:{
		_targPos = aglToAsl (positionCameraToWorld [0, 0, 1000])
	};
    case 2:{
		if (gunner _heli == player && cameraView == "GUNNER" && !isNull cursorObject) then {
			_targPos = getPosAsl cursorObject;
			_targVel = velocity cursorObject;
		} else {
			_targPos = aglToAsl screentoworld[0.5, 0.5];
		};
	};
    case 3:{
        _lockCameraForwards = true;
    };
};
if (player != gunner _heli && !(player == driver _heli && isManualFire _heli)) exitWith{
	_heli setVariable ["fza_ah64_weaponInhibited", _inhibit];
};
if (_sight == 0) then {
    _heli lockCameraTo [_targPos, [0]];
};

if (cameraView == "GUNNER" && (_sight in [1,2])) then {
	_heli lockCameraTo [objNull, [0]];
};

if (_targPos isEqualTo -1) exitWith {
    if (_sight == 0) then {
        _inhibit = "NO TARGET";
    };
    if (_usingCannon && !(_sight == 3)) then {
        _inhibit = "GUN FIXED";
    };
    _heli animateSource["mainTurret", 0];
    if (_sight == 3) then {
        _heli animateSource["mainGun", 0];
    } else {
        _heli animateSource["mainGun", 0.45];
    };
    
    _heli animateSource["pylon1", 0];
    _heli animateSource["pylon2", 0];
    _heli animateSource["pylon3", 0];
	_heli animateSource["pylon4", 0];
	_heli setVariable ["fza_ah64_weaponInhibited", _inhibit];
    if (_lockCameraForwards) then {
        _heli lockCameraTo[_heli modelToWorldVisual [0,100000,0],[0]];
    };
};

if (_sight == 1 && (gunner _heli == player && cameraView != "GUNNER" || driver _heli == player && isManualFire _heli)) then {
	_heli lockCameraTo [_targPos, [0]];
};
if(fza_ah64_weaponDebug) then {
	drawIcon3d["\A3\ui_f\data\map\markers\handdrawn\dot_CA.paa", [1, 0, 0, 1], aslToAgl _targPos, 0.5, 0.5, 0, "Target"];
};

private _heliPos = getPosAsl _heli;

private _targDistance = _heliPos distance _targPos;

if (_usingRocket) then {
	private _elevationComp = ([fza_ah64_rocketTable, _heliPos distance2d _targPos] call fza_fnc_linearInterp) # 1;

    private _heliPylons = getPylonMagazines _heli;

    private _tof = _targDistance / (1800 - (_targDistance ^ 0.6));
    private _aimLocation = _targPos
    vectorAdd((_targVel vectorDiff velocity _heli) vectorMultiply _tof)
    vectorAdd[0, 0, _elevationComp];
	if(fza_ah64_weaponDebug) then {
		drawIcon3d["\A3\ui_f\data\map\markers\handdrawn\dot_CA.paa", [1, 0, 1, 1], aslToAgl _aimLocation, 0.5, 0.5, 0, "Rocket Correction"];
	};

    private _pylonAdjustment = ([0, -0.35, -1.69] vectorAdd ((_heli worldToModel aslToAgl _aimLocation)) call CBA_fnc_vect2Polar)# 2;
	if !(-15 < _pylonAdjustment && _pylonAdjustment < 4) then {
		_inhibit = "PYLON LIMIT"
	};
    if (_heliPylons# 0 != "") then {
        _heli animateSource["pylon1", _pylonAdjustment];
    } else {
		_heli animateSource["pylon1", 0];
	};
    if (_heliPylons# 7 != "") then {
		_heli animateSource["pylon2", _pylonAdjustment];
	} else {
		_heli animateSource["pylon2", 0];
	};
	if (_heliPylons# 14 != "") then {
		_heli animateSource["pylon3", _pylonAdjustment];
	} else {
		_heli animateSource["pylon3", 0];
	};
	if (_heliPylons# 21 != "") then {
		_heli animateSource["pylon4", _pylonAdjustment];
	} else {
		_heli animateSource["pylon4", 0];
	};
} else {
    _heli animateSource["pylon1", 0];
    _heli animateSource["pylon2", 0];
    _heli animateSource["pylon3", 0];
    _heli animateSource["pylon4", 0];	
};

if (_usingCannon) then {
	private _pan = _heli animationPhase "tads_tur";
	private _tilt = _heli animationPhase "tads";
	if !(-86 < deg _pan && deg _pan < 86) then {
		_inhibit = "AZ LIMIT";
	};
	if !(-60 < deg _tilt && deg _tilt < 11) then {
		_inhibit = "EL LIMIT";
	};
    if (_inhibit != "") then {
        _safemessage = "_inhibit";
        player forceWeaponFire["fza_burstlimiter", "fza_burstlimiter"];
    };
	_heli animateSource["mainTurret", [_pan, rad -86, rad 86] call BIS_fnc_clamp];
	_heli animateSource["mainGun", [_tilt, rad -60, rad 11] call BIS_fnc_clamp];
} else {
	_heli animateSource["mainTurret", 0];
	_heli animateSource["mainGun", 0.45];
};
_heli setVariable ["fza_ah64_weaponInhibited", _inhibit];