/* ----------------------------------------------------------------------------
Function: fza_docs_fnc_bridge

Description:
    Handles a message from the manual: a JSON object with a "cmd".

Parameters:
    _ctrl - The manual's browser control <CONTROL>
    _json - The message <STRING>

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_ctrl", "_json"];

private _msg = fromJSON _json;
if !(_msg isEqualType createHashMap) exitWith {};

private _string = {
    private _v = _msg getOrDefault [_this, ""];
    [_v, ""] select !(_v isEqualType "")
};

switch (_msg getOrDefault ["cmd", ""]) do {
    case "ready": {
        private _payload = createHashMapFromArray [["type", "init"], ["path", uiNamespace getVariable ["fza_docs_path", "/"]]];
        [_ctrl, "window.fzaDocs && window.fzaDocs.receive(" + toJSON _payload + ");"] call fza_mpd_fnc_execJs;
        private _date = "date" call _string;
        if (_date isNotEqualTo "") then {
            ((ctrlParent _ctrl) displayCtrl 101) ctrlSetText ("AH-64D MANUAL  -  " + _date);
        };
    };
    case "page": {
        uiNamespace setVariable ["fza_docs_path", "path" call _string];
    };
    case "external": {
        private _url = "url" call _string;
        if (_url isEqualTo "") exitWith {};
        if (!isMultiplayer) then {copyToClipboard _url};
        hintSilent parseText format ["Links to other sites open in a web browser:<br/>%1%2", _url, ["", "<br/>(copied)"] select !isMultiplayer];
    };
    case "csp": {
        diag_log format ["fza_docs: page policy blocked %1 (%2): %3", "blocked" call _string, "directive" call _string, "policy" call _string];
    };
};
