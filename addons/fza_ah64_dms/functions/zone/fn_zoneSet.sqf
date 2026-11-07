#include "\fza_ah64_dms\headers\constants.h"
params ["_heli", "_kind", "_slot", "_poly"];

private _var = ["fza_dms_pfZones", "fza_dms_nfZones"] select _kind;
if (_slot < 0 || {_slot >= ([ZONE_COUNT_PF, ZONE_COUNT_NF] select _kind)}) exitWith {};
private _zones = +(_heli getVariable [_var, []]);
while {count _zones < ([ZONE_COUNT_PF, ZONE_COUNT_NF] select _kind)} do {_zones pushBack -1};
_zones set [_slot, _poly];
_heli setVariable [_var, _zones, true];

if (_poly isEqualTo -1) then {
    private _state = +(_heli getVariable ["fza_dms_zoneState", ZONE_STATE_DEFAULT]);
    if (_kind == ZONE_KIND_PF) then {
        if (_state # ZONE_STATE_ACTIVE_PF == _slot) then {_state set [ZONE_STATE_ACTIVE_PF, -1]};
        if (_state # ZONE_STATE_OWN_PF == _slot) then {_state set [ZONE_STATE_OWN_PF, -1]};
    } else {
        (_state # ZONE_STATE_NF_ACTIVE) set [_slot, false];
    };
    [_heli, _state] call fza_dms_fnc_zoneSetState;
};
