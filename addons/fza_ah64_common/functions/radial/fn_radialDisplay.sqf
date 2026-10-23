/* ----------------------------------------------------------------------------
Function: fza_fnc_radialDisplay

Description:
    Load and unload of the radial menu display: its labels, mouse and key
    handlers and the per frame update, all gone with the display.

Parameters:
    _event - "onLoad" or "onUnload"
    _args  - The display event's arguments

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "radial.hpp"
params ["_event", "_args"];
_args params ["_display"];

if (_event == "onUnload") exitWith {
    [_display getVariable ["fza_radialPfh", -1]] call CBA_fnc_removePerFrameHandler;
    uiNamespace setVariable ["fza_radialDisplay", displayNull];
    uiNamespace setVariable ["fza_radialOpen", false];
    private _hct = uiNamespace getVariable ["fza_radialHctRestore", []];
    uiNamespace setVariable ["fza_radialHctRestore", []];
    if (_hct isNotEqualTo [] && {!isNil "hct_interaction_fnc_keyCursor"}) then {
        // A display is not made while another closes
        [{
            params ["_held", "_mouse"];
            if (_held && {inputAction "hct_interaction_cursor" <= 0}) exitWith {};
            if (!isNull findDisplay 86005 || {!isNull (uiNamespace getVariable ["fza_radialDisplay", displayNull])}) exitWith {};
            true call hct_interaction_fnc_keyCursor;
            if (!isNull findDisplay 86005) then {setMousePosition _mouse};
        }, _hct] call CBA_fnc_execNextFrame;
    };
};

// Opened by anything but fza_fnc_radialToggle, there is no helicopter to work on
private _heli = uiNamespace getVariable ["fza_radialHeli", objNull];
uiNamespace setVariable ["fza_radialHeli", objNull];
if (isNull _heli) exitWith {
    [{_this closeDisplay 2}, _display] call CBA_fnc_execNextFrame;
};

// Never two menus
private _old = uiNamespace getVariable ["fza_radialDisplay", displayNull];
if (!isNull _old && {_old != _display}) then {_old closeDisplay 2};

uiNamespace setVariable ["fza_radialDisplay", _display];
uiNamespace setVariable ["fza_radialOpen", true];
_display setVariable ["fza_radialHeli", _heli];
_display setVariable ["fza_radialKeyHeld", inputAction "fza_ah64_radialMenu" > 0.5];

private _labels = [];
for "_i" from 0 to (RADIAL_LABELS - 1) do {
    private _ctrl = _display ctrlCreate ["fza_radialLabel", RADIAL_IDC_LABEL + _i];
    _ctrl ctrlShow false;
    _labels pushBack _ctrl;
};
_display setVariable ["fza_radialLabels", _labels];

[_display, "top"] call fza_fnc_radialSetMenu;

_display displayAddEventHandler ["MouseButtonDown", {
    params ["_display", "_button"];
    // The menu key on a mouse button, which the game's own binding does not see over a display
    if ((65536 + _button) in actionKeys "fza_ah64_radialMenu") exitWith {
        [_display getVariable ["fza_radialHeli", objNull]] call fza_fnc_radialToggle;
    };
    if (_button == 1) exitWith {
        if ((_display getVariable ["fza_radialMenu", "top"]) == "top") then {_display closeDisplay 2} else {[_display, "top"] call fza_fnc_radialSetMenu};
    };
    if (_button != 0) exitWith {};
    [_display, _display getVariable ["fza_radialMouseHover", RADIAL_NONE]] call fza_fnc_radialSelect;
}];
_display displayAddEventHandler ["KeyDown", {
    params ["_display", "_key"];
    // Escape
    if (_key == 1) exitWith {_display closeDisplay 2; true};
    false
}];

setMousePosition [0.5, 0.5];
_display setVariable ["fza_radialPfh", [{
    (_this # 0) params ["_display"];
    if (isNull _display) exitWith {[_this # 1] call CBA_fnc_removePerFrameHandler};
    [_display] call fza_fnc_radialUpdate;
}, 0, [_display]] call CBA_fnc_addPerFrameHandler];
