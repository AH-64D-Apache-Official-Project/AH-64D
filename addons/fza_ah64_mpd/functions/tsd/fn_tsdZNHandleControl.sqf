params ["_heli", "_mpdIndex", "_control", "_state", "_persistState"];
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_mpd\headers\tsd.hpp"
#include "\fza_ah64_dms\headers\constants.h"

private _variant = (_state get "subPageVarPage") # 1;
private _type = _persistState getOrDefault ["znType", ZONE_KIND_PF];
private _pfZones = _heli getVariable "fza_dms_pfZones";
private _nfZones = _heli getVariable "fza_dms_nfZones";
private _nfSel = _persistState getOrDefault ["znNfSel", 0];
private _pfSel = _persistState getOrDefault ["znPfSel", 0];
private _clearDraft = {_state set ["znDraft", []]};
private _toRoot = {_state set ["subPageVarPage", TSD_ZN]};
// ZN again: back to the TSD's top level
if (_control == "b3") exitWith {
    call _clearDraft;
    _state set ["subPageVarPage", TSD_ROOT];
};
// The zone buttons on NF SEL and ASN: 2 at T1, 1 at T2, 3-8 at L1-L6
private _slot = ["t2", "t1", "l1", "l2", "l3", "l4", "l5", "l6"] find _control;

switch (_variant) do {
    case 0: {
        switch (_control) do {
            case "b2": {
                private _draft = _state getOrDefault ["znDraft", []];
                if (_draft isEqualTo []) exitWith {};
                private _entries = _draft # 0;
                _entries deleteAt (count _entries - 1);
                [_heli, _state, _persistState] call fza_mpd_fnc_tsdZNApply;
                if (_entries isEqualTo []) then {call _clearDraft};
            };
            case "l1": {
                _persistState set ["znType", 1 - _type];
                call _clearDraft;
            };
            case "l4": {
                private _any = [_pfZones findIf {_x isNotEqualTo -1} != -1, (_nfZones # _nfSel) isNotEqualTo -1] select (_type == ZONE_KIND_NF);
                if (_any) then {
                    call _clearDraft;
                    _state set ["subPageVarPage", TSD_ZN_DEL];
                };
            };
            case "l6": {
                if (_type == ZONE_KIND_PF && {_persistState getOrDefault ["znOpt", 0] == 2}) exitWith {};
                _persistState set ["znDraw", 1 - (_persistState getOrDefault ["znDraw", 0])];
                call _clearDraft;
            };
        };
        if (_type == ZONE_KIND_PF) then {
            switch (_control) do {
                case "l2": {
                    _persistState set ["znOpt", ((_persistState getOrDefault ["znOpt", 0]) + 1) mod 3];
                    call _clearDraft;
                };
                case "l3": {
                    // The active PF zone, through those drawn and then none
                    private _drawn = [];
                    {if (_x isNotEqualTo -1) then {_drawn pushBack _forEachIndex}} forEach _pfZones;
                    if (_drawn isEqualTo []) exitWith {};
                    private _active = (_heli getVariable "fza_dms_zoneState") # ZONE_STATE_ACTIVE_PF;
                    private _next = _drawn param [(_drawn find _active) + 1, -1];
                    if (_next == -1) then {
                        [_heli, ZONE_KIND_PF, _active, false] call fza_dms_fnc_zoneActivate;
                    } else {
                        [_heli, ZONE_KIND_PF, _next, true] call fza_dms_fnc_zoneActivate;
                    };
                };
                case "l5": {
                    if (_persistState getOrDefault ["znOpt", 0] == 2) then {
                        _persistState set ["znKm", (_persistState getOrDefault ["znKm", 2]) mod 3 + 1];
                    } else {
                        _persistState set ["znCount", (_persistState getOrDefault ["znCount", 1]) mod ZONE_COUNT_PF + 1];
                    };
                    call _clearDraft;
                };
                case "t4": {
                    if (_pfZones findIf {_x isNotEqualTo -1} == -1) exitWith {};
                    call _clearDraft;
                    _state set ["subPageVarPage", TSD_ZN_ASN];
                };
            };
        } else {
            switch (_control) do {
                case "t1": {
                    if (_heli animationPhase "fcr_enable" == 1 && {((_heli getVariable ["fza_ah64_fcrState", [FCR_MODE_OFF]]) # 0) != FCR_MODE_OFF}) exitWith {};
                    private _zoneState = +(_heli getVariable "fza_dms_zoneState");
                    private _single = !(_zoneState # ZONE_STATE_NF_SINGLE);
                    _zoneState set [ZONE_STATE_NF_SINGLE, _single];
                    // SINGLE keeps one active: the chosen one, else the first
                    if (_single) then {
                        private _nf = _zoneState # ZONE_STATE_NF_ACTIVE;
                        private _keep = [_nf find true, _nfSel] select (_nf param [_nfSel, false]);
                        _zoneState set [ZONE_STATE_NF_ACTIVE, _nf apply {false}];
                        if (_keep != -1) then {(_zoneState # ZONE_STATE_NF_ACTIVE) set [_keep, true]};
                    };
                    [_heli, _zoneState] call fza_dms_fnc_zoneSetState;
                };
                case "l2": {
                    call _clearDraft;
                    _state set ["subPageVarPage", TSD_ZN_NF_SEL];
                };
                case "l3": {
                    if ((_nfZones # _nfSel) isEqualTo -1) exitWith {};
                    private _on = !(((_heli getVariable "fza_dms_zoneState") # ZONE_STATE_NF_ACTIVE) param [_nfSel, false]);
                    [_heli, ZONE_KIND_NF, _nfSel, _on] call fza_dms_fnc_zoneActivate;
                };
                case "b6": {
                    [_heli, _state, _persistState] call fza_mpd_fnc_tsdZNAccept;
                };
            };
        };
    };
    case 1: {
        if (_slot != -1) exitWith {
            _persistState set ["znNfSel", _slot];
            call _toRoot;
        };
    };
    case 2: {
        switch (_control) do {
            case "l2": {
                if (_type == ZONE_KIND_PF) then {
                    [_heli, ZONE_KIND_PF] call fza_dms_fnc_zoneClear;
                } else {
                    [_heli, ZONE_KIND_NF, _nfSel, -1] call fza_dms_fnc_zoneSet;
                };
                call _toRoot;
            };
            case "l3": {
                call _toRoot;
            };
        };
    };
    case 3: {
        if (_slot != -1) exitWith {
            if ((_pfZones # _slot) isNotEqualTo -1) then {_persistState set ["znPfSel", _slot]};
        };
        switch (_control) do {
            case "b6": {
                if ((_pfZones # _pfSel) isEqualTo -1) exitWith {};
                private _zoneState = +(_heli getVariable "fza_dms_zoneState");
                _zoneState set [ZONE_STATE_ACTIVE_PF, _pfSel];
                _zoneState set [ZONE_STATE_OWN_PF, _pfSel];
                [_heli, _zoneState] call fza_dms_fnc_zoneSetState;
            };
            case "t4": {
                call _toRoot;
            };
        };
    };
};
