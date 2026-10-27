/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_formatRect

Description:
    Screen rectangle of the 4:3 HDU format, the same in real pixels on any
    screen shape and centred in the safe zone. Heads up it covers 40x30 deg at
    the seat's default FOV and keeps that size while zoomed; heads down it
    fills the safe zone height.

Parameters:
    _heli      - The helicopter
    _headsDown - True for the TADS view

Returns:
    [x, y, w, h] in UI coordinates

Examples:
    --- Code
    private _rect = [_heli, false] call fza_ihadss_fnc_formatRect
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_headsDown"];

private _height = safeZoneH;
if !_headsDown then {
    // 30 deg tall at the seat's default FOV, by the view's measured projection (fza_ihadss_fnc_viewScale)
    private _initFov = getNumber (configOf _heli >> "ViewPilot" >> "initFov");
    if (_initFov <= 0) then {_initFov = 0.75};
    private _scale = ([_heli] call fza_ihadss_fnc_viewScale) # 1;
    _height = ((safeZoneH * (tan 15) / (_scale * _initFov)) max (0.4 * safeZoneH)) min safeZoneH;
};
private _width = _height / pixelH * pixelW * 4 / 3;
if (_width > safeZoneW) then {
    _height = _height * safeZoneW / _width;
    _width  = safeZoneW;
};
[safeZoneX + (safeZoneW - _width) / 2, safeZoneY + (safeZoneH - _height) / 2, _width, _height]
