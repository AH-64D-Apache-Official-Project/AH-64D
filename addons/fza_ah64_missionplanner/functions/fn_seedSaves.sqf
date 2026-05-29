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

private _payload = format [
    '{"player":{"uid":"%1","name":"%2"},"environment":%3,"currentConfig":"%4","own":%5,"mission":%6}',
    (getPlayerUID player) call _jsonEscape,
    (name player) call _jsonEscape,
    fza_ah64_sfmplusEnvironment,
    (profileNamespace getVariable ["fza_mplanner_last_loaded_config", ""]) call _jsonEscape,
    [profileNamespace getVariable ["fza_mplanner_saves_own", []]] call _serializeEntries,
    [missionNamespace getVariable ["fza_mplanner_saves_mission", []]] call _serializeEntries
];

private _jsCode = format ["window.fza_mplanner_receiveSeed && window.fza_mplanner_receiveSeed('%1');", _payload call _jsEscape];
call compile format ["((uiNamespace getVariable ['fza_mplanner_display', displayNull]) displayCtrl 100) ctrlWebBrowserAction [""ExecJS"", %1];", str _jsCode];

true;
