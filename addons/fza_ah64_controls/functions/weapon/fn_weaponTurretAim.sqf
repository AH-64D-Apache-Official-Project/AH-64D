/* ----------------------------------------------------------------------------
Function: fza_fnc_weaponTurretAim

Description:
    Points the TADS according to the CPG's sight and acquisition source, or
    the pilot's without a player CPG, and propagates its angles. The weapons
    are aimed by the crew station driving them (fza_fnc_weaponAim).

Parameters:
    _heli - the heli to fix the turret for.

Returns:
    Nothing

Examples:
    [_heli] call fza_fnc_weaponTurretAim

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\bmkhs_helisim\functions\systems\systems.hpp"
params["_heli"];

private _currentTurret = _heli call fza_fnc_currentTurret;
private _gunnnerUnit = _heli turretUnit [0];

if (_currentTurret isNotEqualTo [0] && (isPlayer _gunnnerUnit)) exitWith {};

// The turret's angles and the turn added while the TADS is an NVS sensor (fza_ihadss_fnc_tadsNvsControl), 0 otherwise
private _azimuth = -deg ((_heli animationPhase "tads_tur") + (_heli animationPhase "tads_nvs_tur"));
private _elevation = deg ((_heli animationPhase "tads") + (_heli animationPhase "tads_nvs"));
_heli setVariable ["fza_ah64_tadsAzimuth",   _azimuth];
_heli setVariable ["fza_ah64_tadsElevation", _elevation];

if (isMultiplayer && (_heli getVariable "fza_ah64_lastTimePropagated") + 0.1 < time) then {
{
    _heli setVariable [_x, _heli getVariable _x, true];
} forEach [
    "fza_ah64_tadsAzimuth",
    "fza_ah64_tadsElevation"
];
_heli setVariable ["fza_ah64_lastTimePropagated", time, true];
};

private _sight  = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
private _nts    = (_heli getVariable "fza_ah64_fcrNts") # 0;
private _ntspos = (_heli getVariable "fza_ah64_fcrNts") # 1;
private _cameraTarget = objNull;

// Without AC power the sights are fixed forward
if !(_heli getVariable "bmkhs_acBusOn") then {_sight = -1};

switch (_sight) do {
    case SIGHT_FCR:{
        private _targPos = _heli modelToWorldVisual [0,1000,0];
        if (!isNull _nts) then {
            _targPos = _ntspos;
            if (isVehicleRadarOn _heli) then {_targPos = aimPos _nts};
        };
        // The FCR commands the TADS only in FCR-L while slaved: on the NTS, jumping to each new one, fixed forward without
        // one. Otherwise the TADS is the CPG's to move as with TADS as the sight.
        if (CPG_LINK(_heli) && {_heli getVariable ["fza_ah64_cpgSlaved", false]}) then {
            _cameraTarget = [_targPos, _heli modelToWorldVisualWorld [0, 1000, 0]] select (isNull _nts);
        } else {
            if (player == gunner _heli && {cameraView != "GUNNER"}) then {
                _cameraTarget = [_heli] call fza_ihadss_fnc_tadsSlew;
            };
        };
    };
    case SIGHT_HMD:{
        // The TADS can be watched on an MPD with the HMD as the sight, so its slew is scaled the same
        if (player == gunner _heli && {cameraView != "GUNNER"}) then {
            _cameraTarget = [_heli] call fza_ihadss_fnc_tadsSlew;
        };
    };
    case SIGHT_TADS:{
        if (player == gunner _heli && {cameraView != "GUNNER"}) then {
            _cameraTarget = [_heli] call fza_ihadss_fnc_tadsSlew;
        };
        // Slaved, the TADS follows the CPG's acquisition source instead of the manual tracker
        if (_heli getVariable ["fza_ah64_cpgSlaved", false]) then {
            private _slavePos = [_heli, [_heli, [0]] call fza_fnc_targetingCurAcq] call fza_fnc_targetingAcqPoint;
            if (_slavePos isNotEqualTo []) then {_cameraTarget = _slavePos};
        };
    };
    default {
        _cameraTarget = _heli modelToWorldVisualWorld [0, 1000, 0];
    };
};

// With no player CPG the pilot's acquisition source points the TADS; TADS leaves it to the AI gunner to be driven
if (!isPlayer _gunnnerUnit && {_currentTurret isEqualTo [-1]}) then {
    private _acq = [_heli, [-1]] call fza_fnc_targetingCurAcq;
    _cameraTarget = objNull;
    if (_acq != "TADS") then {
        private _slavePos = [_heli, _acq] call fza_fnc_targetingAcqPoint;
        if (_slavePos isNotEqualTo []) then {_cameraTarget = _slavePos};
    };
};

// The TADS as an NVS sensor is turned by fza_ihadss_fnc_tadsNvsControl on top of the turret, which is held straight ahead:
// the CPG's view is referenced to the turret while not flying, so a turret following the head would turn the view with it
([_heli] call fza_ihadss_fnc_tadsNvs) params ["_nvsMode"];
private _tadsNvs = _nvsMode != NVS_MODE_OFF;
if _tadsNvs then {
    _cameraTarget = (_heli modelToWorldVisualWorld (_heli selectionPosition "laserEnd")) vectorAdd (_heli vectorModelToWorldVisual [0, 1000, 0]);
};

if ((_currentTurret isEqualTo [0] || !(isPlayer _gunnnerUnit)) && {_tadsNvs || {!(_heli getVariable "fza_ah64_LmcActive")}}) then {
    [_heli, _cameraTarget] call fza_fnc_targetingTadsLockTo;
};
