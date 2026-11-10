params ["_display"];

disableSerialization;
uiNamespace setVariable ["fza_setup_display", _display];

private _browser = _display displayCtrl 100;
if (isNull _browser) exitWith {};
(_display displayCtrl 101) ctrlShow false;

// Hatchet's interaction and cursor stop while the setup is open, as for the mission planner
if (isNil {uiNamespace getVariable "BIS_fnc_camera_display"}) then {
    uiNamespace setVariable ["BIS_fnc_camera_display", _display];
    uiNamespace setVariable ["fza_setup_hidHatchet", true];
};
with uiNamespace do {
    if (!isNil "hct_cursor_ctrl") then {
        ctrlDelete hct_cursor_ctrl;
        hct_cursor_ctrl = nil;
    };
};

// Only "fzasetup:" + JSON from the page is read, and never compiled
_browser ctrlAddEventHandler [["JS", "Dialog"] joinString "", {
    params ["_control", "_isConfirmDialog", "_message"];
    if (_isConfirmDialog || {!(_message isEqualType "")} || {(_message find "fzasetup:") != 0}) exitWith {false};
    [_control, _message select [9]] call fza_setup_fnc_bridge;
    true
}];
