/* ----------------------------------------------------------------------------
Function: fza_fnc_radialItems

Description:
    The sectors of a radial menu, with what can be selected now and what is
    selected. The sub menus have their modes on the top half and their fields
    of view on the bottom, both left to right. The actions are the crew
    station's own controls (fza_fnc_coreControlHandle), so a sector does
    exactly what its key does; the greying only shows what the key would
    refuse.

Parameters:
    _heli - The helicopter
    _menu - "top", "fcr", "tads" or "sensors"

Returns:
    [[label, from bearing, to bearing, enabled, active, action], ...], bearings
    clockwise from up in degrees, the action a user action name or "menu:<name>"

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\bmkhs_helisim\functions\systems\systems.hpp"
params ["_heli", "_menu"];

if (isNull _heli) exitWith {[]};

private _seat     = [_heli] call fza_fnc_getSeat;
private _isCpg    = player == gunner _heli;
private _hasFcr   = _heli animationPhase "fcr_enable" == 1;
private _sight    = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
private _tadsNvs  = (([_heli] call fza_ihadss_fnc_tadsNvs) # 0) != NVS_MODE_OFF;
private _fcrOwned = FCR_OWNER(_heli) == _seat;

// Sectors between two bearings, left to right
private _split = {
    params ["_entries", "_top"];
    private _n    = count _entries;
    private _span = 180 / (_n max 1);
    private _out = [];
    {
        private _from = [270 - (_forEachIndex + 1) * _span, 270 + _forEachIndex * _span] select _top;
        _out pushBack [_x # 0, _from, _from + _span, _x # 1, _x # 2, _x # 3];
    } forEach _entries;
    _out
};

switch (_menu) do {
    case "fcr": {
        private _mode = _heli getVariable ["fza_ah64_fcrMode", FCR_DISP_MODE_GTM];
        private _size = _heli getVariable ["fza_ah64_fcrScanSize", 0];
        ([[
            ["GTM",  _fcrOwned, _mode == FCR_DISP_MODE_GTM,  "fza_ah64_fcrModeGTM"],
            ["RMAP", _fcrOwned, _mode == FCR_DISP_MODE_RMAP, "fza_ah64_fcrModeRMAP"],
            ["ATM",  _fcrOwned, _mode == FCR_DISP_MODE_ATM,  "fza_ah64_fcrModeATM"],
            ["TPM",  _fcrOwned, _mode == FCR_DISP_MODE_TPM,  "fza_ah64_fcrModeTPM"]
        ], true] call _split) + ([[
            ["W", _fcrOwned, _size == 0, "fza_ah64_fcrScanSize_W"],
            ["M", _fcrOwned, _size == 1, "fza_ah64_fcrScanSize_M"],
            ["N", _fcrOwned, _size == 2, "fza_ah64_fcrScanSize_N"],
            ["Z", _fcrOwned, _size == 3, "fza_ah64_fcrScanSize_Z"]
        ], false] call _split)
    };
    case "tads": {
        private _sensor = _heli getVariable ["fza_ah64_tadsSelectedSensor", "FLIR"];
        private _fov    = _heli getVariable ["fza_ah64_tadsSelectedFov", 0];
        private _can    = _isCpg && {!_tadsNvs};
        // The sensor keys do nothing under A3TI's own FLIR
        private _canSel = _can && {([_heli] call fza_ihadss_fnc_getVisionMode) != 1};
        private _dtvOk  = _heli getHitPointDamage "hit_msnEquip_tads_dtv" < SYS_SIGHT_DMG_THRESH;
        private _flirOk = _heli getHitPointDamage "hit_msnEquip_tads_flir" < SYS_SIGHT_DMG_THRESH;
        ([[
            ["DVO",  _canSel && _dtvOk,  _sensor == "DVO",  "fza_ah64_SensorSelect_DVO"],
            ["DTV",  _canSel && _dtvOk,  _sensor == "DTV",  "fza_ah64_SensorSelect_DTV"],
            ["FLIR", _canSel && _flirOk, _sensor == "FLIR", "fza_ah64_SensorSelect_FLIR"]
        ], true] call _split) + ([[
            // The DTV has no medium field of view, the DVO only wide and medium
            ["W", _can,                                    _fov == 0, "fza_ah64_tadsLHGFov_W"],
            ["M", _can && {_sensor != "DTV"},              _fov == 1, "fza_ah64_tadsLHGFov_M"],
            ["N", _can && {_sensor != "DVO"},              _fov == 2, "fza_ah64_tadsLHGFov_N"],
            ["Z", _can && {_sensor != "DVO"},              _fov == 3, "fza_ah64_tadsLHGFov_Z"]
        ], false] call _split)
    };
    case "sensors": {
        private _nvsOn     = (_heli getVariable ["fza_ah64_nvsMode_" + _seat, NVS_MODE_OFF]) != NVS_MODE_OFF;
        private _nvsIsTads = (_heli getVariable ["fza_ah64_nvsTadsSeat", "cpg"]) == _seat;
        ([[
            ["HMD",  true,                                                             _sight == SIGHT_HMD,  "fza_ah64_sightSelectHMD"],
            ["TADS", _isCpg && {!_tadsNvs},                                            _sight == SIGHT_TADS, "fza_ah64_sightSelectTADS"],
            ["FCR",  _hasFcr,                                                          _sight == SIGHT_FCR,  "fza_ah64_sightSelectFCR"],
            ["LINK", _isCpg && {_hasFcr} && {!_tadsNvs} && {_sight in [SIGHT_TADS, SIGHT_FCR]}, CPG_LINK(_heli),  "fza_ah64_sightSelectLink"]
        ], true] call _split) + ([[
            ["NVS TADS", _nvsOn, _nvsIsTads,  "fza_ah64_nvsSelectTads"],
            ["NVS PNVS", _nvsOn, !_nvsIsTads, "fza_ah64_nvsSelectPnvs"]
        ], false] call _split)
    };
    default {
        // FCR with the FCR the crew station's sight, or the CPG's TADS linked to it
        private _fcrSight = _hasFcr && {_fcrOwned} && {_sight == SIGHT_FCR || {_isCpg && {_sight == SIGHT_TADS} && {CPG_LINK(_heli)}}};
        [
            ["FCR",     _fcrSight,             false, "menu:fcr",     300, 420],
            ["TADS",    _isCpg && {!_tadsNvs}, false, "menu:tads",    60,  180],
            ["SENSORS", true,                  false, "menu:sensors", 180, 300]
        ] apply {
            _x params ["_label", "_enabled", "_active", "_action", "_from", "_to"];
            [_label, _from, _to, _enabled, _active, _action]
        }
    };
};
