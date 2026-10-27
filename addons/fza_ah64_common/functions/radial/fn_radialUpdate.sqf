/* ----------------------------------------------------------------------------
Function: fza_fnc_radialUpdate

Description:
    Each frame of the open radial menu. The mouse points at a sector and a
    click selects it. The radial direction actions (a stick, a hat or keys)
    held towards a sector fill it over the dwell time and select it when
    full; let go first, nothing is selected. Nothing else selects by dwell. The menu closes as soon
    as the crew station could not have opened it.

Parameters:
    _display - The radial menu display

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "radial.hpp"
params ["_display"];

private _heli = _display getVariable ["fza_radialHeli", objNull];
if (isNull _heli || {!alive _heli} || {!alive player} || {vehicle player != _heli}
    || {!(player in [driver _heli, gunner _heli])} || {visibleMap} || {!isNull curatorCamera}) exitWith {
    _display closeDisplay 2;
};

// Hatchet's cockpit cursor opened by the same press would take the mouse
private _hctBlocker = findDisplay 86005;
if (!isNull _hctBlocker) then {_hctBlocker closeDisplay 0};

// The menu key, should its user action not reach the game under this display
private _keyHeld = inputAction "fza_ah64_radialMenu" > 0.5;
if (_keyHeld && {!(_display getVariable ["fza_radialKeyHeld", false])}) then {[_heli] call fza_fnc_radialToggle};
_display setVariable ["fza_radialKeyHeld", _keyHeld];
if (isNull _display) exitWith {};

private _menu = _display getVariable ["fza_radialMenu", "top"];
([_heli, _menu] call fza_fnc_radialItems) params ["_items", "_hubText"];
// What can be selected changed (a selection with the menu kept open): laid out again
if ((_items apply {_x # 0}) isNotEqualTo ((_display getVariable ["fza_radialItems", []]) apply {_x # 0})
    || {_hubText != (_display getVariable ["fza_radialHubText", ""])}) then {
    [_display, _menu] call fza_fnc_radialSetMenu;
};
_display setVariable ["fza_radialItems", _items];

private _find = {
    params ["_bearing"];
    _items findIf {
        private _rel = (_bearing - (_x # 1)) mod 360;
        if (_rel < 0) then {_rel = _rel + 360};
        _rel < (_x # 2) - (_x # 1)
    }
};

// Mouse, in screen heights from the centre
private _k = pixelW / pixelH;
getMousePosition params ["_mx", "_my"];
private _mdx = (_mx - 0.5) / _k;
private _mdy = 0.5 - _my;
private _mouseHover = if (_mdx * _mdx + _mdy * _mdy < RADIAL_R_HUB * RADIAL_R_HUB) then {RADIAL_HUB} else {[_mdx atan2 _mdy] call _find};
_display setVariable ["fza_radialMouseHover", _mouseHover];

// Stick: the radial direction actions only, so the mouse or head tracking feeding the aim input never selects
private _sx = inputAction "fza_ah64_radialRight" - inputAction "fza_ah64_radialLeft";
private _sy = inputAction "fza_ah64_radialUp" - inputAction "fza_ah64_radialDown";
if !(finite _sx && {finite _sy}) then {_sx = 0; _sy = 0};
private _mag = sqrt (_sx * _sx + _sy * _sy);
private _latch = _display getVariable ["fza_radialStickLatch", false];
if (_latch && {_mag < RADIAL_STICK_OFF}) then {_latch = false};

(_display getVariable ["fza_radialDwell", [RADIAL_NONE, 0, 0]]) params ["_dwellIdx", "_dwellStart"];
private _hover = _mouseHover;
private _progress = 0;
if (_mag >= RADIAL_STICK_ON) then {
    _hover = [_sx atan2 _sy] call _find;
    private _item = _items param [_hover, []];
    if (_latch || {_item isEqualTo []} || {!(_item # 3)}) then {
        _dwellIdx = RADIAL_NONE;
    } else {
        if (_hover != _dwellIdx) then {
            _dwellIdx = _hover;
            _dwellStart = diag_tickTime;
        };
        _progress = ((diag_tickTime - _dwellStart) / ((missionNamespace getVariable ["fza_ah64_radialDwellTime", 0.8]) max 0.1)) min 1;
    };
} else {
    _dwellIdx = RADIAL_NONE;
};
_display setVariable ["fza_radialStickLatch", _latch];
_display setVariable ["fza_radialDwell", [_dwellIdx, _dwellStart, _progress]];
_display setVariable ["fza_radialHover", _hover];

// Label colours: green selected, grey unavailable
private _labels = _display getVariable ["fza_radialLabels", []];
{
    private _item = _items param [_forEachIndex, []];
    if (_item isNotEqualTo []) then {
        _x ctrlSetTextColor ([[0.5, 0.5, 0.5, 0.7], [[1, 1, 1, 1], [0.4, 1, 0.4, 1]] select (_item # 4)] select (_item # 3));
    };
} forEach (_labels select [0, RADIAL_LABELS - 2]);

if (_progress >= 1) then {
    _display setVariable ["fza_radialStickLatch", true];
    [_display, _dwellIdx] call fza_fnc_radialSelect;
};
