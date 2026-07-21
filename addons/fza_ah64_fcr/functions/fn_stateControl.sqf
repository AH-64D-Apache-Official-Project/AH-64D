#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_systems\headers\systems.hpp"
params ["_heli"];

if (!local _heli) exitWith {};

private _fcrDamage   = _heli getHitPointDamage "hit_msnequip_fcr";
private _acBusOn     = _heli getVariable "fza_systems_acBusOn";
private _dcBusOn     = _heli getVariable "fza_systems_dcBusOn";
private _fcrMode     = _heli getVariable "fza_ah64_fcrMode";
_heli getVariable "fza_ah64_fcrState" params ["_fcrScanState", "_fcrScanStartTime"];
_heli getVariable "fza_ah64_fcrLastScan" params ["_dir", "_scanPos", "_time"];
private _armaRadarOn = isVehicleRadarOn _heli;
([_heli] call fza_fcr_fnc_getScanTiming) params ["_updateDelay", "_fullCycle"];
private _onGnd       = [_heli] call fza_sfmplus_fnc_onGround;
private _gndOrideOn  = _heli getVariable "fza_ah64_gndOrideOn";

// TM 4.42.1: a newly selected scan size is adopted at the beginning of the next scan —
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

switch _fcrScanState do {
    case FCR_MODE_OFF: {
        if _armaRadarOn then {
            [_heli, FCR_MODE_ON_CONTINUOUS] call fza_fcr_fnc_armScanStart;
            [_heli, "fza_ah64_fcrTargets", []] call fza_fnc_updateNetworkGlobal;
            _heli setVariable ["fza_ah64_fcrTPMHardClear",  true];
            _heli setVariable ["fza_ah64_fcrRMAPHardClear", true];
        };
    };
    case FCR_MODE_ON_SINGLE: {
        // TM 4.42.2a: scans per single scanburst W2/M2/N3/Z4 (GTM/RMAP)
        private _burstScans = [[2, 2, 3, 4] select (_heli getVariable ["fza_ah64_fcrScanSize", 0]), 2] select (_fcrMode == 2);
        if (CBA_missionTime >= _fcrScanStartTime + _fullCycle && _time < _fcrScanStartTime) exitWith {
            [_heli, true] call fza_fcr_fnc_update;
        };
        if (CBA_missionTime >= (_fcrScanStartTime + (_fullCycle * _burstScans)) && _time >= _fcrScanStartTime) exitWith {
            [_heli, true] call fza_fcr_fnc_update;
            [_heli, "fza_ah64_fcrWaitingForStart", false] call fza_fnc_updateNetworkGlobal;
            [_heli, "fza_ah64_fcrState", [FCR_MODE_OFF, CBA_missionTime]] call fza_fnc_updateNetworkGlobal;
            player action ["ActiveSensorsOff", _heli];
        };
        if (!_armaRadarOn) then { player action ["ActiveSensorsOn", _heli]; };
    };
    case FCR_MODE_ON_CONTINUOUS: {
        if _armaRadarOn exitWith {
            private _lastFullCycle = _heli getVariable ["fza_ah64_fcrLastFullCycle", 0];
            private _minStartDelay = [_updateDelay, _fullCycle] select (_time < _fcrScanStartTime);
            // ATM scans the full azimuth+range on every bar (rebound), so each bar is a
            // complete scan — treat every bar as a full cycle for update/merge/reveal.
            private _cycleRef    = [_fullCycle, _updateDelay] select (_fcrMode == FCR_DISP_MODE_ATM);
            private _isFullCycle = (CBA_missionTime - _lastFullCycle) >= _cycleRef;
            if (CBA_missionTime >= _time + _updateDelay && CBA_missionTime >= _fcrScanStartTime + _minStartDelay) then {
                [_heli, _isFullCycle] call fza_fcr_fnc_update;
            };
        };
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
