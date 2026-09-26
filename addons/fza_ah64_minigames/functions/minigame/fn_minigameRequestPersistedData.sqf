// fza_mg_fnc_minigameRequestPersistedData - reads a previously fza_mg_fnc_minigamePersistData-saved string back out of profileNamespace and pushes it into the page via the shared chunked-ExecJS helper, same window.fza_minigame_onLargeAssetChunk callback fn_minigameRequestLargeAsset.sqf uses (the page's reassembly code doesn't care where the chunks came from). If nothing's been persisted yet, calls window.fza_minigame_onPersistedDataEmpty instead so the page can proceed with defaults rather than waiting forever. Params: _gameId, _key.
params [["_gameId", ""], ["_key", ""]];
if (_gameId == "" || _key == "") exitWith {};

private _display = [vehicle player, _gameId] call fza_mg_fnc_minigameFindDisplay;
if (isNull _display) exitWith {};
private _browserCtrl = _display displayCtrl 369;
if (isNull _browserCtrl) exitWith {};

private _content = profileNamespace getVariable [format ["fza_minigame_persist_%1_%2", _gameId, _key], ""];
if (_content == "") exitWith {
    private _jsCode = format ["if (window.fza_minigame_onPersistedDataEmpty) window.fza_minigame_onPersistedDataEmpty(""%1"");", _key];
    [_browserCtrl, _jsCode] call compile "params ['_b','_c']; _b ctrlWebBrowserAction ['ExecJS', _c];";
};

[_browserCtrl, _key, _content] call fza_mg_fnc_minigamePushChunkedString;
