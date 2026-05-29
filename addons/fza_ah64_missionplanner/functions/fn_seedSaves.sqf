disableSerialization;

private _display = uiNamespace getVariable ["fza_mplanner_display", displayNull];
if (isNull _display) exitWith {false};

private _browser = _display displayCtrl 100;
if (isNull _browser) exitWith {false};

private _jsonEscape = {
    params ["_text"];

    private _chars = [];
    {
        switch (_x) do {
            case 34: {_chars append [92, 34]};
            case 92: {_chars append [92, 92]};
            case 10: {_chars append [92, 110]};
            case 13: {};
            case 9: {_chars append [92, 116]};
            default {_chars pushBack _x};
        };
    } forEach toArray str _text;
    toString _chars
};

private _jsEscape = {
    params ["_text"];

    private _chars = [];
    {
        switch (_x) do {
            case 39: {_chars append [92, 39]};
            case 92: {_chars append [92, 92]};
            case 10: {_chars append [92, 110]};
            case 13: {};
            default {_chars pushBack _x};
        };
    } forEach toArray str _text;
    toString _chars
};

private _serializeEntries = {
    params ["_entries"];

    private _serialized = [];
    {
        if !(_x isEqualType []) then {continue};

        private _name = _x param [0, "", [""]];
        private _stateJson = _x param [1, "{}", [""]];
        private _timestamp = _x param [2, 0, [0]];
        private _ownerUid = _x param [3, "", [""]];
        private _ownerName = _x param [4, "", [""]];

        if (_ownerUid isEqualTo "") then {_ownerUid = getPlayerUID player};
        if (_ownerName isEqualTo "") then {_ownerName = name player};

        if (_name isEqualTo "" || {_stateJson isEqualTo ""}) then {continue};

        _serialized pushBack format [
            '{"name":"%1","state":%2,"timestamp":%3,"ownerUid":"%4","ownerName":"%5"}',
            _name call _jsonEscape,
            _stateJson,
            _timestamp,
            _ownerUid call _jsonEscape,
            _ownerName call _jsonEscape
        ];
    } forEach _entries;

    format ['[%1]', _serialized joinString ',']
};

// ── Nearby ACE fuel sources ───────────────────────────────────────────────────
private _farpFuelJson = "[]";
private _heliTarget = uiNamespace getVariable ["fza_mplanner_target", objNull];
if (isNull _heliTarget || {!(_heliTarget isKindOf "Helicopter")}) then {
    _heliTarget = vehicle player;
};
if (!isNull _heliTarget && {_heliTarget isKindOf "Helicopter"}) then {
    private _maxRange = missionNamespace getVariable ["ace_refuel_hoseLength", 12];
    if !(_maxRange isEqualType 0) then {_maxRange = 12};
    _maxRange = _maxRange max 30; // widen the search range for the display list

    private _nearby = nearestObjects [
        getPosATL _heliTarget,
        ["AllVehicles", "House", "House_F", "House_Small_F", "Strategic", "ReammoBox_F", "ThingX"],
        _maxRange
    ];

    private _fuelSources = [];
    {
        private _src = _x;
        if (_src == _heliTarget) then {continue};
        if !(alive _src) then {continue};
        private _cap = [_src] call ace_refuel_fnc_getCapacity;
        if (_cap == 0) then {continue};
        private _liters = if (_cap == -10) then {-1} else {round ([_src] call ace_refuel_fnc_getFuel)};
        if (_cap != -10 && {_liters <= 0}) then {continue};
        _fuelSources pushBack format ['{"name":"%1","liters":%2}',
            (getText (configOf _src >> "displayName")) call _jsonEscape,
            _liters
        ];
    } forEach _nearby;

    if (_fuelSources isNotEqualTo []) then {
        _farpFuelJson = format ['[%1]', _fuelSources joinString ','];
    };
};

// ── Mission Ammo Limits ───────────────────────────────────────────────────────
// CBA settings are exposed as global variables; fall back to missionNamespace for manual setting
private _ammoLimitEnabled = if (!isNil "fza_mplanner_ammoLimitEnable") then {
    fza_mplanner_ammoLimitEnable
} else {
    missionNamespace getVariable ["fza_mplanner_ammoLimitEnable", false]
};
if !(_ammoLimitEnabled isEqualType false || {_ammoLimitEnabled isEqualType 0}) then { _ammoLimitEnabled = false };
if (_ammoLimitEnabled isEqualType 0) then { _ammoLimitEnabled = _ammoLimitEnabled > 0 };

private _ammoTypes = [
    ["AGM114K",  "AGM-114K Hellfire"],
    ["AGM114L",  "AGM-114L Longbow Hellfire"],
    ["AGM114K2A","AGM-114K2A Hellfire"],
    ["AGM114FA", "AGM-114FA Hellfire"],
    ["AGM114N",  "AGM-114N Thermobaric Hellfire"],
    ["M151",     "M151 FFAR (6PD)"],
    ["M261",     "M261 MPSM (6MP)"],
    ["M255A1",   "M255A1 Flechette (6FL)"],
    ["M257",     "M257 Illumination (6IL)"],
    ["M278",     "M278 IR Illumination (6IR)"],
    ["M230",     "30mm Cannon (M230)"]
];

private _ammoEntries = [];
{
    private _key = _x # 0;
    private _label = _x # 1;
    private _varName = "fza_mplanner_ammo_" + _key;
    private _count = -1;
    if (_ammoLimitEnabled) then {
        _count = missionNamespace getVariable [_varName, -1];
        if !(_count isEqualType 0) then { _count = -1 };
    };
    // Hide ammo type only if limits are enabled AND count is exactly 0
    if (!_ammoLimitEnabled || {_count != 0}) then {
        _ammoEntries pushBack format ['{"key":"%1","label":"%2","count":%3}',
            _key call _jsonEscape,
            _label call _jsonEscape,
            _count
        ];
    };
} forEach _ammoTypes;

private _ammoLimitJson = format ['{"enabled":%1,"ammo":[%2]}',
    ["false", "true"] select _ammoLimitEnabled,
    _ammoEntries joinString ","
];

private _payload = format [
    '{"player":{"uid":"%1","name":"%2"},"environment":%3,"currentConfig":"%4","own":%5,"mission":%6,"farpFuel":%7,"ammoLimits":%8}',
    (getPlayerUID player) call _jsonEscape,
    (name player) call _jsonEscape,
    fza_ah64_sfmplusEnvironment,
    (profileNamespace getVariable ["fza_mplanner_last_loaded_config", ""]) call _jsonEscape,
    [profileNamespace getVariable ["fza_mplanner_saves_own", []]] call _serializeEntries,
    [missionNamespace getVariable ["fza_mplanner_saves_mission", []]] call _serializeEntries,
    _farpFuelJson,
    _ammoLimitJson
];

private _jsCode = format ["window.fza_mplanner_receiveSeed && window.fza_mplanner_receiveSeed('%1');", _payload call _jsEscape];
[_browser, _jsCode] call compile "params ['_b','_c']; _b ctrlWebBrowserAction ['ExecJS', _c];";

true;
