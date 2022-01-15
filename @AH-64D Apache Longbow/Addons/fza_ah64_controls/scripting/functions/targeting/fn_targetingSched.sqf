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
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];
if (!(player in _heli)) exitwith {};

if (_heli animationPhase "fcr_enable" == 1 && local _heli) then {
    private _fcrState = _heli getVariable "fza_ah64_fcrState";
    private _armaRadarOn = isVehicleRadarOn vehicle player;

    switch (_fcrState # 0) do {
        case FCR_MODE_OFF: {
            if _armaRadarOn then {
                _heli setVariable ["fza_ah64_fcrState", [FCR_MODE_ON_CONTINUOUS, time], true];
            };
        };
        case FCR_MODE_ON_SINGLE: {
            private _lastScanState = _heli getVariable "fza_ah64_fcrLastScan";
            if (time > _fcrstate # 1 + 3 && _lastScanState # 2 < _fcrState # 1) then {
                [_heli] call fza_fnc_targetingFCRUpdate;
                _heli setVariable ["fza_ah64_fcrLastScan", [direction _heli, getposasl _heli, time], true];
            } else {
                if (time > (_fcrState # 1 + 4) && _lastScanState # 2 + 1 < time) then {
                    _heli setVariable ["fza_ah64_fcrState", [FCR_MODE_OFF, time], true];
                    player action ["ActiveSensorsOff", _heli];
                };
            };
        };
        case FCR_MODE_ON_CONTINUOUS: {
            if (_armaRadarOn) then {
                private _lastScanState = _heli getVariable "fza_ah64_fcrLastScan";
                if (time > _lastScanState # 2 + 4 && time > _fcrState # 1 + 4) then {
                    [_heli] call fza_fnc_targetingFCRUpdate;
                    _heli setVariable ["fza_ah64_fcrLastScan", [direction _heli, getposasl _heli, time], true];
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