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
