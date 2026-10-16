// fza_mg_fnc_minigamePersistDataChunk - receives one chunk of a chunked-write sequence, accumulates in profileNamespace, and commits on the final chunk. Mirrors the chunked-read mechanism (fn_minigamePushChunkedString.sqf) but in the write direction - needed because A3API.SendAlert has a string-length limit that save-game data (up to ~240KB base64) exceeds if pushed in a single call. Params: _gameId, _key, _chunkIndex, _totalChunks, _chunk.
params [["_gameId", "", [""]], ["_key", "", [""]], ["_chunkIndex", 0, [0]], ["_totalChunks", 1, [0]], ["_chunk", "", [""]]];
if (_gameId == "" || _key == "") exitWith {};

private _accKey = format ["fza_minigame_persist_%1_%2_acc", _gameId, _key];
// A new write starts clean, so a save cut off part-way cannot leak into this one
private _acc = ["", profileNamespace getVariable [_accKey, ""]] select (_chunkIndex > 0);
profileNamespace setVariable [_accKey, _acc + _chunk];

if (_chunkIndex >= _totalChunks - 1) then {
    // Last chunk - commit the assembled data to the real key and clean up the accumulator.
    private _finalKey = format ["fza_minigame_persist_%1_%2", _gameId, _key];
    profileNamespace setVariable [_finalKey, _acc + _chunk];
    profileNamespace setVariable [_accKey, nil];
    saveProfileNamespace;
};
