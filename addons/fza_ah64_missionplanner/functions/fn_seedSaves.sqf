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

// ── ACE rearm caliber costs (read from CfgAmmo via representative magazine) ──
private _fnCaliberCost = {
    params ["_magClass"];
    private _ammo = getText (configFile >> "CfgMagazines" >> _magClass >> "ammo");
    if (_ammo isEqualTo "") exitWith { 0 };
    private _cal = getNumber (configFile >> "CfgAmmo" >> _ammo >> "ace_caliber");
    if (_cal <= 0) then { _cal = getNumber (configFile >> "CfgAmmo" >> _ammo >> "ACE_caliber") };
    round _cal
};
private _costHellfire = 50; // 50 pts per missile (ace_caliber=100 is ACE default; we use half rate)
private _costRocket   = 5; // 5 pts per rocket (charged per round; ace_caliber=20 is per-pod which we override)
private _costCannon   = ["fza_m230_300"]        call _fnCaliberCost;
private _costAux      = 50;
private _costJson     = format ['{"hellfire":%1,"rocket":%2,"cannon":%3,"aux":%4}', _costHellfire, _costRocket, _costCannon, _costAux];

// ── ACE rearm pylons auto-fill setting ───────────────────────────────────────
private _rearmNewPylons = missionNamespace getVariable ["ace_pylons_rearmNewPylons", false];
if !(_rearmNewPylons isEqualType true) then { _rearmNewPylons = false; };
private _rearmNewPylonsStr = ["false", "true"] select _rearmNewPylons;

// ── Nearby ACE fuel sources ───────────────────────────────────────────────────
private _farpFuelJson = "[]";
private _rearmJson = format ['{"mode":0,"totalSupply":0,"unlimited":true,"rearmNewPylons":%1,"trucks":[],"costs":%2}', _rearmNewPylonsStr, _costJson];
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
    private _rearmTotalSupply = 0;
    private _rearmHasUnlimited = false;
    private _aceSupplyMode = missionNamespace getVariable ["ace_rearm_supply", 0];
    if !(_aceSupplyMode isEqualType 0) then { _aceSupplyMode = 0 };
    {
        private _src = _x;
        if (_src == _heliTarget) then {continue};
        if !(alive _src) then {continue};
        // Detect ACE rearm sources: explicitly marked or has supply config
        private _isSource = _src getVariable ["ace_rearm_isSupplyVehicle", false];
        if !(_isSource) then {
            private _cfgSupply = getNumber (configOf _src >> "ace_rearm_defaultSupply");
            if (_cfgSupply == 0) then { _cfgSupply = getNumber (configOf _src >> "transportAmmo"); };
            _isSource = _cfgSupply > 0;
        };
        if !(_isSource) then {continue};
        // Get supply amount — only meaningful in limited mode (ace_rearm_supply == 1)
        private _supplyAmt = -1; // treat as unlimited unless mode 1
        if (_aceSupplyMode == 1) then {
            private _currentSupply = _src getVariable "ace_rearm_currentSupply";
            if (isNil "_currentSupply") then {
                _currentSupply = getNumber (configOf _src >> "ace_rearm_defaultSupply");
                if (_currentSupply <= 0) then { _currentSupply = 1200; };
            };
            _supplyAmt = round _currentSupply;
        };
        private _isUnlimited = _supplyAmt < 0;
        if (_isUnlimited) then {
            _rearmHasUnlimited = true;
        } else {
            _rearmTotalSupply = _rearmTotalSupply + _supplyAmt;
        };
        _rearmSources pushBack format ['{"name":"%1","supply":%2,"unlimited":%3}',
            (getText (configOf _src >> "displayName")) call _jsonEscape,
            if (_isUnlimited) then {-1} else {_supplyAmt},
            ["false", "true"] select (_isUnlimited)
        ];
    } forEach _nearby;

    if (_rearmSources isNotEqualTo []) then {
        _rearmJson = format [
            '{"mode":%1,"totalSupply":%2,"unlimited":%3,"rearmNewPylons":%4,"trucks":[%5],"costs":%6}',
            _aceSupplyMode,
            if (_rearmHasUnlimited) then {-1} else {_rearmTotalSupply},
            ["false", "true"] select (_rearmHasUnlimited),
            _rearmNewPylonsStr,
            _rearmSources joinString ',',
            _costJson
        ];
    } else {
        _rearmJson = format ['{"mode":%1,"totalSupply":0,"unlimited":false,"rearmNewPylons":%2,"trucks":[],"costs":%3}', _aceSupplyMode, _rearmNewPylonsStr, _costJson];
    };

} else {
    // No heli target — still provide cost structure with no trucks
    _rearmJson = format ['{"mode":0,"totalSupply":0,"unlimited":true,"rearmNewPylons":%1,"trucks":[],"costs":%2}', _rearmNewPylonsStr, _costJson];
};

// ── Ammo List (always INF — limit enforcement not yet implemented) ──────────
private _ammoLimitJson = '{"enabled":false,"ammo":[{"key":"AGM114K","label":"AGM-114K","count":-1},{"key":"AGM114L","label":"AGM-114L","count":-1},{"key":"AGM114K2A","label":"AGM-114K2A","count":-1},{"key":"AGM114FA","label":"AGM-114FA","count":-1},{"key":"AGM114N","label":"AGM-114N","count":-1},{"key":"M151","label":"M151","count":-1},{"key":"M261","label":"M261","count":-1},{"key":"M255A1","label":"M255A1","count":-1},{"key":"M257","label":"M257","count":-1},{"key":"M278","label":"M278","count":-1},{"key":"M230","label":"M230","count":-1}]}';

private _seedFuelRate = if (isNil "ace_refuel_rate") then {1} else {ace_refuel_rate};
if !(_seedFuelRate isEqualType 0 && {_seedFuelRate > 0}) then { _seedFuelRate = 1 };

private _payload = format [
    '{"player":{"uid":"%1","name":"%2"},"environment":%3,"currentConfig":"%4","own":%5,"mission":%6,"farpFuel":%7,"farpRearm":%8,"ammoLimits":%9,"fuelRateLS":%10}',
    (getPlayerUID player) call _jsonEscape,
    (name player) call _jsonEscape,
    fza_ah64_sfmplusEnvironment,
    (missionNamespace getVariable ["fza_mplanner_last_loaded_config", ""]) call _jsonEscape,
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
