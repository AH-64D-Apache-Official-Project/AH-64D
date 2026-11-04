/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_tsdScale

Description:
    The TSD map's scale on that MPD: MPD units per metre, at the selected map
    scale, 20 percent larger with ZOOM.

Parameters:
    _tsd - The TSD's persistent state on that MPD

Returns:
    MPD units per metre

Examples:
    --- Code
    private _scale = [_persistState] call fza_mpd_fnc_tsdScale;
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_tsd"];

0.125 * 5 / (_tsd get "tsdScale") * ([1, 1.2] select (_tsd getOrDefault ["zoom", 0] == 1))
