/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_setCurrentPage

Description:
    Sets the display on each page.

Parameters:
    _heli - the apache to show the correct values for.
    _side - 0 for left MPD, 1 for right MPD
    _page - page name
    _stateOverride - (Optional) modifications to apply to the config-defined state.

Returns:
    True if change was made, false if not.

Examples:
    --- Code
    _ret = [_heli 0, "fuel"] call fza_mpd_fnc_setCurrentPage;
    // _ret => true
    ---

    --- Code
    _ret = [_heli 0, "tsd"] call fza_mpd_fnc_setCurrentPage;
    // _ret => false (left MPD can't show the TSD)
    ---

Author:
    mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\script_common.hpp"
params ["_heli", "_side", "_page", ["_stateOverride", createHashMap]];

private _mpdState = _heli getVariable "fza_mpd_mpdState";

private _config = configFile >> "CfgVehicles" >> typeof _heli >> "FzaMpdPages" >> _page;

if (!isClass _config) exitWith {
    ["Invalid MPD page for %1 : %2", typeof _heli, _page] call BIS_fnc_error;
};

private _mfdIndex = 0;
if (isNumber (_config >> "index")) then {
    _mfdIndex = getNumber (_config >> "index");
};

private _drawFunc = {};
if (isText (_config >> "draw")) then {
    _drawFunc = missionNamespace getVariable getText (_config >> "draw");
};

private _drawCanvasFunc = {};
if (isText (_config >> "drawCanvas")) then {
    _drawCanvasFunc = missionNamespace getVariable getText (_config >> "drawCanvas");
};

private _handleControlFunc = {};
if (isText (_config >> "handleControl")) then {
    _handleControlFunc = missionNamespace getVariable getText (_config >> "handleControl");
};

private _usesIcons = 0;
if (isNumber (_config >> "usesIcons")) then {
    _usesIcons = getNumber (_config >> "usesIcons");
};

if (_mpdState # _side # 7 == 1) then {
    [_heli,[], _side, 1] call fza_mpd_fnc_drawIcons;
};

private _persistState = _mpdState # _side # 4;

private _state = (_config >> "InitState") call fza_fnc_configToHashMap;
_state merge [_stateOverride, true];

if !(_page in _persistState) then {
    _persistState set [_page, (_config >> "PersistState") call fza_fnc_configToHashMap]
};
_state set ["side", _side];
_state set ["page", _page];
private _newState = [_page, _mfdIndex, _drawFunc, _drawCanvasFunc, _state, _persistState, _handleControlFunc, _usesIcons];

_heli setUserMfdValue [_side + 1, _mfdIndex];
_mpdState set [_side, _newState];
