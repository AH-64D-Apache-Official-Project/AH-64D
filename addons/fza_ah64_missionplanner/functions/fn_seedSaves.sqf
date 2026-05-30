disableSerialization;
private _m0 = "[MP Debug] seedSaves: called";
diag_log _m0; systemChat _m0;

private _display = uiNamespace getVariable ["fza_mplanner_display", displayNull];
if (isNull _display) exitWith {
    private _mD = "[MP Debug] seedSaves: EXIT - display null";
    diag_log _mD; systemChat _mD;
    false
};

private _browser = _display displayCtrl 100;
if (isNull _browser) exitWith {
    private _mB = "[MP Debug] seedSaves: EXIT - browser null";
    diag_log _mB; systemChat _mB;
    false
};

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
    } forEach toArray _text;
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
    } forEach toArray _text;
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
private _rearmJson = "[]";
private _aceAmmoTotals = createHashMap; // populated if ace_rearm_supply==2 and custom limits disabled
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

    // ACE rearm sources
    private _rearmSources = [];
    {
        private _src = _x;
        if (_src == _heliTarget) then {continue};
        if !(alive _src) then {continue};
        private _supply = _src getVariable ["ace_rearm_supply", -999];
        if (_supply isEqualTo -999) then {continue};
        private _supplyStr = if (_supply < 0) then {"Unlimited"} else {str (round _supply)};
        _rearmSources pushBack format ['{"name":"%1","supply":"%2"}',
            (getText (configOf _src >> "displayName")) call _jsonEscape,
            _supplyStr call _jsonEscape
        ];
    } forEach _nearby;
    _rearmJson = format ['[%1]', _rearmSources joinString ','];

    // ACE supply=2: aggregate per-magazine counts from nearby sources
    // (used as ammo limits when the custom limit system is not configured)
    private _aceRearmSupplyMode = missionNamespace getVariable ["ace_rearm_supply", 0];
    if (_aceRearmSupplyMode == 2) then {
        // Map magazine-class prefixes to our ammo keys
        private _magPrefixToKey = [
            ["fza_agm114k",   "AGM114K"],
            ["fza_agm114l",   "AGM114L"],
            ["fza_agm114k2a", "AGM114K2A"],
            ["fza_agm114fa",  "AGM114FA"],
            ["fza_agm114n",   "AGM114N"],
            ["fza_275_m151",  "M151"],
            ["fza_275_m255a1","M255A1"],
            ["fza_275_m261",  "M261"],
            ["fza_275_m257",  "M257"],
            ["fza_275_m278",  "M278"],
            ["fza_m230",      "M230"]
        ];
        {
            private _src = _x;
            if (_src == _heliTarget) then {continue};
            if !(alive _src) then {continue};
            private _magSupply = _src getVariable ["ace_rearm_magazineSupply", []];
            {
                _x params ["_magClass", "_rounds"];
                private _ammoKey = "";
                {
                    _y params ["_prefix", "_key"];
                    if ((_magClass find _prefix) == 0) exitWith { _ammoKey = _key; };
                } forEach _magPrefixToKey;
                if (_ammoKey != "") then {
                    _aceAmmoTotals set [_ammoKey, (_aceAmmoTotals getOrDefault [_ammoKey, 0]) + _rounds];
                };
            } forEach _magSupply;
        } forEach _nearby;
    };
} else {
    _rearmJson = "[]";
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
    ["AGM114K",  "AGM-114K"],
    ["AGM114L",  "AGM-114L"],
    ["AGM114K2A","AGM-114K2A"],
    ["AGM114FA", "AGM-114FA"],
    ["AGM114N",  "AGM-114N"],
    ["M151",     "M151"],
    ["M261",     "M261"],
    ["M255A1",   "M255A1"],
    ["M257",     "M257"],
    ["M278",     "M278"],
    ["M230",     "M230"]
];

private _ammoEntries = [];
// If custom limits are off but ACE supply=2 data is available, use it
private _useAceAmmoTotals = (!_ammoLimitEnabled && (count _aceAmmoTotals) > 0);
if (_useAceAmmoTotals) then { _ammoLimitEnabled = true; };
{
    private _key = _x # 0;
    private _label = _x # 1;
    private _varName = "fza_mplanner_ammo_" + _key;
    private _count = -1;
    if (_ammoLimitEnabled) then {
        if (_useAceAmmoTotals) then {
            _count = _aceAmmoTotals getOrDefault [_key, 0];
        } else {
            _count = missionNamespace getVariable [_varName, -1];
            if !(_count isEqualType 0) then { _count = -1 };
        };
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

private _seedFuelRate = if (isNil "ace_refuel_rate") then {1} else {ace_refuel_rate};
if !(_seedFuelRate isEqualType 0 && {_seedFuelRate > 0}) then { _seedFuelRate = 1 };

private _payload = format [
    '{"player":{"uid":"%1","name":"%2"},"environment":%3,"currentConfig":"%4","own":%5,"mission":%6,"farpFuel":%7,"farpRearm":%8,"ammoLimits":%9,"fuelRateLS":%10}',
    (getPlayerUID player) call _jsonEscape,
    (name player) call _jsonEscape,
    fza_ah64_sfmplusEnvironment,
    (profileNamespace getVariable ["fza_mplanner_last_loaded_config", ""]) call _jsonEscape,
    [profileNamespace getVariable ["fza_mplanner_saves_own", []]] call _serializeEntries,
    [missionNamespace getVariable ["fza_mplanner_saves_mission", []]] call _serializeEntries,
    _farpFuelJson,
    _rearmJson,
    _ammoLimitJson,
    _seedFuelRate
];

private _jsCode = format ["window.fza_mplanner_receiveSeed && window.fza_mplanner_receiveSeed('%1');", _payload call _jsEscape];
private _mExec = format ["[MP Debug] seedSaves: calling ExecJS (jsCode len=%1, payload len=%2)", count _jsCode, count _payload];
diag_log _mExec; systemChat _mExec;
diag_log format ["[MP Debug] seedSaves: jsCode preview: %1", _jsCode select [0, 200]];
[_browser, _jsCode] call compile "params ['_b','_c']; _b ctrlWebBrowserAction ['ExecJS', _c];";
private _mDone = "[MP Debug] seedSaves: ExecJS done";
diag_log _mDone; systemChat _mDone;

true;
