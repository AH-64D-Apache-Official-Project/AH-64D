/* ----------------------------------------------------------------------------
Function: fza_fnc_radialItems

Description:
    The sectors of a radial menu, with what can be selected now and what is
    selected. The sub menus have their modes on the top half and their fields
    of view on the bottom, both left to right. The actions are the crew
    station's own controls (fza_fnc_coreControlHandle), so a sector does
    exactly what its key does; the greying only shows what the key would
    refuse. The FCR and TADS menus offer only the modes and fields of view
    that can be changed to: what is selected is shown in the hub instead.

Parameters:
    _heli - The helicopter
    _menu - "top", "fcr" or "tads"

Returns:
    [sectors, hub text], the sectors [[label, from bearing, to bearing,
    enabled, active, action], ...], bearings clockwise from up in degrees,
    the action user action names separated by ",", then ">" and a menu to open after them; the hub text "" for the
    menu's name

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\bmkhs_helisim\functions\systems\systems.hpp"
params ["_heli", "_menu"];

if (isNull _heli) exitWith {[[], ""]};

private _seat     = [_heli] call fza_fnc_getSeat;
private _isCpg    = player == gunner _heli;
private _hasFcr   = _heli animationPhase "fcr_enable" == 1;
private _sight    = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
private _tadsNvs  = (([_heli] call fza_ihadss_fnc_tadsNvs) # 0) != NVS_MODE_OFF;
private _fcrOwned = FCR_OWNER(_heli) == _seat;

// Sectors between two bearings, left to right; with _changeOnly, only those that can be selected and are not already
private _split = {
    params ["_entries", "_top", ["_changeOnly", false]];
    if (_changeOnly) then {_entries = _entries select {(_x # 1) && {!(_x # 2)}}};
    private _n    = count _entries;
    private _span = 180 / (_n max 1);
    private _out = [];
    {
        private _from = [270 - (_forEachIndex + 1) * _span, 270 + _forEachIndex * _span] select _top;
        _out pushBack [_x # 0, _from, _from + _span, _x # 1, _x # 2, _x # 3];
    } forEach _entries;
    _out
};

private _fovLetters = ["W", "M", "N", "Z"];
private _hub = "";
private _sectors = switch (_menu) do {
    case "fcr": {
        private _mode = _heli getVariable ["fza_ah64_fcrMode", FCR_DISP_MODE_GTM];
        private _size = _heli getVariable ["fza_ah64_fcrScanSize", 0];
        _hub = format ["%1 %2", ["", "GTM", "ATM", "RMAP", "TPM"] param [_mode, ""], _fovLetters param [_size, ""]];
        ([[
            ["GTM",  _fcrOwned, _mode == FCR_DISP_MODE_GTM,  "fza_ah64_fcrModeGTM"],
            ["RMAP", _fcrOwned, _mode == FCR_DISP_MODE_RMAP, "fza_ah64_fcrModeRMAP"],
            ["ATM",  _fcrOwned, _mode == FCR_DISP_MODE_ATM,  "fza_ah64_fcrModeATM"],
            ["TPM",  _fcrOwned, _mode == FCR_DISP_MODE_TPM,  "fza_ah64_fcrModeTPM"]
        ], true, true] call _split) + ([[
            ["W", _fcrOwned, _size == 0, "fza_ah64_fcrScanSize_W"],
            ["M", _fcrOwned, _size == 1, "fza_ah64_fcrScanSize_M"],
            ["N", _fcrOwned, _size == 2, "fza_ah64_fcrScanSize_N"],
            ["Z", _fcrOwned, _size == 3, "fza_ah64_fcrScanSize_Z"]
        ], false, true] call _split)
    };
    case "tads": {
        private _sensor = _heli getVariable ["fza_ah64_tadsSelectedSensor", "FLIR"];
        private _fov    = _heli getVariable ["fza_ah64_tadsSelectedFov", 0];
        private _can    = _isCpg && {!_tadsNvs};
        // The sensor keys do nothing under A3TI's own FLIR
        private _canSel = _can && {([_heli] call fza_ihadss_fnc_getVisionMode) != 1};
        private _dtvOk  = _heli getHitPointDamage "hit_msnEquip_tads_dtv" < SYS_SIGHT_DMG_THRESH;
        private _flirOk = _heli getHitPointDamage "hit_msnEquip_tads_flir" < SYS_SIGHT_DMG_THRESH;
        _hub = format ["%1 %2", _sensor, _fovLetters param [_fov, ""]];
        ([[
            ["DVO",  _canSel && _dtvOk,  _sensor == "DVO",  "fza_ah64_SensorSelect_DVO"],
            ["DTV",  _canSel && _dtvOk,  _sensor == "DTV",  "fza_ah64_SensorSelect_DTV"],
            ["FLIR", _canSel && _flirOk, _sensor == "FLIR", "fza_ah64_SensorSelect_FLIR"]
        ], true, true] call _split) + ([[
            // The DTV has no medium field of view, the DVO only wide and medium
            ["W", _can,                                    _fov == 0, "fza_ah64_tadsLHGFov_W"],
            ["M", _can && {_sensor != "DTV"},              _fov == 1, "fza_ah64_tadsLHGFov_M"],
            ["N", _can && {_sensor != "DVO"},              _fov == 2, "fza_ah64_tadsLHGFov_N"],
            ["Z", _can && {_sensor != "DVO"},              _fov == 3, "fza_ah64_tadsLHGFov_Z"]
        ], false, true] call _split)
    };
    default {
        // The sights the crew station can select over the top two thirds, left to right, each the keys that get there
        // from the sight and link as they are: selecting another sight drops the link, LINK toggles it. TADS and TADSL
        // open the TADS menu, FCR and FCRL the FCR's. The NVS select across the bottom third, to the other sensor than
        // the crew station has.
        private _link    = CPG_LINK(_heli);
        private _canTads = _isCpg && {!_tadsNvs};
        private _canLink = _isCpg && {_hasFcr};
        private _to = {
            params ["_target", "_select", "_linked", "_menu"];
            private _keys = [];
            if (_sight != _target) then {
                _keys pushBack _select;
                if (_linked) then {_keys pushBack "fza_ah64_sightSelectLink"};
            } else {
                if (_linked != _link) then {_keys pushBack "fza_ah64_sightSelectLink"};
            };
            (_keys joinString ",") + ">" + _menu
        };
        private _sights = [
            ["TADSL", _canTads && {_canLink},  _sight == SIGHT_TADS && {_link},       [SIGHT_TADS, "fza_ah64_sightSelectTADS", true, "tads"] call _to],
            ["TADS",  _canTads,                _sight == SIGHT_TADS && {!_link},      [SIGHT_TADS, "fza_ah64_sightSelectTADS", false, "tads"] call _to],
            ["HMD",   true,                    _sight == SIGHT_HMD,                   "fza_ah64_sightSelectHMD"],
            ["FCR",   _hasFcr,                 _sight == SIGHT_FCR && {!_link},       [SIGHT_FCR, "fza_ah64_sightSelectFCR", false, "fcr"] call _to],
            ["FCRL",  _canLink,                _sight == SIGHT_FCR && {_link},        [SIGHT_FCR, "fza_ah64_sightSelectFCR", true, "fcr"] call _to]
        ] select {_x # 1};
        private _span = 240 / ((count _sights) max 1);
        private _out  = [];
        {
            _x params ["_label", "_enabled", "_active", "_action"];
            _out pushBack [_label, 240 + _forEachIndex * _span, 240 + (_forEachIndex + 1) * _span, _enabled, _active, _action];
        } forEach _sights;
        // Greyed while the crew station's NVS mode is off
        private _nvsOn     = (_heli getVariable ["fza_ah64_nvsMode_" + _seat, NVS_MODE_OFF]) != NVS_MODE_OFF;
        private _nvsIsTads = (_heli getVariable ["fza_ah64_nvsTadsSeat", "cpg"]) == _seat;
        _out pushBack [["NVS TADS", "NVS PNVS"] select _nvsIsTads, 120, 240, _nvsOn, false, ["fza_ah64_nvsSelectTads", "fza_ah64_nvsSelectPnvs"] select _nvsIsTads];
        _out
    };
};

[_sectors, _hub]
