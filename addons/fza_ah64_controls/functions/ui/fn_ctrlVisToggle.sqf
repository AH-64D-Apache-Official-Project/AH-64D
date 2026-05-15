/* ----------------------------------------------------------------------------
Function: fza_fnc_ctrlVisToggle

Description:
    Toggles the Control Input Visualiser overlay on/off.
    When opened for the first time, also enables the drag cursor so the player
    can immediately position the widget.  A second press hides it (and closes
    the cursor if this widget was the one that opened it).

Parameters:
    None

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
if !(vehicle player isKindOf "fza_ah64base") exitWith {};

private _layer = "fza_ah64_ctrlvis" call BIS_fnc_rscLayer;

// Check whether the display is currently shown
private _display = uiNameSpace getVariable ["fza_ah64_ctrlvis", displayNull];
private _isShown = !isNull _display;

if (_isShown) then {
    // Hide
    _layer cutText ["", "PLAIN", 0, false];
    uiNameSpace setVariable ["fza_ah64_ctrlvis", displayNull];
} else {
    // Show
    _layer cutRsc ["fza_ah64_ctrlvis", "PLAIN", 0, false];
};
