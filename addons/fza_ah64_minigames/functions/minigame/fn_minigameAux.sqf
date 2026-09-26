// fza_mg_fnc_minigameAux - generic b2 bezel button, free for games to repurpose (e.g. Battleship's rotate). Params: _heli, _mpdIndex.
params ["_heli", "_mpdIndex"];

private _uniqueId = ((_heli getVariable ["fza_mpd_mpdState", []]) # _mpdIndex) select 9;
private _display = (uiNamespace getVariable ["fza_mpd_minigameDisplay", createHashMap]) getOrDefault [_uniqueId, displayNull];
if (isNull _display) exitWith {};

private _browserCtrl = _display displayCtrl 369;
if (isNull _browserCtrl) exitWith {};
[_browserCtrl, "if (window.fza_minigame_aux) window.fza_minigame_aux();"] call compile "params ['_b','_c']; _b ctrlWebBrowserAction ['ExecJS', _c];";
