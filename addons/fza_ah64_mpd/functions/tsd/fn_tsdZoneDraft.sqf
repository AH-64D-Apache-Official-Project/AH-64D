#include "\fza_ah64_dms\headers\constants.h"
// The zone being drawn on ZN, in world positions out to the MPD cursor: [[points, closed, colour], ...]
params ["_heli", "_mpdIndex", "_state", "_persistState", "_framePos", "_frameHeading", "_scale", "_ctr"];

if ((_state get "subPageVarPage") # 0 != 6) exitWith {[]};
if ((_state get "subPageVarPage") # 1 != 0) exitWith {[]};
(_state getOrDefault ["znDraft", []]) params [["_entries", []], "", ["_heading", _frameHeading]];
private _nf = _persistState getOrDefault ["znType", ZONE_KIND_PF] == ZONE_KIND_NF;
private _color = [[1, 1, 1, 1], [1, 1, 0, 1]] select _nf;
private _need = _state getOrDefault ["znNeed", 4];

// A drawn NF zone waits for OWN
if (_nf && {count _entries >= _need}) exitWith {
    private _quad = [_entries select [0, _need], _heading] call fza_mpd_fnc_tsdZNQuad;
    [[], [[_quad, true, _color]]] select (_quad isNotEqualTo [])
};

// The zone being drawn: its corners so far, out to the MPD cursor
private _verts = _entries select [floor (count _entries / _need) * _need, count _entries mod _need];
private _cursor = _heli getVariable ["fza_mpd_cursor", []];
private _cursorPos = [];
if (_cursor param [0, -1] == _mpdIndex && {[_heli, _mpdIndex, _cursor # 1, _cursor # 2] call fza_mpd_fnc_cursorInArea}) then {
    _cursorPos = [_framePos, _frameHeading, _scale, _ctr, [_cursor # 1, _cursor # 2]] call fza_mpd_fnc_tsdScreenToWorld;
};
if (_cursorPos isEqualTo []) exitWith {
    [[], [[_verts, false, _color]]] select (count _verts > 1)
};
switch (true) do {
    case (_need == 1): {
        ([_cursorPos, (_persistState getOrDefault ["znKm", 2]) * 1000, _heading] call fza_dms_fnc_zoneTrp) apply {[_x, true, _color]}
    };
    case (_need == 2 && {count _verts == 1}): {
        [[[_verts # 0, _cursorPos, _heading] call fza_dms_fnc_zoneBox, true, _color]]
    };
    case (count _verts > 0): {
        [[_verts + [_cursorPos], count _verts > 1, _color]]
    };
    default {[]};
}
