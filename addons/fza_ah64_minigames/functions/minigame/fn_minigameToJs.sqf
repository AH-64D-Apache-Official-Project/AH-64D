// fza_mg_fnc_minigameToJs - turns an SQF value into a JS literal for a script pushed with ExecJS. Strings are
// escaped, numbers are checked for being finite, and any other type becomes null, so a value received from
// another machine can only ever be data in the page and never code. str on its own is not safe for this: it
// doubles quotes instead of backslash-escaping them. Params: _value (number, bool, string or array of those).
// Returns: JS literal as a string.
params ["_value"];

if (isNil "_value") exitWith { "null" };
if (_value isEqualType []) exitWith {
    "[" + ((_value apply { [_x] call fza_mg_fnc_minigameToJs }) joinString ",") + "]"
};
if (_value isEqualType "") exitWith {
    """" + ([_value] call fza_mg_fnc_minigameEscapeJsString) + """"
};
if (_value isEqualType 0) exitWith {
    ["0", str _value] select (finite _value)
};
if (_value isEqualType true) exitWith { str _value };
"null"
