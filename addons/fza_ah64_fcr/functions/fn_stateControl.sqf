/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_stateControl

Description:
    Manages FCR scan state transitions. Called each frame from fn_controller.

Parameters:
    _heli - The helicopter to act on

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\bmkhs_helisim\functions\systems\systems.hpp"
params ["_heli"];

if (!local _heli) exitWith {};

private _fcrDamage   = _heli getHitPointDamage "hit_msnEquip_fcr";
private _acBusOn     = _heli getVariable "bmkhs_acBusOn";
private _dcBusOn     = _heli getVariable "bmkhs_dcBusOn";
private _fcrMode     = _heli getVariable "fza_ah64_fcrMode";
_heli getVariable "fza_ah64_fcrState" params ["_fcrScanState", "_fcrScanStartTime"];
private _armaRadarOn = isVehicleRadarOn _heli;

// TPM sector follows groundspeed, wide below 45 kts and narrow above 55 kts
if (_fcrMode == FCR_DISP_MODE_TPM) then {
    private _vel     = velocity _heli;
    private _gsKts   = (sqrt ((_vel # 0) ^ 2 + (_vel # 1) ^ 2)) * 1.94384;
    private _tpmHalf = _heli getVariable ["fza_ah64_fcrTpmHalfFov", 90];
    private _newHalf = _tpmHalf;
    if (_gsKts < 45) then { _newHalf = 90; };
    if (_gsKts > 55) then { _newHalf = 45; };
    if (_newHalf != _tpmHalf) then {
        _heli setVariable ["fza_ah64_fcrTpmHalfFov", _newHalf, true];
    };
};

private _fullCycle   = ([_heli] call fza_fcr_fnc_getScanTiming) # 1;
private _onGnd       = [_heli] call bmkhs_fnc_stateOnGround;
private _gndOrideOn  = _heli getVariable "fza_ah64_gndOrideOn";

if (_armaRadarOn) then {
    if (_fcrDamage >= SYS_FCR_DMG_THRESH || ((!_acBusOn || !_dcBusOn) && !_onGnd)) exitWith {
        [_heli, "fza_ah64_fcrWaitingForStart", false] call fza_fnc_updateNetworkGlobal;
        [_heli, "fza_ah64_fcrState", [FCR_MODE_FAULT, _fcrScanStartTime]] call fza_fnc_updateNetworkGlobal;
    };
    if (((!_acBusOn || !_dcBusOn) || !_gndOrideOn) && _onGnd) exitWith {
        [_heli, "fza_ah64_fcrWaitingForStart", false] call fza_fnc_updateNetworkGlobal;
        [_heli, "fza_ah64_fcrState", [FCR_MODE_OFF, _fcrScanStartTime]] call fza_fnc_updateNetworkGlobal;
        player action ["ActiveSensorsOff", _heli];
    };
};

// The FCR's one cadence: everything it shows is updated once, as each full scan cycle completes, from what that
// cycle saw (fza_fcr_fnc_update). Returns the number of full cycles completed since the scan started.
private _cycleUpdate = {
    if (_heli getVariable ["fza_ah64_fcrWaitingForStart", false] || {CBA_missionTime < _fcrScanStartTime}) exitWith {0};
    private _cycleNow = floor ((CBA_missionTime - _fcrScanStartTime) / _fullCycle);
    (_heli getVariable ["fza_fcr_cycleDone", [-1, 0]]) params ["_doneStart", "_doneCycle"];
    if (_doneStart != _fcrScanStartTime) then {_doneCycle = 0};
    if (_cycleNow > _doneCycle) then {
        _heli setVariable ["fza_fcr_cycleDone", [_fcrScanStartTime, _cycleNow]];
        [_heli] call fza_fcr_fnc_update;
    };
    _cycleNow
};

// The crewmember always starts a scan, never the FCR: continuous scan starts only on the radar being switched on (the
// vanilla radar toggle), not on it simply being on, so a radar outliving any stop never restarts a scan
private _radarSwitchedOn = _armaRadarOn && {!(_heli getVariable ["fza_fcr_radarWasOn", false])};
_heli setVariable ["fza_fcr_radarWasOn", _armaRadarOn];

switch _fcrScanState do {
    case FCR_MODE_OFF: {
        if !_armaRadarOn exitWith {};
        // Held off: on without having just been switched on, or with no crew station owning the FCR as its sight
        if (!_radarSwitchedOn || {FCR_OWNER(_heli) == ""}) exitWith {
            player action ["ActiveSensorsOff", _heli];
        };
        [_heli, FCR_MODE_ON_CONTINUOUS] call fza_fcr_fnc_armScanStart;
        [_heli, "fza_ah64_fcrTargets", []] call fza_fnc_updateNetworkGlobal;
        [_heli, true, true] call fza_fcr_fnc_videoClear;
    };
    case FCR_MODE_ON_SINGLE: {
        // Scans per single scanburst W2/M2/N3/Z4 (GTM/RMAP)
        private _burstScans = [FCR_BURST_SCANS select (_heli getVariable ["fza_ah64_fcrScanSize", 0]), 2] select (_fcrMode == FCR_DISP_MODE_ATM);
        if ((call _cycleUpdate) >= _burstScans) exitWith {
            [_heli, "fza_ah64_fcrWaitingForStart", false] call fza_fnc_updateNetworkGlobal;
            [_heli, "fza_ah64_fcrState", [FCR_MODE_OFF, CBA_missionTime]] call fza_fnc_updateNetworkGlobal;
            player action ["ActiveSensorsOff", _heli];
        };
        if (!_armaRadarOn) then { player action ["ActiveSensorsOn", _heli]; };
    };
    case FCR_MODE_ON_CONTINUOUS: {
        if _armaRadarOn exitWith { call _cycleUpdate; };
        [_heli, "fza_ah64_fcrWaitingForStart", false] call fza_fnc_updateNetworkGlobal;
        [_heli, "fza_ah64_fcrState", [FCR_MODE_OFF, CBA_missionTime]] call fza_fnc_updateNetworkGlobal;
    };
    case FCR_MODE_FAULT: {
        if _armaRadarOn then {
            player action ["ActiveSensorsOff", _heli];
        };
        if (_acBusOn && _dcBusOn && _fcrDamage < SYS_FCR_DMG_THRESH) then {
            [_heli, "fza_ah64_fcrWaitingForStart", false] call fza_fnc_updateNetworkGlobal;
            [_heli, "fza_ah64_fcrState", [FCR_MODE_OFF, CBA_missionTime]] call fza_fnc_updateNetworkGlobal;
        };
    };
};
