// fza_mg_fnc_minigameEscapeJsString - escapes a string for safe embedding in a double-quoted JS string literal built
// via SQF format (used for player names, which are user-controlled and could contain quotes/backslashes). Works on
// character codes rather than string literals to avoid any quoting ambiguity in this file itself.
// 34 = '"', 92 = '\'. Control characters and the two Unicode line separators would end the literal, so they become spaces.
// Params: _str. Returns: escaped string.
params [["_str", "", [""]]];
private _outCodes = [];
{
    if (_x == 34 || _x == 92) then {
        _outCodes pushBack 92;
        _outCodes pushBack _x;
    } else {
        _outCodes pushBack ([_x, 32] select (_x < 32 || _x == 8232 || _x == 8233));
    };
} forEach (toArray _str);
toString _outCodes
