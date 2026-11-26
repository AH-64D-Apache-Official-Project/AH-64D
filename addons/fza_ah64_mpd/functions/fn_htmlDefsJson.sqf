/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_htmlDefsJson

Description:
    The ident definitions fza_mpd_fnc_htmlPoints has kept on an HTML page's browser control, as the JSON its point
    layer takes ({ident: [texture, texture 2, size, colour, place A, place B]}), built again only when they grew.

Parameters:
    _ctrl - The page's browser control (fza_mpd_fnc_htmlCtrl)

Returns:
    JSON text

Examples:
    --- Code
    [_ctrl, "fzaASE.defs", [_ctrl] call fza_mpd_fnc_htmlDefsJson, "d"] call fza_mpd_fnc_htmlPush
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
disableSerialization;
params ["_ctrl"];

if (_ctrl getVariable ["fza_mpd_htmlDefsGrew", false] || {isNil {_ctrl getVariable "fza_mpd_htmlDefsJson"}}) then {
    private _out = createHashMap;
    {
        if (_y isNotEqualTo []) then {_out set [_x, _y select [0, 6]]};
    } forEach (_ctrl getVariable ["fza_mpd_htmlDefs", createHashMap]);
    _ctrl setVariable ["fza_mpd_htmlDefsJson", toJSON _out];
    _ctrl setVariable ["fza_mpd_htmlDefsGrew", false];
};
_ctrl getVariable ["fza_mpd_htmlDefsJson", "{}"]
