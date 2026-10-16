// fza_mg_fnc_minigameSetPaused - toggles the manual on-screen pause for one minigame display. Params: _display, _paused.
params ["_display", ["_paused", true]];
if (isNull _display) exitWith {};

_display setVariable ["fza_mpd_minigameManualPaused", _paused];
private _browserCtrl = _display displayCtrl 369;
if (!isNull _browserCtrl) then {
    [_browserCtrl, format ["window.fza_minigame_setManualPaused(%1);", _paused]] call fza_mpd_fnc_execJs;
};
