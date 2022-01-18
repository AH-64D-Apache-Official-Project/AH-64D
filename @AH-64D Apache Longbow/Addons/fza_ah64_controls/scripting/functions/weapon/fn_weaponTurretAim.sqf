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
#include "\fza_ah64_controls\headers\systemConstants.h"

params["_heli"];
if (!(player in _heli)) exitwith {};
if (!(isnil "fza_ah64_enableturrets")) exitwith {};
#define WEP_TYPE(_mag) (if ((_mag) == "") then {""} else {getText (configFile >> "cfgMagazines" >> (_mag) >> "fza_pylonType")})
private _inhibit = "";

private _weaponsProcessorFailed = _heli getVariable "fza_ah64_rwp_fail" && _heli getVariable "fza_ah64_lwp_fail";

private _usingRocket = currentweapon _heli isKindOf["fza_hydra70", configFile >> "CfgWeapons"] || currentWeapon _heli == "fza_rkt_safe";
private _usingCannon = currentweapon _heli in ["fza_m230", "fza_burstlimiter", "fza_gun_safe"];
private _sight = [_heli] call fza_fnc_targetingGetSightSelect;
private _targVel = [0, 0, 0];
private _targPos = -1;
private _lockCameraForwards = false;
private _nts = _heli getVariable "fza_ah64_fcrNts";

switch (_sight) do {
    case SIGHT_FCR:{
       if (!isNull _nts) then {
            _targPos = aimPos _nts;
            _targVel = velocity _nts;
        } else {
            _lockCameraForwards = true;
        };
	};
    case SIGHT_HMD:{
		_targPos = aglToAsl (positionCameraToWorld [0, 0, 1000])
	};
    case SIGHT_TADS:{
		if (gunner _heli == player && cameraView == "GUNNER" && !isNull cursorObject) then {
			_targPos = aimPos cursorObject;
			_targVel = velocity cursorObject;
		} else {
			_targPos = aglToAsl screentoworld[0.5, 0.5];
		};
	};
    case SIGHT_FXD:{
        _lockCameraForwards = true;
    };
};
if (player != gunner _heli && !(player == driver _heli && isManualFire _heli)) exitWith{
	_heli setVariable ["fza_ah64_weaponInhibited", _inhibit];
};
if (_sight == SIGHT_FCR) then {
    _heli lockCameraTo [_targPos, [0]];
};

if (cameraView == "GUNNER" && (_sight in [SIGHT_HMD,SIGHT_TADS])) then {
	_heli lockCameraTo [objNull, [0]];
};

if (_targPos isEqualTo -1) exitWith {
    if (_sight == SIGHT_FCR) then {
        _inhibit = "NO TARGET";
    };
    if (_usingCannon && !(_sight == SIGHT_FIXED)) then {
        _inhibit = "GUN FIXED";
    };
    _heli animateSource["mainTurret", 0];
    if (_sight == SIGHT_FXD && _usingCannon) then {
        _heli animateSource["mainGun", 0];
    } else {
        _heli animateSource["mainGun", 0.298];
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

if (_sight == SIGHT_HMD && (gunner _heli == player && cameraView != "GUNNER" || driver _heli == player && isManualFire _heli)) then {
	_heli lockCameraTo [_targPos, [0]];
};

#define NOTVISIBLEFROMTADS(_heli, _tgt) ([(_heli), "VIEW", (_tgt)] checkVisibility [eyePos player, getPosASL (_tgt)] == 0)
if (_sight == SIGHT_TADS && (gunner _heli == player) && !isNull (_heli getVariable "fza_ah64_tadsLocked")) then {
	_heli lockCameraTo [aimPos (_heli getVariable "fza_ah64_tadsLocked"), [0]];

	if (NOTVISIBLEFROMTADS(_heli, _heli getVariable "fza_ah64_tadsLocked") && !fza_ah64_tadsLockCheckRunning) then {
		fza_ah64_tadsLockCheckRunning = true;
		[{
			params["_heli"];
			fza_ah64_tadsLockCheckRunning = false;
			if (NOTVISIBLEFROMTADS(_heli, _heli getVariable "fza_ah64_tadsLocked")) then {
				_heli setVariable["fza_ah64_tadsLocked", objNull, true];
			}
		}, _heli, 2] call CBA_fnc_waitAndExecute;
	}
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
    if (WEP_TYPE(_heliPylons# 0) == "rocket") then {
        _heli animateSource["pylon1", _pylonAdjustment, true];
    } else {
		_heli animateSource["pylon1", 0];
	};
    if (WEP_TYPE(_heliPylons# 4) == "rocket") then {
		_heli animateSource["pylon2", _pylonAdjustment, true];
	} else {
		_heli animateSource["pylon2", 0];
	};
	if (WEP_TYPE(_heliPylons# 8) == "rocket") then {
		_heli animateSource["pylon3", _pylonAdjustment, true];
	} else {
		_heli animateSource["pylon3", 0];
	};
	if (WEP_TYPE(_heliPylons# 12) == "rocket") then {
		_heli animateSource["pylon4", _pylonAdjustment, true];
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
		_heli selectweapon "fza_burstlimiter";
    };
	_heli animateSource["mainTurret", [_pan, rad -86, rad 86] call BIS_fnc_clamp];
	_heli animateSource["mainGun", [_tilt, rad -60, rad 11] call BIS_fnc_clamp];
} else {
	_heli animateSource["mainTurret", 0];
	_heli animateSource["mainGun", 0.298];
};
_heli setVariable ["fza_ah64_weaponInhibited", _inhibit];