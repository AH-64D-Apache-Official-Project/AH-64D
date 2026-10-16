// fza_mg_fnc_minigameBridgeCall - JS->SQF entry point for minigame pages (see bridge.js). A page sends
// "sqf:[args] call fza_mg_fnc_<name>;". The message is never compiled: the function name has to be one of the
// bridge entry points below and the arguments are read with parseSimpleArray, which only yields numbers,
// strings, booleans and arrays. Params: _message, _display (the page's). Returns: true when the call was dispatched.
params [["_message", "", [""]], ["_display", displayNull, [displayNull]]];

if ((_message find "sqf:") != 0) exitWith { false };

private _allowed = [
    "minigameReady", "minigameReportScore", "minigameSetMuted", "minigamePlaySfx", "minigamePlayMusic",
    "minigameStopMusic", "minigameReportResult", "minigameNetJoin", "minigameNetLeave", "minigameNetSend",
    "minigameRequestLargeAsset", "minigamePersistDataChunk", "minigameRequestPersistedData"
];

private _marker = "] call fza_mg_fnc_";
private _split  = _message find _marker;
if (_split < 5) exitWith {
    diag_log text format ["[fza_mg] bridge call rejected (format): %1", _message select [0, 80]];
    false
};

private _fnName = (_message select [_split + count _marker]) splitString "; " joinString "";
if !(_fnName in _allowed) exitWith {
    diag_log text format ["[fza_mg] bridge call rejected (function): %1", _message select [0, 80]];
    false
};

private _args = parseSimpleArray (_message select [4, _split - 3]);
// Tagged with the sending page, so the server relays only from the page that holds the session place
if (_fnName == "minigameNetSend") then {
    _args resize 2;
    _args pushBack (_display getVariable ["fza_mg_instanceId", ""]);
};
_args call (missionNamespace getVariable ["fza_mg_fnc_" + _fnName, {}]);
true
