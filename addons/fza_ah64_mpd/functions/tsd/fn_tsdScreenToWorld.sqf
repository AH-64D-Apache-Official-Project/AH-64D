/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_tsdScreenToWorld

Description:
    The place under an MPD position on a map drawn from a frame, the inverse
    of fza_mpd_fnc_tsdWorldToScreen.

Parameters:
    _framePos     - The place drawn at the centre
    _frameHeading - The heading up the map
    _scale        - MPD units per metre (fza_mpd_fnc_tsdScale)
    _ctr          - The centre, [x, y] in MPD units
    _screen       - The MPD position, [x, y]

Returns:
    The place, [x, y, 0]

Examples:
    --- Code
    [_framePos, _frameHeading, _scale, [0.5, 0.75], [_posX, _posY]] call fza_mpd_fnc_tsdScreenToWorld
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_framePos", "_frameHeading", "_scale", "_ctr", "_screen"];

private _dx = (_screen # 0) - (_ctr # 0);
private _dy = (_ctr # 1) - (_screen # 1);
private _pos = _framePos getPos [sqrt (_dx ^ 2 + _dy ^ 2) / _scale, _frameHeading + (_dx atan2 _dy)];
[_pos # 0, _pos # 1, 0]
