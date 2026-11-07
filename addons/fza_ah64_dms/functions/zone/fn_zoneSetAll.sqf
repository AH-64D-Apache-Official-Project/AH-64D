#include "\fza_ah64_dms\headers\constants.h"
// The zones of a kind, numbered from 1, replacing all of them; none of them active
params ["_heli", "_kind", "_zones"];

private _var = ["fza_dms_pfZones", "fza_dms_nfZones"] select _kind;
private _all = [];
for "_i" from 0 to ([ZONE_COUNT_PF, ZONE_COUNT_NF] select _kind) - 1 do {
    _all pushBack (_zones param [_i, -1]);
};
if ((_heli getVariable [_var, []]) isNotEqualTo _all) then {
    _heli setVariable [_var, _all, true];
};

private _state = +(_heli getVariable ["fza_dms_zoneState", ZONE_STATE_DEFAULT]);
if (_kind == ZONE_KIND_PF) then {
    _state set [ZONE_STATE_ACTIVE_PF, -1];
    _state set [ZONE_STATE_OWN_PF, -1];
} else {
    _state set [ZONE_STATE_NF_ACTIVE, (_state # ZONE_STATE_NF_ACTIVE) apply {false}];
};
[_heli, _state] call fza_dms_fnc_zoneSetState;
