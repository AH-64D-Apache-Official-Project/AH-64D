params ["_display"];

disableSerialization;
uiNamespace setVariable ["fza_mplanner_display", _display];

private _browser = _display displayCtrl 100;
if (isNull _browser) exitWith {};

private _eventName = ["JS", "Dialog"] joinString "";

_browser ctrlAddEventHandler [_eventName, {
	params ["_control", "_isConfirmDialog", "_message"];

	if (_isConfirmDialog) exitWith {false};
	if !(_message isEqualType "") exitWith {false};
	if ((_message find "sqf:") != 0) exitWith {false};

	private _code = _message select [4];
	if (_code isEqualTo "") exitWith {false};

	call compile _code;
	true
}];
// Intercept ESC key so modals close before the dialog itself closes.
// The JS window.fza_mplanner_handleEscape function handles scope logic;
// if no modal is open it calls SQF to close the display.
_display displayAddEventHandler ["KeyDown", {
    params ["_display", "_key"];
    if (_key != 1) exitWith {false};   // 1 = DIK_ESCAPE
    private _browser = _display displayCtrl 100;
    private _jsEsc = "var fn=window.fza_mplanner_handleEscape;if(fn)fn();";
    [_browser, _jsEsc] call compile "params ['_b','_c']; _b ctrlWebBrowserAction ['ExecJS', _c];";
    true   // block Arma's default ESC-closes-dialog behaviour
}];

// Seed saves and current config once the browser has finished loading.
// fza_mplanner_ready is set to false NOW (before spawning), so even if the
// HTML fires the ready signal before the spawn's first tick, the spawn will
// see the updated true value when it runs its first waitUntil check.
uiNamespace setVariable ["fza_mplanner_ready", false];
[_display] spawn {
    params ["_display"];
    disableSerialization;
    private _t0 = diag_tickTime;
    waitUntil {
        uiSleep 0.1;
        uiNamespace getVariable ["fza_mplanner_ready", false]
        || {isNull _display}
        || {(diag_tickTime - _t0) > 5}
    };
    if (isNull _display) exitWith {};
    [] call fza_mplanner_fnc_seedSaves;
    [] call fza_mplanner_fnc_seedCurrentConfig;
};
