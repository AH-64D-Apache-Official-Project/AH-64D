#include "\fza_ah64_dms\headers\constants.h"
/* ----------------------------------------------------------------------------
Function: fza_mplanner_fnc_dtcSeed

Description:
    Sends the planner page its DTC data: the saved DTCs on this map, the idents
    each point file takes, and for "open" the DTC in the aircraft (or what it
    holds), for "readback" what the aircraft holds now.

Parameters:
    _mode - "open", "readback" or "saves"

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params [["_mode", "open", [""]]];

private _browser = (uiNamespace getVariable ["fza_mplanner_display", displayNull]) displayCtrl 100;
if (isNull _browser) exitWith {};
private _heli = uiNamespace getVariable ["fza_mplanner_target", objNull];

private _list = {
    params ["_saves"];
    (_saves select {(_x param [2, worldName]) == worldName}) apply {
        createHashMapFromArray [["name", _x # 0], ["json", _x # 1], ["by", _x param [3, ""]]]
    }
};
private _payload = createHashMapFromArray [
    ["mode", _mode],
    ["world", worldName],
    ["loaded", _heli getVariable ["fza_dms_dtcName", ""]],
    ["own", [profileNamespace getVariable ["fza_mplanner_dtc_own", []]] call _list],
    ["mission", [missionNamespace getVariable ["fza_mplanner_dtc_mission", []]] call _list]
];

switch (_mode) do {
    case "open": {
        if (!isNull _heli) then {_payload set ["dtc", fromJSON ([_heli] call fza_dms_fnc_dtcToJson)]};
        // The idents each point file takes, the target file's threats (IconTypeG, the two-letter ones) apart from its
        // targets, and each ident's icon: its textures by name (tsd_icon_data.js) and the colour they are drawn in
        private _idents = createHashMapFromArray [["wp", []], ["hz", []], ["cm", []], ["tt", []], ["th", []]];
        private _icons = createHashMap;
        private _texKey = {
            params ["_path"];
            private _name = toLower ((_path splitString "\/") param [-1, ""]);
            if (_name find ".paa" >= 0) then {_name = _name select [0, _name find ".paa"]};
            if (_name select [(count _name) - 3] == "_ca") then {_name = _name select [0, (count _name) - 3]};
            _name
        };
        {
            private _key = ["wp", "hz", "cm", "", "tt"] param [getNumber (_x >> "type"), ""];
            if (_key == "") then {continue};
            if (_key == "tt") then {
                private _base = _x;
                while {configName _base != "" && {configName _base != "IconTypeG"}} do {_base = inheritsFrom _base};
                if (configName _base == "IconTypeG") then {_key = "th"};
            };
            private _name = configName _x;
            if (_name select [0, 4] == "Icon") then {_name = _name select [4]};
            (_idents get _key) pushBackUnique _name;
            _icons set [_name, [[getText (_x >> "tex")] call _texKey, [getText (_x >> "tex2")] call _texKey, getArray (_x >> "color")]];
        } forEach ("isNumber (_x >> 'type')" configClasses (configFile >> "FzaIconTypes"));
        _payload set ["idents", _idents];
        _payload set ["icons", _icons];
    };
    case "readback": {
        if (!isNull _heli) then {_payload set ["dtc", fromJSON ([_heli, true] call fza_dms_fnc_dtcToJson)]};
    };
};

private _code = format ["window.fzaDtc && window.fzaDtc.receiveSeed(%1);", toJSON _payload];
[_browser, _code] call compile "params ['_b','_c']; _b ctrlWebBrowserAction ['ExecJS', _c];";
