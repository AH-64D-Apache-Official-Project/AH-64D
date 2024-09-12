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
#include "\fza_ah64_systems\headers\systems.hpp"
params ["_heli"];

private _fcrDamage   = _heli getHitPointDamage "hit_msnequip_fcr";
private _acBusOn     = _heli getVariable "fza_systems_acBusOn";
private _dcBusOn     = _heli getVariable "fza_systems_dcBusOn";
Private _fcrMode     = _heli Getvariable "fza_ah64_fcrMode";
_heli getVariable "fza_ah64_fcrState"    params ["_fcrScanState", "_fcrScanStartTime"];
_heli getVariable "fza_ah64_fcrLastScan" params ["_dir", "_scanPos", "_time"];
private _armaRadarOn = isVehicleRadarOn _heli;
private _updateDelay = [3.2,6.4] select (_fcrMode == 2);
private _onGnd       = [_heli] call fza_sfmplus_fnc_onGround;
private _gndOrideOn  = _heli getVariable "fza_ah64_gndOrideOn";

if (_armaRadarOn) then {
    if (_fcrDamage >= SYS_FCR_DMG_THRESH || ((!_acBusOn || !_dcBusOn) && !_onGnd)) exitwith {
        [_heli, "fza_ah64_fcrState", [FCR_MODE_FAULT, _lastScanState # 2]] call fza_fnc_updateNetworkGlobal;
    };
    if (((!_acBusOn || !_dcBusOn) && _onGnd) || (!_gndOrideOn && _onGnd)) then {
        [_heli, "fza_ah64_fcrState", [FCR_MODE_OFF, _lastScanState # 2]] call fza_fnc_updateNetworkGlobal;
        _heli action ["ActiveSensorsOff", _heli];
    };
};

//data proccessing
_heli call fza_fcr_fnc_dataHandling;

switch (_fcrState # 0) do {
    case FCR_MODE_OFF: {
        if _armaRadarOn then {
            _heli setVariable ["fza_ah64_fcrState", [FCR_MODE_ON_CONTINUOUS, time], true];
            _heli setVariable ["fza_ah64_fcrTargets", [], true];
        };
    };
    case FCR_MODE_ON_SINGLE: {
        if (time >= _fcrScanStartTime + _updateDelay && _time < _fcrScanStartTime) exitwith {
            [_heli] call fza_fcr_fnc_update;
        };
        if (time >= (_fcrScanStartTime + (_updateDelay * 2)) && _time <= time) exitwith {
            _heli setVariable ["fza_ah64_fcrState", [FCR_MODE_OFF, time], true];
            _heli action ["ActiveSensorsOff", _heli];
        };
        _heli action ["ActiveSensorsOn", vehicle player];
    };
    case FCR_MODE_ON_CONTINUOUS: {
        if _armaRadarOn exitwith {
            if (time >= _time + _updateDelay && time >= _fcrScanStartTime + _updateDelay) then {
                [_heli] call fza_fcr_fnc_update;
            };
        };
        _heli setVariable ["fza_ah64_fcrState", [FCR_MODE_OFF, time], true];
    };
    case FCR_MODE_FAULT: {
        if _armaRadarOn then {
            _heli action ["ActiveSensorsOff", _heli];
        };
        if (_acBusOn && _dcBusOn && _fcrDamage < SYS_FCR_DMG_THRESH) then {
            _heli setVariable ["fza_ah64_fcrState", [FCR_MODE_OFF, _time], true];
        };
    };
};