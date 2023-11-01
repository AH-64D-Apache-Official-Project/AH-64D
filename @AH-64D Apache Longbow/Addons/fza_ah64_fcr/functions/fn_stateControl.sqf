/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_stateControl

Description:
    Handles repetitive target management. Should be run regularly in the scheduler.

Parameters:
    _heli - The helicopter to act on

Returns:
    Nothing
    
Examples:
    --- Code
    [_heli] call fza_fcr_fnc_stateControl
    ---
    
Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

private _fcrDamage   = _heli getHitPointDamage "hit_msnequip_fcr";
private _currentTgts = _heli getVariable "fza_ah64_fcrTargets";
private _acBusOn     = _heli getVariable "fza_systems_acBusOn";
private _dcBusOn     = _heli getVariable "fza_systems_dcBusOn";
private _fcrState    = _heli getVariable "fza_ah64_fcrState";
Private _fcrMode     = _heli Getvariable "fza_ah64_fcrMode";
private _armaRadarOn = isVehicleRadarOn vehicle player;
private _updateDelay = [4,7.7] select (_fcrMode == 2);

if (!_acBusOn || !_dcBusOn || _fcrDamage >= SYS_FCR_DMG_THRESH) exitwith {
    private _lastScanState = _heli getVariable "fza_ah64_fcrLastScan";
    if (_fcrState != FCR_MODE_OFF) then {
        _heli setVariable ["fza_ah64_fcrState", [FCR_MODE_OFF, _lastScanState # 2], true];
    };
    if _armaRadarOn then {
        _heli action ["ActiveSensorsOff", _heli];
    };
    if (_currentTgts isNotEqualTo []) then {
        _heli setVariable ["fza_ah64_fcrNts", [objNull,[0,0,0]], true];
        _heli setVariable ["fza_ah64_fcrTargets", [], true];
        _heli setVariable ["fza_ah64_fcrLastScan", [direction _heli, getposasl _heli, time], true];
    };
};

switch (_fcrState # 0) do {
    case FCR_MODE_OFF: {
        if _armaRadarOn then {
            _heli setVariable ["fza_ah64_fcrState", [FCR_MODE_ON_CONTINUOUS, time], true];
        };
    };
    case FCR_MODE_ON_SINGLE: {
        private _lastScanState = _heli getVariable "fza_ah64_fcrLastScan";
        if (time >= _fcrstate # 1 + _updateDelay && _lastScanState # 2 < _fcrState # 1) exitwith {
            [_heli] call fza_fcr_fnc_update;
        };
        if (time >= (_fcrState # 1 + _updateDelay) && _lastScanState # 2 <= time) exitwith {
            _heli setVariable ["fza_ah64_fcrState", [FCR_MODE_OFF, time], true];
            _heli action ["ActiveSensorsOff", _heli];
        };
        _heli action ["ActiveSensorsOn", vehicle player];
    };
    case FCR_MODE_ON_CONTINUOUS: {
        if _armaRadarOn exitwith {
            private _lastScanState = _heli getVariable "fza_ah64_fcrLastScan";
            if (time >= _lastScanState # 2 + _updateDelay && time >= _fcrState # 1 + _updateDelay) then {
                [_heli] call fza_fcr_fnc_update;
            };
        };
        _heli setVariable ["fza_ah64_fcrState", [FCR_MODE_OFF, time], true];
    };
};