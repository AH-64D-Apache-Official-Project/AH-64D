#include "\fza_ah64_dms\headers\constants.h"
// Cursor enter on the ZN map: a corner of the zone being drawn, or the TRP centre
params ["_heli", "_state", "_persistState", "_pos", "_heading"];

if ((_state get "subPageVarPage") # 1 != 0) exitWith {};

private _pf = _persistState getOrDefault ["znType", ZONE_KIND_PF] == ZONE_KIND_PF;
private _need = [_persistState] call fza_mpd_fnc_tsdZNNeed;
private _total = _need;
if (_pf && {_persistState getOrDefault ["znOpt", 0] == 1}) then {
    _total = _need * (_persistState getOrDefault ["znCount", 1]);
};

// After a finished set of PF zones, drawing starts again
private _draft = _state getOrDefault ["znDraft", []];
if (_draft isNotEqualTo [] && {count (_draft # 0) >= _total}) then {
    _draft = [];
};
if (_draft isEqualTo []) then {
    private _snapshot = [[], [+(_heli getVariable "fza_dms_pfZones"), +(_heli getVariable ["fza_dms_zoneState", ZONE_STATE_DEFAULT])]] select _pf;
    _draft = [[], _snapshot, _heading];
};

private _entries = _draft # 0;
_entries pushBack [_pos # 0, _pos # 1, 0];
// A zone that crosses itself or has no area isn't taken
if (count _entries mod _need == 0 && {_need > 1}) then {
    if (([_entries select [count _entries - _need, _need], _draft # 2] call fza_mpd_fnc_tsdZNQuad) isEqualTo []) then {
        _entries deleteAt (count _entries - 1);
    };
};
_state set ["znDraft", [[], _draft] select (_entries isNotEqualTo [])];
// An NF zone is stored, and active, with its last corner
if (!_pf) exitWith {
    if (count _entries >= _need) then {[_heli, _state, _persistState] call fza_mpd_fnc_tsdZNAccept};
};
[_heli, _state, _persistState] call fza_mpd_fnc_tsdZNApply;
