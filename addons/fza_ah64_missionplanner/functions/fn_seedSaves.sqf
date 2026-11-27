disableSerialization;

private _display = uiNamespace getVariable ["fza_mplanner_display", displayNull];
if (isNull _display) exitWith { false };

private _browser = _display displayCtrl 100;
if (isNull _browser) exitWith { false };

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

private _setting = {
    params ["_name", "_default"];
    private _value = missionNamespace getVariable [_name, _default];
    [_default, _value] select (_value isEqualType _default)
};

// ── Supply costs, as fza_mplanner_fnc_applyRun charges them ─────────────────
// Hellfires 50 points each, rockets 5 each, the gun its ammunition's ACE caliber per 50 rounds
private _gunAmmo = getText (configFile >> "CfgMagazines" >> "fza_m230_300" >> "ammo");
private _costCannon = round getNumber (configFile >> "CfgAmmo" >> _gunAmmo >> "ACE_caliber");
if (_costCannon <= 0) then {_costCannon = 30};
private _costJson = format ['{"hellfire":50,"rocket":5,"cannon":%1,"aux":50,"fcr":100,"iafs":100}', _costCannon];

private _seedNoAmmoSrc = ["fza_mplanner_noAmmoSourceRequired", true] call _setting;
private _seedNoFuelSrc = ["fza_mplanner_noFuelSourceRequired", true] call _setting;

// ── Sources within the source distance (fza_mplanner_fnc_sources) ──────────
// Only those that are required; the page shows "Not Required" for the others
// 0 unlimited, 1 supply points, 2 magazines carried
private _supplyMode = ["mode"] call fza_mplanner_fnc_supply;
private _fuelRows = [];
private _ammoRows = [];
private _totalSupply = 0;

private _heliTarget = uiNamespace getVariable ["fza_mplanner_target", objNull];
if (isNull _heliTarget || {!(_heliTarget isKindOf "Helicopter")}) then {
    _heliTarget = vehicle player;
};
if (!isNull _heliTarget && {_heliTarget isKindOf "Helicopter"} && {!_seedNoAmmoSrc || {!_seedNoFuelSrc}}) then {
    ([_heliTarget, !_seedNoAmmoSrc, !_seedNoFuelSrc] call fza_mplanner_fnc_sources) params ["_ammo", "_fuel"];
    {
        _x params ["_src", "_dist", "_litres"];
        _fuelRows pushBack format ['{"name":"%1","liters":%2,"distance":%3}',
            (getText (configOf _src >> "displayName")) call _jsonEscape,
            round _litres,
            round _dist
        ];
    } forEach _fuel;
    // The apply charges the nearest source, so that is the supply the page budgets with
    if (_ammo isNotEqualTo []) then {_totalSupply = ((_ammo # 0) # 2) max 0};
    {
        _x params ["_src", "_dist", "_supply"];
        _ammoRows pushBack format ['{"name":"%1","supply":%2,"unlimited":%3,"distance":%4}',
            (getText (configOf _src >> "displayName")) call _jsonEscape,
            round _supply,
            ["false", "true"] select (_supplyMode == 0),
            round _dist
        ];
    } forEach _ammo;
};

private _farpFuelJson = format ['[%1]', _fuelRows joinString ','];
private _rearmJson = format ['{"mode":%1,"totalSupply":%2,"unlimited":%3,"trucks":[%4],"costs":%5}',
    _supplyMode,
    [round _totalSupply, -1] select (_supplyMode == 0),
    ["false", "true"] select (_supplyMode == 0),
    _ammoRows joinString ',',
    _costJson
];

// ── Ammo List (always INF — limit enforcement not yet implemented) ──────────
private _ammoLimitJson = '{"enabled":false,"ammo":[{"key":"AGM114K","label":"AGM-114K","count":-1},{"key":"AGM114L","label":"AGM-114L","count":-1},{"key":"AGM114K2A","label":"AGM-114K2A","count":-1},{"key":"AGM114FA","label":"AGM-114FA","count":-1},{"key":"AGM114N","label":"AGM-114N","count":-1},{"key":"M151","label":"M151","count":-1},{"key":"M261","label":"M261","count":-1},{"key":"M255A1","label":"M255A1","count":-1},{"key":"M257","label":"M257","count":-1},{"key":"M278","label":"M278","count":-1},{"key":"M230","label":"M230","count":-1}]}';

private _seedFuelRate = (["fza_mplanner_fuelRate", 8] call _setting) max 0.1;
private _seedRearmMode = (round (["fza_mplanner_rearmMode", 1] call _setting)) max 0 min 2;
private _seedRange = ["fza_mplanner_sourceDistance", 25] call _setting;

private _payload = format [
    '{"player":{"uid":"%1","name":"%2"},"environment":%3,"currentConfig":"%4","own":%5,"mission":%6,"farpFuel":%7,"farpRearm":%8,"ammoLimits":%9,"fuelRateLS":%10,"rearmMode":%11,"noAmmoSourceRequired":%12,"noFuelSourceRequired":%13,"sourceDistance":%14}',
    (getPlayerUID player) call _jsonEscape,
    (name player) call _jsonEscape,
    if (isNil "bmkhs_helisimEnvironment" || {!(bmkhs_helisimEnvironment isEqualType 0)}) then { "null" } else { bmkhs_helisimEnvironment },
    (missionNamespace getVariable ["fza_mplanner_last_loaded_config", ""]) call _jsonEscape,
    [profileNamespace getVariable ["fza_mplanner_saves_own", []]] call _serializeEntries,
    [missionNamespace getVariable ["fza_mplanner_saves_mission", []]] call _serializeEntries,
    _farpFuelJson,
    _rearmJson,
    _ammoLimitJson,
    _seedFuelRate,
    _seedRearmMode,
    ["false", "true"] select _seedNoAmmoSrc,
    ["false", "true"] select _seedNoFuelSrc,
    round _seedRange
];

private _jsCode = format ["window.fza_mplanner_receiveSeed && window.fza_mplanner_receiveSeed('%1');", _payload call _jsEscape];
[_browser, _jsCode] call fza_mpd_fnc_execJs;

true;
