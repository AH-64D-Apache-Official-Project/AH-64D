// fza_mg_fnc_minigameEscapeJsString - escapes a string for safe embedding in a double-quoted JS string literal built
// via SQF format (used for player names, which are user-controlled and could contain quotes/backslashes). Works on
// character codes rather than string literals to avoid any quoting ambiguity in this file itself.
// 34 = '"', 92 = '\'. Params: _str. Returns: escaped string.
params [["_str", ""]];
private _outCodes = [];
{
    if (_x == 34 || _x == 92) then { _outCodes pushBack 92; };
    _outCodes pushBack _x;
} forEach (toArray _str);
toString _outCodes
