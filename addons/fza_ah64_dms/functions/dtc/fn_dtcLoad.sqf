#include "\fza_ah64_dms\headers\constants.h"
// DTU MASTER LOAD: the mission's data, then what the DTC in the aircraft holds (fza_dms_fnc_dtcFromJson)
params ["_heli"];

[missionNamespace, _heli] call fza_dms_fnc_copy;

private _pending = _heli getVariable ["fza_dms_dtcPending", []];
if (_pending isEqualTo [] || {(_pending # 2) != worldName}) exitWith {
    _heli setVariable ["fza_dms_dtcName", "", true];
};
_pending params ["", "_name", "", "_lines", "_areas", "_pf", "_nf", "_zoneState", ["_wp", []], ["_cm", []], ["_tt", []], ["_routes", []]];
_heli setVariable ["fza_dms_lines", +_lines, true];
_heli setVariable ["fza_dms_areas", +_areas, true];
_heli setVariable ["fza_dms_pfZones", +_pf, true];
_heli setVariable ["fza_dms_nfZones", +_nf, true];
_heli setVariable ["fza_dms_zoneState", +_zoneState, true];
{
    _x params ["_var", "_records"];
    if (_records isNotEqualTo []) then {_heli setVariable [_var, +_records, true]};
} forEach [["fza_dms_waypointsHazards", _wp], ["fza_dms_controlMeasures", _cm], ["fza_dms_targetsThreats", _tt]];

// Routes: each point ID found in the points now held, a W number as the waypoint or hazard stored there
if (_routes isNotEqualTo []) then {
    private _routeData = _routes apply {
        private _route = [];
        {
            private _index = [_heli, [_heli, _x] call fza_dms_fnc_pointParse] call fza_dms_fnc_pointGetArrayIndex;
            if (_index isEqualTo -1) then {continue};
            private _record = (_heli getVariable (_index # 0)) # (_index # 1);
            if (_record isNotEqualTo -1) then {_route pushBack (_record # POINT_GET_ID)};
        } forEach _x;
        _route
    };
    _heli setVariable ["fza_ah64_routeData", _routeData, true];
    _heli setVariable ["fza_ah64_routeCurPoint", -1, true];
};
_heli setVariable ["fza_dms_dtcName", _name, true];
