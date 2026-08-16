/* ----------------------------------------------------------------------------
Function: fza_mg_fnc_minigameStopMusic

Description:
    Stops whatever music track fn_minigamePlayMusic.sqf last started for this game, if any.

Parameters:
    _gameId - string, same id passed to fn_minigamePlayMusic.sqf

Returns:
    Nothing
---------------------------------------------------------------------------- */
params [["_gameId", ""]];
if (_gameId == "") exitWith {};

private _stateKey = format ["fza_minigame_music_%1", _gameId];
private _existingId = missionNamespace getVariable [_stateKey, -1];
if (_existingId != -1) then {
    stopSound _existingId;
    missionNamespace setVariable [_stateKey, -1];
};
