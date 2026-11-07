#include "\fza_ah64_dms\headers\constants.h"
// [active PF polygon or [], [active NF polygons]]
params ["_heli"];

private _state = _heli getVariable ["fza_dms_zoneState", ZONE_STATE_DEFAULT];
private _pfZones = _heli getVariable ["fza_dms_pfZones", []];
private _nfZones = _heli getVariable ["fza_dms_nfZones", []];

private _pf = _pfZones param [_state # ZONE_STATE_ACTIVE_PF, -1];
if (_pf isEqualTo -1) then {_pf = []};
private _nf = [];
{
    private _zone = _nfZones param [_forEachIndex, -1];
    if (_x && {_zone isNotEqualTo -1}) then {_nf pushBack _zone};
} forEach (_state # ZONE_STATE_NF_ACTIVE);
[_pf, _nf]
