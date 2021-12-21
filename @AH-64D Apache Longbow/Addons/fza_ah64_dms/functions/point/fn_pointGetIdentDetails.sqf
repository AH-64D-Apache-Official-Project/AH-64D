params ["_ident"];

//Returns -1 for invalid identifier, or [texture, offset]

private _config = configFile >> "FzaIconTypes" >> _ident;

if (!isClass _config) then {
    _config = configFile >> "FzaIconTypes" >> "Icon" + _ident;
};

if (!isClass _config) exitWith {};

private _tex = "";
if (isText (_config >> "tex")) then {
    _tex = getText (_config >> "tex");
};

private _offset = [0,0];
if (isArray (config >> "offset")) then {
    _offset = getArray (_config >> "offset");
};

[_tex, _offset];