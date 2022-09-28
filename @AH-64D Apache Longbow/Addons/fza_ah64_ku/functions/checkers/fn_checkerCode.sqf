params ["_input"];

private _validRegex = _input regexMatch "^1[1-7][1-8][1-8]$";

if !_validRegex exitWith {false};

[true, parseNumber _input];