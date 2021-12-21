params ["_type", "_ident"];

private _config = configFile >> "FzaIconTypes" >> _ident;

if (!isClass _config) then {
    _config = configFile >> "FzaIconTypes" >> "Icon" + _ident;
};

if (!isClass _config) exitWith {};

private _configNum = _config >> "type";

if !(isNumber _configNum) exitWith {false};

getNumber _configNum == _type;