/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_tsdWorldToScreen

Description:
    Where a place is drawn on a map drawn from a frame (fza_mpd_fnc_tsdFrame):
    the frame's position at the centre, its heading up. The inverse of
    fza_mpd_fnc_tsdScreenToWorld.

Parameters:
    _framePos     - The place drawn at the centre
    _frameHeading - The heading up the map
    _scale        - MPD units per metre (fza_mpd_fnc_tsdScale)
    _ctr          - The centre, [x, y] in MPD units
    _pos          - The place

Returns:
    [x, y] in MPD units

Examples:
    --- Code
    [_framePos, _frameHeading, _scale, [0.5, 0.75], _pos] call fza_mpd_fnc_tsdWorldToScreen
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_framePos", "_frameHeading", "_scale", "_ctr", "_pos"];

private _theta = (_framePos getDir _pos) - _frameHeading;
private _r = (_framePos distance2D _pos) * _scale;
[(_ctr # 0) + sin _theta * _r, (_ctr # 1) - cos _theta * _r]
