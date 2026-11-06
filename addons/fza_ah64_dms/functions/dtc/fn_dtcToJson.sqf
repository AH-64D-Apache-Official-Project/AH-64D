#include "\fza_ah64_dms\headers\constants.h"
/* ----------------------------------------------------------------------------
Function: fza_dms_fnc_dtcToJson

Description:
    The DTC JSON (fza_dms_fnc_dtcFromJson) of an aircraft or the mission: the
    DTC in the aircraft, or what it holds now. A point file or the routes not on
    the DTC are what the aircraft holds now.

Parameters:
    _source - The helicopter, or missionNamespace for the mission's (Eden) data
    _live   - true for what it holds now, not the DTC in it

Returns:
    The JSON

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_source", ["_live", false]];

private _pending = [_source getVariable ["fza_dms_dtcPending", []], []] select _live;
_pending params [
    "",
    ["_name", _source getVariable ["fza_dms_dtcName", ""]],
    ["_world", worldName],
    ["_lines", _source getVariable ["fza_dms_lines", []]],
    ["_areas", _source getVariable ["fza_dms_areas", []]],
    ["_pf", _source getVariable ["fza_dms_pfZones", []]],
    ["_nf", _source getVariable ["fza_dms_nfZones", []]],
    ["_zoneState", _source getVariable ["fza_dms_zoneState", ZONE_STATE_DEFAULT]],
    ["_wp", []],
    ["_cm", []],
    ["_tt", []],
    ["_routes", []]
];
if (_wp isEqualTo []) then {_wp = _source getVariable ["fza_dms_waypointsHazards", []]};
if (_cm isEqualTo []) then {_cm = _source getVariable ["fza_dms_controlMeasures", []]};
if (_tt isEqualTo []) then {_tt = _source getVariable ["fza_dms_targetsThreats", []]};
if (_routes isEqualTo []) then {
    _routes = (_source getVariable ["fza_ah64_routeData", []]) apply {_x apply {_x call fza_dms_fnc_pointToString}};
};

private _r = {(round (_this * 10)) / 10};
private _withId = {
    _this apply {
        if (_x isEqualTo -1) then {0} else {
            createHashMapFromArray [["id", _x # 0], ["pts", (_x # 1) apply {[(_x # 0) call _r, (_x # 1) call _r, (_x param [2, 0]) call _r]}]]
        }
    }
};
private _zones = {
    _this apply {
        if (_x isEqualTo -1) then {0} else {
            createHashMapFromArray [["pts", _x apply {[(_x # 0) call _r, (_x # 1) call _r]}]]
        }
    }
};
private _points = {
    _this apply {
        if (_x isEqualTo -1) then {0} else {
            private _pos = _x # POINT_GET_ARMA_POS;
            createHashMapFromArray [
                ["ident", _x # POINT_GET_IDENT],
                ["free", _x # POINT_GET_FREE_TEXT],
                ["pt", [(_pos # 0) call _r, (_pos # 1) call _r, (_x # POINT_GET_ALT_MSL) call _r]],
                ["g", _x # POINT_GET_GRID_COORD]
            ]
        }
    }
};

toJSON createHashMapFromArray [
    ["version", DTC_VERSION],
    ["name", _name],
    ["world", _world],
    ["lines", _lines call _withId],
    ["areas", _areas call _withId],
    ["pfz", _pf call _zones],
    ["nfz", _nf call _zones],
    ["zones", createHashMapFromArray [
        ["activePf", _zoneState # ZONE_STATE_ACTIVE_PF],
        ["nfActive", _zoneState # ZONE_STATE_NF_ACTIVE],
        ["nfSingle", _zoneState # ZONE_STATE_NF_SINGLE]
    ]],
    ["wp", _wp call _points],
    ["cm", _cm call _points],
    ["tt", _tt call _points],
    ["routes", _routes]
]
