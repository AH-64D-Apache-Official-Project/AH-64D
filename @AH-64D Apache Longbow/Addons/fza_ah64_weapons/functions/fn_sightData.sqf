/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_sightData

Description:
    Points turrets, sensors and weaponry at the correct positions according to acquisition sources.

Parameters:
    _heli - the heli to fix the turret for.

Returns:
    Nothing

Examples:
    [_heli] call fza_weapons_fnc_TurretAim

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_systems\headers\systems.hpp"
#include "\fza_ah64_sfmplus\headers\core.hpp"
params["_heli"];

private _currentTurret = _heli call fza_fnc_currentTurret;
private _gunnnerUnit = _heli turretUnit [0];    

private _sight           = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
private _was             = [_heli, "fza_ah64_was"] call fza_fnc_getSeatVariable;
private _wasother        = [_heli, "fza_ah64_was", player, true] call fza_fnc_getSeatVariable;
private _nts             = (_heli getVariable "fza_ah64_fcrNts") # 0;
private _ntspos          = (_heli getVariable "fza_ah64_fcrNts") # 1;
private _inhibit         = "";
private _targVel         = [0, 0, 0];
private _targPos         = [0, 0, 0];
private _worldTargetpos  = [0, 0, 0];

private _acBusOn       = _heli getVariable "fza_systems_acBusOn";
private _posTADS = objNull;

if !_acBusOn then {
    _sight = SIGHT_FXD;
};

switch (_sight) do {
    case SIGHT_FCR:{
        _targpos = _heli modelToWorldVisual [0,1000,0];
        if (!isNull _nts) exitwith {
            _targPos = _ntspos;
            if (isVehicleRadarOn _heli) then {
                _targPos = aimPos _nts;
                _targVel = velocity _nts;
            };
            _posTADS = _targPos;
        };
        _posTADS = _targPos;
        _inhibit = "NO TARGET";
    };
    case SIGHT_HMD:{
        _targPos = aglToAsl (positionCameraToWorld [0, 0, 1000]);
        if (cameraView == "GUNNER") exitwith {};
        _posTADS = _targPos;
    };
    case SIGHT_TADS:{
        _camPosASL = _heli modelToWorldVisualWorld (_heli selectionPosition "laserEnd");
        _worldTargetpos = _camPosASL vectorAdd (([_heli, "TADS"] call fza_fnc_targetingAcqVec) vectorMultiply 50000);
        _targPos = terrainIntersectAtASL [_camPosASL, _worldTargetpos];
    };
    case SIGHT_FXD:{
        _posTADS = _heli modelToWorldVisual [0,1000,0];
    };
};

if ((_currentTurret isEqualTo [0] || !(isplayer _gunnnerUnit)) && !(_heli getVariable "fza_ah64_LmcActive")) then {
    _heli lockCameraTo [_posTADS, [0], false];
};

private _targDistance = _heli distance _targPos;
if (_targPos isequalto [0,0,0] && _sight == SIGHT_TADS) then {
    _targDistance = 1000;
    _targPos = _worldTargetpos;
};

[_targPos, _targVel, _targDistance, _inhibit]