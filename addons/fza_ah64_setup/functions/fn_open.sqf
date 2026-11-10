/* ----------------------------------------------------------------------------
Function: fza_setup_fnc_open

Description:
    Opens the controls setup. Needs the mission display, as the Controls and
    Addon Options menus it opens are children of it.

Parameters:
    _resume - Reopen on the page it was left on (Controls menu, Addon Options or the controls test) <BOOL>

Returns:
    Nothing

Examples:
    --- Code
    [] call fza_setup_fnc_open
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params [["_resume", false, [false]]];

if (!hasInterface || {isNull findDisplay 46}) exitWith {};
if (!isNull (uiNamespace getVariable ["fza_setup_display", displayNull])) exitWith {};
if (!isNil "fza_setup_testFrame") exitWith {};

if (!_resume) then {uiNamespace setVariable ["fza_setup_resume", nil]};
uiNamespace setVariable ["fza_setup_reopen", nil];
createDialog "RscFzaControlSetup";
