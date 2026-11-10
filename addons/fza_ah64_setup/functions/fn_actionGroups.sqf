/* ----------------------------------------------------------------------------
Function: fza_setup_fnc_actionGroups

Description:
    Maps each bindable action to the Controls menu category listing it, a
    current category before the legacy ones that also list it.

Parameters:
    None

Returns:
    Lower case action name -> [category class, category name, legacy] <HASHMAP>

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
if (!isNil "fza_setup_groupMap") exitWith {fza_setup_groupMap};

private _legacy = ["all", "basicinfantrycontrols", "car", "air", "helicopter", "submarine", "buldozer", "useractions"];
private _map = createHashMap;
{
    private _class = configName _x;
    private _isLegacy = (toLower _class) in _legacy;
    private _name = getText (_x >> "name");
    if ((_name select [0, 4]) == "$STR") then {_name = localize (_name select [1])};
    {
        if (_x isEqualType "") then {
            private _prev = _map getOrDefault [toLower _x, []];
            if (_prev isEqualTo [] || {(_prev # 2) && !_isLegacy}) then {
                _map set [toLower _x, [_class, _name, _isLegacy]];
            };
        };
    } forEach getArray (_x >> "group");
} forEach ("true" configClasses (configFile >> "UserActionGroups"));

fza_setup_groupMap = _map;
_map
