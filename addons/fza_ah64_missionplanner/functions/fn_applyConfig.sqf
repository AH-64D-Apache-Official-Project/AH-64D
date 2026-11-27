/* ----------------------------------------------------------------------------
Function: fza_mplanner_fnc_applyConfig

Description:
    Starts applying the planner's loadout to the planner's aircraft. The work,
    its progress, warnings and result are in fza_mplanner_fnc_applyRun and the
    planner page.

Parameters:
    _json      - The loadout from the page (buildLegacyApplyPayload)
    _cannonRds - Planned gun rounds, -1 to keep the current ones
    _fcr       - 1 with the FCR, 0 without, -1 as the loadout says
    _tailNum   - Tail number, "" to keep the current one
    _msnEquip  - "US" or "UK"

Returns:
    true when an apply started

Examples:
    [_json, 1200, 1, "12345", "US"] call fza_mplanner_fnc_applyConfig

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params [
    ["_json", "", [""]],
    ["_cannonRds", -1, [0]],
    ["_fcr", -1, [0]],
    ["_tailNum", "", [""]],
    ["_msnEquip", "US", [""]]
];

if (_json isEqualTo "") exitWith {false};
private _running = missionNamespace getVariable ["fza_mplanner_applyScript", scriptNull];
if (!isNull _running && {!scriptDone _running}) exitWith {
    [createHashMapFromArray [["type", "refused"], ["text", "The last apply is still finishing. Try again in a moment."]]] call fza_mplanner_fnc_pageEvent;
    false
};

uiNamespace setVariable ["fza_mplanner_applyCancel", false];
fza_mplanner_applyScript = [_json, _cannonRds, _fcr, _tailNum, _msnEquip] spawn fza_mplanner_fnc_applyRun;
true
