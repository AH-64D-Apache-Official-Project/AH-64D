// fza_mg_fnc_minigamePushChunkedString - pushes a string into a minigame page in chunks via ExecJS, calling window.fza_minigame_onLargeAssetChunk(assetName, chunk, chunkIndex, totalChunks) for each piece. Shared by fn_minigameRequestLargeAsset.sqf (loadFile-sourced) and fn_minigameRequestPersistedData.sqf (profileNamespace-sourced) - same size ceilings (LoadFile's page limit doesn't apply here, but format()'s own lower one does) apply regardless of where the content came from. Params: _browserCtrl, _assetName, _content.
params [["_browserCtrl", controlNull], ["_assetName", ""], ["_content", ""]];
if (isNull _browserCtrl || _assetName == "" || _content == "") exitWith {};

[_browserCtrl, _assetName, _content] spawn {
    params ["_browserCtrl", "_assetName", "_content"];
    private _execJs = compile "params ['_b','_c']; _b ctrlWebBrowserAction ['ExecJS', _c];";

    // Base64's restricted alphabet [A-Za-z0-9+/=] needs no escaping for a JS string literal - not safe for arbitrary/untrusted text.
    private _chunkSize = 2000000;
    private _len = count _content;
    private _totalChunks = ceil (_len / _chunkSize);
    private _offset = 0;
    private _chunkIndex = 0;
    while {_offset < _len} do {
        private _chunk = _content select [_offset, _chunkSize];
        private _jsCode = format ["window.fza_minigame_onLargeAssetChunk(""%1"", ""%2"", %3, %4);", _assetName, _chunk, _chunkIndex, _totalChunks];
        [_browserCtrl, _jsCode] call _execJs;
        _offset = _offset + _chunkSize;
        _chunkIndex = _chunkIndex + 1;
        sleep 0.05; // give ExecJS calls room to actually process - firing them back-to-back risks dropped calls
    };
};
