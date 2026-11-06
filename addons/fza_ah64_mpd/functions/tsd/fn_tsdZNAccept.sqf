#include "\fza_ah64_dms\headers\constants.h"
// The NF zone drawn, stored as the chosen one and active; the choice moves on to the next empty one
params ["_heli", "_state", "_persistState"];

private _draft = _state getOrDefault ["znDraft", []];
_state set ["znDraft", []];
if (_draft isEqualTo []) exitWith {false};
_draft params ["_entries", "", "_heading"];
if (count _entries < [_persistState] call fza_mpd_fnc_tsdZNNeed) exitWith {false};

private _quad = [_entries, _heading] call fza_mpd_fnc_tsdZNQuad;
if (_quad isEqualTo []) exitWith {false};
private _slot = _persistState getOrDefault ["znNfSel", 0];
[_heli, ZONE_KIND_NF, _slot, _quad] call fza_dms_fnc_zoneSet;
[_heli, ZONE_KIND_NF, _slot, true] call fza_dms_fnc_zoneActivate;

private _zones = _heli getVariable "fza_dms_nfZones";
private _next = _zones findIf {_x isEqualTo -1};
if (_next != -1) then {_persistState set ["znNfSel", _next]};
true
