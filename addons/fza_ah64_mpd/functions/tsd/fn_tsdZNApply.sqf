#include "\fza_ah64_dms\headers\constants.h"
// The PF zones made by the cursor entries so far, in place of those there before; none made puts those back
params ["_heli", "_state", "_persistState"];

private _draft = _state getOrDefault ["znDraft", []];
if (_draft isEqualTo []) exitWith {};
if (_persistState getOrDefault ["znType", ZONE_KIND_PF] != ZONE_KIND_PF) exitWith {};
_draft params ["_entries", "_snapshot", "_heading"];

private _need = [_persistState] call fza_mpd_fnc_tsdZNNeed;
private _count = _persistState getOrDefault ["znCount", 1];
private _zones = switch (_persistState getOrDefault ["znOpt", 0]) do {
    case 2: {
        if (_entries isEqualTo []) exitWith {[]};
        [_entries # 0, (_persistState getOrDefault ["znKm", 2]) * 1000, _heading] call fza_dms_fnc_zoneTrp
    };
    case 1: {
        private _made = [];
        for "_i" from 0 to ((floor (count _entries / _need)) min _count) - 1 do {
            private _quad = [_entries select [_i * _need, _need], _heading] call fza_mpd_fnc_tsdZNQuad;
            if (_quad isNotEqualTo []) then {_made pushBack _quad};
        };
        _made
    };
    default {
        if (count _entries < _need) exitWith {[]};
        private _quad = [_entries select [0, _need], _heading] call fza_mpd_fnc_tsdZNQuad;
        if (_quad isEqualTo []) exitWith {[]};
        [_quad, _count] call fza_dms_fnc_zoneSplit
    };
};

if (_zones isEqualTo []) exitWith {
    _snapshot params ["_pf", "_zoneState"];
    if ((_heli getVariable "fza_dms_pfZones") isNotEqualTo _pf) then {
        _heli setVariable ["fza_dms_pfZones", +_pf, true];
    };
    private _now = +(_heli getVariable ["fza_dms_zoneState", ZONE_STATE_DEFAULT]);
    _now set [ZONE_STATE_ACTIVE_PF, _zoneState # ZONE_STATE_ACTIVE_PF];
    _now set [ZONE_STATE_OWN_PF, _zoneState # ZONE_STATE_OWN_PF];
    [_heli, _now] call fza_dms_fnc_zoneSetState;
};
[_heli, ZONE_KIND_PF, _zones] call fza_dms_fnc_zoneSetAll;
