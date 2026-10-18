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
_heli getVariable "fza_ah64_fcrLastScan" params ["_dir", "_scanPos", "_time"];
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

([_heli] call fza_fcr_fnc_getScanTiming) params ["_updateDelay", "_fullCycle"];
private _onGnd       = [_heli] call bmkhs_fnc_stateOnGround;
private _gndOrideOn  = _heli getVariable "fza_ah64_gndOrideOn";

// A newly selected scan size is adopted at the beginning of the next scan —
// latch exactly at the cycle wrap (applyScanSize no-ops unless something changed)
if (_fcrScanState in [FCR_MODE_ON_SINGLE, FCR_MODE_ON_CONTINUOUS] && CBA_missionTime > _fcrScanStartTime) then {
    private _phase     = (CBA_missionTime - _fcrScanStartTime) % _fullCycle;
    private _prevPhase = _heli getVariable ["fza_ah64_fcrPrevCyclePhase", 0];
    _heli setVariable ["fza_ah64_fcrPrevCyclePhase", _phase];
    if (_phase < _prevPhase) then {
        [_heli] call fza_fcr_fnc_applyScanSize;
    };
};

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

// One snapshot per bar once the first full cycle is complete; the wiper reveals from the second sweep
private _barUpdate = {
    if (_heli getVariable ["fza_ah64_fcrWaitingForStart", false]) exitWith {};
    private _firstUpdate = _time < _fcrScanStartTime;
    private _barNow      = floor ((CBA_missionTime - _fcrScanStartTime) / _updateDelay);
    private _barLast     = [floor ((_time - _fcrScanStartTime) / _updateDelay), -1] select _firstUpdate;
    if (_barNow > _barLast && _barNow >= ([1, 2] select _firstUpdate)) then {
        // ATM rebounds over the whole sector on every bar, so each bar is a full cycle
        [_heli, _fcrMode == FCR_DISP_MODE_ATM || { (_barNow % 2) == 0 }] call fza_fcr_fnc_update;
    };
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
        private _burstScans = [[2, 2, 3, 4] select (_heli getVariable ["fza_ah64_fcrScanSize", 0]), 2] select (_fcrMode == FCR_DISP_MODE_ATM);
        if (CBA_missionTime >= (_fcrScanStartTime + (_fullCycle * _burstScans)) && _time >= _fcrScanStartTime) exitWith {
            [_heli, true] call fza_fcr_fnc_update;
            [_heli, "fza_ah64_fcrWaitingForStart", false] call fza_fnc_updateNetworkGlobal;
            [_heli, "fza_ah64_fcrState", [FCR_MODE_OFF, CBA_missionTime]] call fza_fnc_updateNetworkGlobal;
            player action ["ActiveSensorsOff", _heli];
        };
        call _barUpdate;
        if (!_armaRadarOn) then { player action ["ActiveSensorsOn", _heli]; };
    };
    case FCR_MODE_ON_CONTINUOUS: {
        if _armaRadarOn exitWith { call _barUpdate; };
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
