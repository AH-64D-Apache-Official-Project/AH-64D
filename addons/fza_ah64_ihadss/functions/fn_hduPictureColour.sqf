/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_hduPictureColour

Description:
    The colour of the local crew station's HDU picture from its video
    controls. The picture is blended over the outside view, so IHADSS BRT
    scales its green and IHADSS CON how strongly it shows against the outside.
    With ACM off, FLIR LVL and FLIR GAIN do the same to a FLIR picture,
    nominal at mid travel.

Parameters:
    _heli - The helicopter
    _flir - The picture is FLIR

Returns:
    [r, g, b, a]

Examples:
    --- Code
    [_heli, true] call fza_ihadss_fnc_hduPictureColour
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_flir"];

([_heli] call fza_ihadss_fnc_videoPanel) params ["_brt", "_con", "", "_lvl", "_gain", "_acm"];
private _green = _brt;
private _alpha = HDU_PICTURE_ALPHA_MAX * _con;
if (_flir && {_acm == 0}) then {
    _green = (_green * (0.5 + _lvl)) min 1;
    _alpha = (_alpha * (0.5 + _gain)) min 1;
};
[0.1 * _green, _green, 0, _alpha]
