params ["_disp", "_type"];

//TODO: Cache config lookup
private _ctrlConfig = configfile >> "RscTitles" >> "fza_ah64_symbology" >> "controls" >> "fza_ah64_symbology";
private _parentGroup = _disp displayCtrl 961;

private _ctrl = _disp ctrlCreate [_ctrlConfig, -1, _parentGroup];
_ctrl setVariable ["fza_ihadss_icon_type", _type];
_ctrl setVariable ["fza_ihadss_icon_ready", false];
_ctrl ctrlSetPosition [-100, -100, 0.1, 0.1*(4*3)];
_ctrl ctrlCommit 0;
_ctrl ctrlShow false;
_ctrl ctrlAddEventHandler ["PageLoaded", {
    params ["_ctrl"];
    _ctrl ctrlWebBrowserAction ["ExecJS", format ["drawIcon(""%1"")", _ctrl getVariable "fza_ihadss_icon_type"]];
    _ctrl setVariable ["fza_ihadss_icon_ready", true];

    #ifdef CMD__FZA_IHADSS_LIVE_URL
    // For some reason A3API is only available to the Javascript when running using a local html file and not when
    // using an external API. Because of this I have to just set a timer and hope the drawing operation is complete
    [{_this ctrlWebBrowserAction ["StopBrowser"]}, _ctrl, 0.5] call CBA_fnc_waitAndExecute;
    _ctrl setVariable ["stopBrowser", true];
    #else
    // Wait until we have confirmation that the draw is complete, wait for it to be rendered and then stop the browser
    // after a 0.1s delay.
    _ctrl ctrlAddEventHandler ["JSDialog", {
        params ["_ctrl", "_isConfirmDialog", "_message"];

        if (_isConfirmDialog || _message != "drawcomplete") exitWith {};

        _ctrl ctrlAddEventHandler ["Draw", {
            params ["_ctrl"];
            [{_this ctrlWebBrowserAction ["StopBrowser"]; _this setVariable ["stopBrowser", true]}, _ctrl, 0.1] call CBA_fnc_waitAndExecute;
            _ctrl ctrlRemoveEventHandler ["Draw", _thisEventHandler];
        }];

        _ctrl ctrlRemoveEventHandler ["JSDialog", _thisEventHandler];
    }];
    #endif

    _ctrl ctrlRemoveEventHandler ["PageLoaded", _thisEventHandler];
}];
_ctrl;