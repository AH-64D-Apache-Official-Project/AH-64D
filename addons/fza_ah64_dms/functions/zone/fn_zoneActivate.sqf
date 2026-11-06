#include "\fza_ah64_dms\headers\constants.h"
params ["_heli", "_kind", "_slot", "_on"];

private _zones = _heli getVariable (["fza_dms_pfZones", "fza_dms_nfZones"] select _kind);
if (_on && {(_zones # _slot) isEqualTo -1}) exitWith {false};

private _state = +(_heli getVariable ["fza_dms_zoneState", ZONE_STATE_DEFAULT]);
if (_kind == ZONE_KIND_PF) then {
    private _current = _state # ZONE_STATE_ACTIVE_PF;
    private _active = [[_current, -1] select (_current == _slot), _slot] select _on;
    _state set [ZONE_STATE_ACTIVE_PF, _active];
    if (_state # ZONE_STATE_OWN_PF != _active) then {_state set [ZONE_STATE_OWN_PF, -1]};
} else {
    private _nf = +(_state # ZONE_STATE_NF_ACTIVE);
    if (_on && {_state # ZONE_STATE_NF_SINGLE}) then {_nf = _nf apply {false}};
    _nf set [_slot, _on];
    _state set [ZONE_STATE_NF_ACTIVE, _nf];
};
[_heli, _state] call fza_dms_fnc_zoneSetState;
true
