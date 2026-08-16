/* ----------------------------------------------------------------------------
Function: fza_mg_fnc_minigamePlayMusic

Description:
    Plays a looping Arma sound for a minigame's background music via playSoundUI, stopping any track already playing for this game. The returned id is remembered locally so fn_minigameStopMusic.sqf can stop exactly this instance, and a watchdog restarts it if Arma silently drops it early (e.g. channel contention from one-shot SFX).

Parameters:
    _gameId - string, identifies which game's "current music" slot to track (e.g. "doom")
    _trackName - string, CfgSounds class name to play
    _volume - number, optional, playSoundUI's own 0..5 multiplier range, default 1

Returns:
    Nothing
---------------------------------------------------------------------------- */
params [["_gameId", ""], ["_trackName", ""], ["_volume", 1]];
if (_gameId == "" || _trackName == "") exitWith {};
if (profileNamespace getVariable ["fza_minigame_muted", false]) exitWith {};

private _stateKey = format ["fza_minigame_music_%1", _gameId];
private _existingId = missionNamespace getVariable [_stateKey, -1];
if (_existingId != -1) then { stopSound _existingId; };

private _newId = playSoundUI [_trackName, _volume, 1, false, 0, true];
missionNamespace setVariable [_stateKey, _newId];

// Watchdog: self-terminates once a newer call replaces _stateKey's value (a real track change, or stopMusic), otherwise restarts playback if soundParams reports it stopped early.
[_gameId, _trackName, _volume, _newId, _stateKey] spawn {
    params ["_gameId", "_trackName", "_volume", "_id", "_stateKey"];
    while { (missionNamespace getVariable [_stateKey, -1]) == _id } do {
        sleep 5;
        private _stillCurrent = (missionNamespace getVariable [_stateKey, -1]) == _id;
        private _stoppedEarly = _stillCurrent && {(soundParams _id) isEqualTo []};
        if (_stoppedEarly) exitWith {
            [_gameId, _trackName, _volume] call fza_mg_fnc_minigamePlayMusic;
        };
    };
};
