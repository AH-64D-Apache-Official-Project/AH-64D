// fza_mg_fnc_minigameGameIdOf - game id of a minigame page URL ("...\ui\minigame\games\<id>\game.html"), "" for any other page. Params: _url. Returns: string.
params [["_url", "", [""]]];
if ((_url find "\ui\minigame\") == -1) exitWith { "" };
private _i = _url find "\games\";
if (_i == -1) exitWith { "" };
private _rest = _url select [_i + 7];
private _end = _rest find "\";
if (_end < 1) exitWith { "" };
_rest select [0, _end]
