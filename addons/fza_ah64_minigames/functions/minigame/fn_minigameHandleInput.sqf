// fza_mg_fnc_minigameHandleInput - forwards keybind input to whichever minigame browser(s) are active for the local player's seat. Params: _action ("up"/"down"/"left"/"right"), _isDown.
disableSerialization;
params [["_action", ""], ["_isDown", false]];

private _heli = vehicle player;
if (!(_heli isKindOf "fza_ah64base")) exitWith {};
if (driver _heli != player && {gunner _heli != player}) exitWith {};

private _mpdState = _heli getVariable ["fza_mpd_mpdState", []];
if (count _mpdState != 2) exitWith {};

private _loadedMPDs = uiNamespace getVariable ["fza_mpd_minigameDisplay", createHashMap];
private _jsCode = format ["if (window.fza_minigame_input) window.fza_minigame_input('%1', %2);", _action, _isDown];

{
    private _minigameUrl = _x select 8;
    if (_minigameUrl != "") then {
        private _sideName = (["left", "right"] select _forEachIndex) + "Game";
        private _browserCtrl = (_loadedMPDs getOrDefault [_sideName, displayNull]) displayCtrl 369;
        if (!isNull _browserCtrl) then {
            [_browserCtrl, _jsCode] call compile "params ['_b','_c']; _b ctrlWebBrowserAction ['ExecJS', _c];";
        };
    };
} forEach _mpdState;
