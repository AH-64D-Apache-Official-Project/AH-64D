params ["_display"];

disableSerialization;
uiNamespace setVariable ["fza_docs_display", _display];

private _browser = _display displayCtrl 100;
if (isNull _browser) exitWith {};

// Hatchet's interaction and cursor stop while the manual is open, as for the mission planner
if (isNil {uiNamespace getVariable "BIS_fnc_camera_display"}) then {
    uiNamespace setVariable ["BIS_fnc_camera_display", _display];
    uiNamespace setVariable ["fza_docs_hidHatchet", true];
};
with uiNamespace do {
    if (!isNil "hct_cursor_ctrl") then {
        ctrlDelete hct_cursor_ctrl;
        hct_cursor_ctrl = nil;
    };
};

// Only "fzadocs:" + JSON from the page is read, and never compiled
_browser ctrlAddEventHandler [["JS", "Dialog"] joinString "", {
    params ["_control", "_isConfirmDialog", "_message"];
    if (_isConfirmDialog || {!(_message isEqualType "")} || {(_message find "fzadocs:") != 0}) exitWith {false};
    [_control, _message select [8]] call fza_docs_fnc_bridge;
    true
}];
