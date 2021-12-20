params ["_input"];
private _valid =_input regexMatch "^\d+$";
if !(_valid) exitWith {false};
[true, parseNumber _input];