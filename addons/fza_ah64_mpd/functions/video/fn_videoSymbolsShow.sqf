/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_videoSymbolsShow

Description:
    Shows the VIDEO page's world referenced symbols (fza_mpd_fnc_videoSymbols)
    in its display: the icons as pictures in its icon group, the TPM lines left
    for its line canvas (fza_mpd_fnc_videoLinesDraw). Native, so they are drawn
    in the same frame as the video under them.

Parameters:
    _display - The VIDEO page's display (RscFzaMPDVideo)
    _symbols - fza_mpd_fnc_videoSymbols's [icons, lines], or [] for none

Returns:
    Nothing

Examples:
    --- Code
    [_display, [_heli, _target, _view, _symbology] call fza_mpd_fnc_videoSymbols] call fza_mpd_fnc_videoSymbolsShow
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_mpd\headers\mfdConstants.h"
disableSerialization;
params ["_display", "_symbols"];
_symbols params [["_icons", []], ["_lines", []]];

private _group = _display displayCtrl 385;
if (isNull _group) exitWith {};
_display setVariable ["fza_mpd_videoLines", _lines];

// Format units to the display: 480 units to its height, centred and raised
private _ctrls = _group getVariable ["fza_mpd_videoIcons", []];
{
    _x params ["_texture", "_fx", "_fy", "_units"];
    private _ctrl = _ctrls param [_forEachIndex, controlNull];
    if (isNull _ctrl) then {
        _ctrl = _display ctrlCreate ["RscPicture", -1, _group];
        _ctrl ctrlSetTextColor [0.1, 1, 0, 1];
        _ctrls set [_forEachIndex, _ctrl];
    };
    if (ctrlText _ctrl != _texture) then {_ctrl ctrlSetText _texture};
    private _size = _units / 480;
    _ctrl ctrlSetPosition [0.5 + (_fx - 320) / 480 - _size / 2, 0.5 + (_fy - 240 - MPD_VIDEO_RAISE) / 480 - _size / 2, _size, _size];
    _ctrl ctrlCommit 0;
    if !(ctrlShown _ctrl) then {_ctrl ctrlShow true};
} forEach _icons;
for "_i" from count _icons to count _ctrls - 1 do {
    private _ctrl = _ctrls # _i;
    if (ctrlShown _ctrl) then {_ctrl ctrlShow false};
};
_group setVariable ["fza_mpd_videoIcons", _ctrls];
