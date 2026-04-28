/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_sightData

Description:
    Resolves the current player's active sight/acquisition source into a target
    position, velocity, distance, and any inhibit message. Also manages camera
    locking for non-TADS sights.

Parameters:
    _heli - The helicopter

Returns:
    Array - [_targPos, _targVel, _targDistance, _inhibit]
    _targPos     - ASL world position of the computed target
    _targVel     - Velocity vector of the target (for lead computation)
    _targDistance - Distance in metres from heli to target
    _inhibit     - Inhibit string ("" = no inhibit)

Examples:
    (_heli call fza_weapons_fnc_sightData) params ["_tPos", "_tVel", "_tDist", "_inh"];

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

private _currentTurret  = _heli call fza_fnc_currentTurret;
private _gunnerUnit     = _heli turretUnit [0];
private _sight          = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
private _nts            = (_heli getVariable "fza_ah64_fcrNts") # 0;
private _ntsPos         = (_heli getVariable "fza_ah64_fcrNts") # 1;
private _acBusOn        = _heli getVariable "fza_systems_acBusOn";
private _inhibit        = "";
private _targVel        = [0, 0, 0];
private _targPos        = [0, 0, 0];
private _worldTargetPos = [0, 0, 0];
private _cameraTarget   = [0, 0, 0];

if (!_acBusOn) then {
    _sight = SIGHT_FXD;
};

switch (_sight) do {
    case SIGHT_FCR: {
        _targPos      = _heli modelToWorldVisual [0, 1000, 0];
        _cameraTarget = _targPos;
        if (!isNull _nts) exitWith {
            _targPos = _ntsPos;
            if (isVehicleRadarOn _heli) then {
                _targPos = aimPos _nts;
                _targVel = velocity _nts;
            };
            _cameraTarget = _targPos;
        };
        _inhibit = "NO TARGET";
    };
    case SIGHT_HMD: {
        _targPos = AGLToASL (positionCameraToWorld [0, 0, 1000]);
        if (cameraView == "GUNNER") exitWith {};
        _cameraTarget = _targPos;
    };
    case SIGHT_TADS: {
        private _camPosASL = _heli modelToWorldVisualWorld (_heli selectionPosition "laserEnd");
        _worldTargetPos    = _camPosASL vectorAdd (([_heli, "TADS"] call fza_sights_fnc_targetingAcqVec) vectorMultiply 50000);
        _targPos           = terrainIntersectAtASL [_camPosASL, _worldTargetPos];

        if (_heli getVariable "fza_ah64_LmcActive") then {
            private _lmcPos = _heli getVariable ["fza_ah64_lmcPosition", []];
            if !(_lmcPos isEqualTo []) then {
                _targPos = _lmcPos;
                _targVel = _heli getVariable ["fza_ah64_lmcVelocity", [0,0,0]];
            };
        };
    };
    case SIGHT_FXD: {
        _cameraTarget = _heli modelToWorldVisual [0, 1000, 0];
        _targPos      = _cameraTarget;
    };
};

// Lock camera for non-TADS sights; release (objNull) in TADS mode so the turret moves freely
if ((_currentTurret isEqualTo [0] || !(isPlayer _gunnerUnit)) && !(_heli getVariable "fza_ah64_LmcActive")) then {
    private _lockTarget = if (_cameraTarget isNotEqualTo [0,0,0]) then {_cameraTarget} else {objNull};
    _heli lockCameraTo [_lockTarget, [0], true];
};

private _targDistance = _heli distance _targPos;
if (_targPos isEqualTo [0, 0, 0] && _sight == SIGHT_TADS) then {
    _targDistance = 1000;
    _targPos      = _worldTargetPos;
};

[_targPos, _targVel, _targDistance, _inhibit]
