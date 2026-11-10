/* ----------------------------------------------------------------------------
Function: fza_setup_fnc_firstRun

Description:
    Opens the controls setup in place of the welcome popup until the player
    has finished it or chosen not to see it again.

Parameters:
    None

Returns:
    The setup was opened <BOOL>

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
if (!hasInterface || {profileNamespace getVariable ["fza_ah64_setupDone", false]}) exitWith {false};
if (!isNull (uiNamespace getVariable ["fza_setup_display", displayNull]) || {isNull findDisplay 46}) exitWith {false};

fza_ah64_introShownThisScenario = true;
[] call fza_setup_fnc_open;
true
