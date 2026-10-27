/* ----------------------------------------------------------------------------
Function: fza_fnc_radialToggle

Description:
    The radial menu key: opens the sensor radial menu, goes back from a sub
    menu, or closes it. A press seen twice, by the user action and by the open
    menu polling it (fza_fnc_radialUpdate), counts once.

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_fnc_radialToggle
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params [["_heli", vehicle player]];

if (!hasInterface) exitWith {};
if (diag_tickTime - (uiNamespace getVariable ["fza_radialToggledAt", -1]) < 0.2) exitWith {};
uiNamespace setVariable ["fza_radialToggledAt", diag_tickTime];

private _display = uiNamespace getVariable ["fza_radialDisplay", displayNull];
if (!isNull _display) exitWith {
    if ((_display getVariable ["fza_radialMenu", "top"]) == "top") then {
        _display closeDisplay 2;
    } else {
        [_display, "top"] call fza_fnc_radialSetMenu;
    };
};

if (isNull _heli || {!alive player} || {!(_heli isKindOf "fza_ah64base")} || {vehicle player != _heli}
    || {!(player in [driver _heli, gunner _heli])} || {visibleMap} || {!isNull curatorCamera} || {dialog}) exitWith {};
if (isNull findDisplay 46) exitWith {};

// Made a frame later, over anything else the same press opens: Hatchet's cockpit cursor shares a key easily, and is a
// display of its own over the mission display. Closed under the menu, it comes back after (fza_fnc_radialDisplay)
// where it was, unless it was held open and its key is let go by then.
[{
    params ["_heli"];
    private _main = findDisplay 46;
    if (isNull _main || {!isNull (uiNamespace getVariable ["fza_radialDisplay", displayNull])}) exitWith {};
    private _hctBlocker = findDisplay 86005;
    uiNamespace setVariable ["fza_radialHctRestore", [[], [inputAction "hct_interaction_cursor" > 0, getMousePosition]] select !isNull _hctBlocker];
    if (!isNull _hctBlocker) then {_hctBlocker closeDisplay 0};
    uiNamespace setVariable ["fza_radialHeli", _heli];
    _main createDisplay "fza_radialMenu";
}, [_heli]] call CBA_fnc_execNextFrame;
