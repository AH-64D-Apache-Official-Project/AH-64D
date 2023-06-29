/* ----------------------------------------------------------------------------
Function: fza_fnc_targetingSched
Description:
    Handles repetitive target management. Should be run regularly in the scheduler.
Parameters:
    _heli - The helicopter to act on
Returns:
    Nothing
Examples:
    --- Code
    [_heli] call fza_fnc_targetingSched
    ---
Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];
if (!(player in _heli)) exitwith {};

if (_heli animationPhase "fcr_enable" == 1 && local _heli) then {
    private _fcrState    = _heli getVariable "fza_ah64_fcrState";
    Private _fcrMode = _heli Getvariable "fza_ah64_fcrMode";
    private _armaRadarOn = isVehicleRadarOn vehicle player;
    private _fcrUpdateDelay = 4;
    if (_fcrMode == 2) then {_fcrUpdateDelay = 7.7};

    switch (_fcrState # 0) do {
        case FCR_MODE_OFF: {
            if _armaRadarOn then {
                _heli setVariable ["fza_ah64_fcrState", [FCR_MODE_ON_CONTINUOUS, time], true];
            };
        };
        case FCR_MODE_ON_SINGLE: {
            private _lastScanState = _heli getVariable "fza_ah64_fcrLastScan";
            if (time >= _fcrstate # 1 + _fcrUpdateDelay && _lastScanState # 2 < _fcrState # 1) then {
                [_heli] call fza_fnc_targetingFCRUpdate;
            } else {
                if (time >= (_fcrState # 1 + _fcrUpdateDelay) && _lastScanState # 2 <= time) then {
                    _heli setVariable ["fza_ah64_fcrState", [FCR_MODE_OFF, time], true];
                    player action ["ActiveSensorsOff", _heli];
                } else {
                    player action ["ActiveSensorsOn", vehicle player];
                };
            };
        };
        case FCR_MODE_ON_CONTINUOUS: {
            if (_armaRadarOn) then {
                private _lastScanState = _heli getVariable "fza_ah64_fcrLastScan";
                if (time >= _lastScanState # 2 + _fcrUpdateDelay && time >= _fcrState # 1 + _fcrUpdateDelay) then {
                    [_heli] call fza_fnc_targetingFCRUpdate;
                }
            } else {
                _heli setVariable ["fza_ah64_fcrState", [FCR_MODE_OFF, time], true];
            };
        };
    };
};

// Auto self laser select
if (isNull (_heli getVariable "fza_ah64_currentlase") && !isNull laserTarget _heli) then {
    _heli setVariable ["fza_ah64_currentlase", laserTarget _heli, true];
};