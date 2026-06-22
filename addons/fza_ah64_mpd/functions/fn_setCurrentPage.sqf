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
params ["_heli", "_side", "_page", ["_stateOverride", createHashMap]];

private _mpdState = _heli getVariable "fza_mpd_mpdState";

private _config = configOf _heli >> "FzaMpdPages" >> _page;

if (!isClass _config) exitWith {
    ["Invalid MPD page for %1 : %2", typeOf _heli, _page] call BIS_fnc_error;
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

// Minigames: any FzaMpdPages entry with a minigameUrl swaps this side's screens to a dedicated per-game browser-only display, and back on the way out.
private _sideName = ["left", "right"] select _side;
private _selections = [["plt_pl_mpd_back", "cpg_cl_mpd_back"], ["plt_pr_mpd_back", "cpg_cr_mpd_back"]] select _side;
private _oldMinigameUrl = (_mpdState # _side) select 8;
private _minigameUrl = "";
if (isText (_config >> "minigameUrl")) then {
    _minigameUrl = getText (_config >> "minigameUrl");
};
if (_oldMinigameUrl != _minigameUrl) then {
    if (_minigameUrl != "") then {
        private _minigameClass = "RscFzaMinigameBase";
        if (isText (_config >> "minigameClass")) then {
            _minigameClass = getText (_config >> "minigameClass");
        };
        // Distinct uniqueName ("XGame" not "X") so the engine never confuses this with the canvas display instance.
        private _gameUniqueId = _sideName + "Game";
        {_heli setObjectTexture [_x, "#(rgb,1024,1024,1)ui(" + _minigameClass + "," + _gameUniqueId + ")"]} forEach _selections;
    } else {
        {_heli setObjectTexture [_x, "#(rgb,1024,1024,1)ui(RscFzaAH64MPD," + _sideName + ")"]} forEach _selections;
    };
};

private _persistState = _mpdState # _side # 5;

private _state = (_config >> "InitState") call fza_fnc_configToHashMap;
_state merge [_stateOverride, true];

if !(_page in _persistState) then {
    _persistState set [_page, (_config >> "PersistState") call fza_fnc_configToHashMap]
};
_state set ["side", _side];
_state set ["page", _page];
private _newState = [_page, _mfdIndex, _drawFunc, _drawCanvasFunc, _state, _persistState, _handleControlFunc, _usesIcons, _minigameUrl];

_heli setUserMFDValue [_side + 1, _mfdIndex];
_mpdState set [_side, _newState];
[_heli] call fza_mpd_fnc_propagatePage;
