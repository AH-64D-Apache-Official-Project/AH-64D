// fza_mg_fnc_minigameRequestLargeAsset - reads a text file via loadFile and pushes it into the page in chunks via ExecJS (CT_WEBBROWSER can't fetch()/XHR at all, and both LoadFile's ~24MB page-size limit and format()'s own lower size ceiling rule out a single push). Params: _gameId, _assetName, _pboPrefix (optional, for assets living in a different addon's PBO).
params [["_gameId", ""], ["_assetName", ""], ["_pboPrefix", "fza_ah64_minigames"]];
if (_gameId == "" || _assetName == "") exitWith {};

private _display = [vehicle player, _gameId] call fza_mg_fnc_minigameFindDisplay;
if (isNull _display) exitWith {};
private _browserCtrl = _display displayCtrl 369;
if (isNull _browserCtrl) exitWith {};

private _path = format ["\%1\ui\minigame\games\%2\%3", _pboPrefix, _gameId, _assetName];
private _content = loadFile _path;
if (_content == "") exitWith {}; // missing/empty file - nothing to push

[_browserCtrl, _assetName, _content] call fza_mg_fnc_minigamePushChunkedString;
