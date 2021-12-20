params ["_type", "_ident"];

private _config = configFile >> "FzaIconTypes" >> _ident >> "type";

if !(isNumber _config) exitWith {false};

getNumber _config == _type;