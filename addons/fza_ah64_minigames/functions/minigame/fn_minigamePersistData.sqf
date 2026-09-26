// fza_mg_fnc_minigamePersistData - writes a string into profileNamespace under a per-game, per-key slot and saves it to disk. Generic persistence for any minigame (config, save-game slots, etc.) - not Doom-specific despite being built for it. Params: _gameId, _key, _data.
params [["_gameId", ""], ["_key", ""], ["_data", ""]];
if (_gameId == "" || _key == "") exitWith {};

profileNamespace setVariable [format ["fza_minigame_persist_%1_%2", _gameId, _key], _data];
saveProfileNamespace;
