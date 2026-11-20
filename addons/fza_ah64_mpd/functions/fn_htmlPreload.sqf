/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_htmlPreload

Description:
    Loads the HTML pages marked htmlPreload in FzaMpdPages before they are first
    shown, so the browser has the page ready when the MPD switches to it. Each
    MPD's native display gets a near invisible picture of the page's texture
    (fza_mpd_fnc_htmlTexture), which creates the page's display and keeps it
    alive; the same texture on the screen then reuses it.

Parameters:
    _heli - The helicopter

Returns:
    True once both MPDs' native displays have them, false to be called again

Examples:
    --- Code
    [_heli] call fza_mpd_fnc_htmlPreload
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
disableSerialization;
params ["_heli"];

private _classes = ("getNumber (_x >> 'htmlPreload') == 1 && {isText (_x >> 'htmlClass')}" configClasses (configOf _heli >> "FzaMpdPages")) apply {getText (_x >> "htmlClass")};
if (_classes isEqualTo []) exitWith {true};

private _displays = uiNamespace getVariable ["fza_mpd_display", createHashMap];
private _done = true;
{
    private _side = _forEachIndex;
    private _display = _displays getOrDefault [_x, displayNull];
    if (isNull _display) then {_done = false; continue};
    private _loaded = _display getVariable ["fza_mpd_htmlPreloaded", []];
    private _added = false;
    {
        ([_side, _x] call fza_mpd_fnc_htmlTexture) params ["_texture"];
        if (_texture in _loaded) then {continue};
        private _ctrl = _display ctrlCreate ["RscPicture", -1];
        _ctrl ctrlSetPosition [0, 0, 0.001, 0.001];
        _ctrl ctrlSetTextColor [1, 1, 1, 0.01];
        _ctrl ctrlSetText _texture;
        _ctrl ctrlCommit 0;
        _loaded pushBack _texture;
        _added = true;
    } forEach _classes;
    if (_added) then {
        _display setVariable ["fza_mpd_htmlPreloaded", _loaded];
        displayUpdate _display;
    };
} forEach ["left", "right"];
_done
