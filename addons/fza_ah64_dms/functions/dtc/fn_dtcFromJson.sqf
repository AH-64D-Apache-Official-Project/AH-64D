#include "\fza_ah64_dms\headers\constants.h"
/* ----------------------------------------------------------------------------
Function: fza_dms_fnc_dtcFromJson

Description:
    Puts a DTC in the aircraft, as the mission planner's DTC JSON: lines, areas,
    PF/NF zones, points and routes, in world metres. It is loaded with the rest
    of the mission data by DTU MASTER LOAD (fza_dms_fnc_dtcLoad). A point file
    with no points, or routes that are all empty, aren't on the card: the
    mission's are loaded instead.

    {"version":1, "name":"MSN01", "world":"Altis",
     "lines":[{"id":"PLAMY","pts":[[x,y,z],...2-4]}, 0, ...15],
     "areas":[{"id":"EA01","pts":[[x,y,z] x4]}, ...12],
     "pfz":[{"pts":[[x,y] x3-12]}, ...8], "nfz":[...8],
     "zones":{"activePf":-1, "nfActive":[false,...8], "nfSingle":false},
     "wp":[{"ident":"WP","free":"ABC","pt":[x,y,zMSL]}, ...50], "cm":[...49], "tt":[...50],
     "routes":[["W01","C51","T03"], ...10], "routeNames":["ALPHA", ...10]}

    Anything that isn't an object is an empty slot.

Parameters:
    _heli - The helicopter
    _json - The DTC

Returns:
    [true, ""] or [false, why]

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_json"];

private _data = fromJSON _json;
if !(_data isEqualType createHashMap) exitWith {[false, "Not a DTC"]};
if ((_data getOrDefault ["version", 0]) isNotEqualTo DTC_VERSION) exitWith {[false, "Unknown DTC version"]};
private _world = _data getOrDefault ["world", worldName];
if (_world isEqualTo "") then {_world = worldName};
if !(_world isEqualType "" && {_world == worldName}) exitWith {[false, format ["The DTC is for %1", _world]]};
private _name = _data getOrDefault ["name", ""];
_name = [toUpper (_name select [0, 8]), ""] select !(_name isEqualType "");

private _readPts = {
    params ["_entry", "_min", "_max"];
    if !(_entry isEqualType createHashMap) exitWith {-1};
    private _raw = _entry getOrDefault ["pts", []];
    if !(_raw isEqualType [] && {count _raw >= _min} && {count _raw <= _max}) exitWith {-1};
    private _pts = _raw apply {
        if (_x isEqualTypeParams [0, 0] || {_x isEqualTypeParams [0, 0, 0]}) then {[_x # 0, _x # 1, _x param [2, 0]]} else {[]}
    };
    if (_pts findIf {_x isEqualTo []} != -1) exitWith {-1};
    _pts
};
private _ident = {
    params ["_entry", "_default"];
    private _id = _entry getOrDefault ["id", ""];
    if (_id isEqualType "" && {toUpper _id regexMatch "^[A-Z0-9]{1,5}$"}) exitWith {toUpper _id};
    _default
};
private _slots = {
    params ["_key", "_count", "_fnc"];
    private _list = _data getOrDefault [_key, []];
    if !(_list isEqualType []) then {_list = []};
    private _out = [];
    for "_i" from 0 to _count - 1 do {
        _out pushBack ([_list param [_i, 0], _i] call _fnc);
    };
    _out
};

private _lines = ["lines", LINE_COUNT, {
    params ["_entry", "_i"];
    private _pts = [_entry, 2, LINE_POINTS_MAX] call _readPts;
    if (_pts isEqualTo -1) exitWith {-1};
    [[_entry, "PL" + ([_i + 1, 3] call CBA_fnc_formatNumber)] call _ident, _pts]
}] call _slots;
private _areas = ["areas", AREA_COUNT, {
    params ["_entry", "_i"];
    private _pts = [_entry, 4, 4] call _readPts;
    if (_pts isEqualTo -1) exitWith {-1};
    [[_entry, "EA" + ([_i + 1, 2] call CBA_fnc_formatNumber)] call _ident, _pts]
}] call _slots;
private _zone = {
    params ["_entry"];
    // Drawn as four corners, or a strip cut from a zone (fza_dms_fnc_zoneSplit)
    private _pts = [_entry, 3, 12] call _readPts;
    if (_pts isEqualTo -1) exitWith {-1};
    if (count _pts != 4) exitWith {_pts apply {[_x # 0, _x # 1, 0]}};
    private _quad = [_pts] call fza_dms_fnc_zoneValidate;
    [_quad, -1] select (_quad isEqualTo [])
};
private _pf = ["pfz", ZONE_COUNT_PF, _zone] call _slots;
private _nf = ["nfz", ZONE_COUNT_NF, _zone] call _slots;

private _zoneState = ZONE_STATE_DEFAULT;
private _zones = _data getOrDefault ["zones", createHashMap];
if (_zones isEqualType createHashMap) then {
    private _activePf = _zones getOrDefault ["activePf", -1];
    if (_activePf isEqualType 0 && {(_pf param [_activePf, -1]) isNotEqualTo -1}) then {
        _zoneState set [ZONE_STATE_ACTIVE_PF, _activePf];
    };
    private _nfActive = _zones getOrDefault ["nfActive", []];
    if (_nfActive isEqualType []) then {
        private _active = _zoneState # ZONE_STATE_NF_ACTIVE;
        for "_i" from 0 to ZONE_COUNT_NF - 1 do {
            _active set [_i, (_nfActive param [_i, false]) isEqualTo true && {(_nf # _i) isNotEqualTo -1}];
        };
    };
    _zoneState set [ZONE_STATE_NF_SINGLE, (_zones getOrDefault ["nfSingle", false]) isEqualTo true];
};

// Point files as the aircraft holds them (fza_dms_fnc_pointCreate), [] when there are none
private _points = {
    params ["_key", "_count", "_types", "_first"];
    private _list = _data getOrDefault [_key, []];
    if !(_list isEqualType []) then {_list = []};
    private _records = [];
    private _any = false;
    for "_i" from 0 to _count - 1 do {
        private _entry = _list param [_i, 0];
        private _record = -1;
        if (_entry isEqualType createHashMap) then {
            private _ident = _entry getOrDefault ["ident", ""];
            private _pt = _entry getOrDefault ["pt", []];
            if (_ident isEqualType "" && {_pt isEqualTypeParams [0, 0]}) then {
                _ident = toUpper _ident;
                private _type = _types param [_types findIf {[_x, _ident] call fza_dms_fnc_pointIsValidIdent}, -1];
                if (_type == -1) exitWith {};
                private _free = _entry getOrDefault ["free", ""];
                _free = [toUpper (_free select [0, 3]), ""] select !(_free isEqualType "");
                private _pos = [_pt # 0, _pt # 1, 0];
                private _alt = _pt param [2, getTerrainHeightASL _pos];
                if !(_alt isEqualType 0) then {_alt = getTerrainHeightASL _pos};
                _record = [MPD_POSMODE_WORLD, _pos, _free, _type, [_type, _first + _i], _ident,
                    [_pos] call fza_dms_fnc_posToGrid, [_pos] call fza_dms_fnc_posToLatLong call fza_dms_fnc_latLongToString,
                    _alt, (_alt - getTerrainHeightASL _pos) max 0];
                _any = true;
            };
        };
        _records pushBack _record;
    };
    [[], _records] select _any
};
private _wp = ["wp", POINT_COUNT_WP_HZ, [POINT_TYPE_WP, POINT_TYPE_HZ], 1] call _points;
private _cm = ["cm", POINT_COUNT_CM, [POINT_TYPE_CM], 51] call _points;
private _tt = ["tt", POINT_COUNT_TG_TH, [POINT_TYPE_TG], 1] call _points;

// Routes as point IDs (W01, C51, T03), found in the aircraft's points when loaded; [] when all are empty
private _routes = _data getOrDefault ["routes", []];
if !(_routes isEqualType []) then {_routes = []};
_routes = (_routes select [0, 10]) apply {
    if (_x isEqualType []) then {(_x select {_x isEqualType "" && {_x regexMatch "^[WCT][0-9]{2}$"}}) select [0, 50]} else {[]}
};
while {count _routes < 10} do {_routes pushBack []};
if (_routes findIf {_x isNotEqualTo []} == -1) then {_routes = []};

// Route names, up to 5 letters or numbers; [] when the DTC has none
private _routeNames = _data getOrDefault ["routeNames", []];
if !(_routeNames isEqualType []) then {_routeNames = []};
if (_routeNames isNotEqualTo []) then {
    private _given = _routeNames;
    _routeNames = ROUTE_NAME_DEFAULTS;
    {
        private _name = _given param [_forEachIndex, ""];
        if (_name isEqualType "" && {toUpper _name regexMatch "^[A-Z0-9]{1,5}$"}) then {_routeNames set [_forEachIndex, toUpper _name]};
    } forEach ROUTE_NAME_DEFAULTS;
};

_heli setVariable ["fza_dms_dtcPending", [DTC_VERSION, _name, worldName, _lines, _areas, _pf, _nf, _zoneState, _wp, _cm, _tt, _routes, _routeNames], true];
[true, ""]
