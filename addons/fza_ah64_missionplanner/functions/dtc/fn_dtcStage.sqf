// The planner's DTC into the aircraft, loaded by DTU MASTER LOAD (fza_dms_fnc_dtcLoad)
params [["_json", "", [""]]];

private _heli = uiNamespace getVariable ["fza_mplanner_target", objNull];
private _result = if (isNull _heli) then {[false, "No aircraft"]} else {[_heli, _json] call fza_dms_fnc_dtcFromJson};
_result params ["_ok", "_why"];

private _browser = (uiNamespace getVariable ["fza_mplanner_display", displayNull]) displayCtrl 100;
if (isNull _browser) exitWith {};
private _message = ["DTC not loaded: " + _why, "DTC in the aircraft. Load it with DTU MASTER LOAD."] select _ok;
private _code = format ["window.fzaDtc && window.fzaDtc.onStaged(%1,%2);", _ok, toJSON _message];
[_browser, _code] call compile "params ['_b','_c']; _b ctrlWebBrowserAction ['ExecJS', _c];";
