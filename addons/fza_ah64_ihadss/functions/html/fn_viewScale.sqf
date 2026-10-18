/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_viewScale

Description:
    The projection of the player's view, measured from worldToScreen rather
    than assumed: the tangent of half the view's height, and that tangent per
    unit of FOV. A camera of any FOV, render targets included, covers a half
    height tangent of FOV * the scale.

    Measured once a frame in the first person view. The scale is kept until a
    measurement differs by over 1%, as the heads up format is sized from it and
    its browser reopens at a new size (fza_ihadss_fnc_htmlDraw).

Parameters:
    _heli - The helicopter, for its default FOV when the view's cannot be read

Returns:
    [tangent of half the view height, half height tangent per unit FOV]

Examples:
    --- Code
    ([_heli] call fza_ihadss_fnc_viewScale) params ["_tanHalfV", "_scale"];
    ---

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

(missionNamespace getVariable ["fza_ihadss_viewScale", [-1, 0, 0]]) params ["_frame", "_tanHalfV", "_scale"];
if (_frame == diag_frameNo) exitWith {[_tanHalfV, _scale]};

private _fov = getObjectFOV player;
if (_fov <= 0) then {_fov = getNumber (configOf _heli >> "ViewPilot" >> "initFov")};

if (cameraView == "INTERNAL") then {
    // A point 0.1 tangent above the camera axis; the screen spans safeZoneH over twice the half height tangent
    private _centre = worldToScreen positionCameraToWorld [0, 0, 1];
    private _above  = worldToScreen positionCameraToWorld [0, 0.1, 1];
    if (_centre isNotEqualTo [] && {_above isNotEqualTo [] && {(_centre # 1) > (_above # 1)}}) then {
        _tanHalfV = (safeZoneH / 2) / (((_centre # 1) - (_above # 1)) / 0.1);
        private _measured = _tanHalfV / _fov;
        if (_scale <= 0 || {abs (_measured / _scale - 1) > 0.01}) then {_scale = _measured};
    };
};
// Never measured yet: the profile's top FOV, the previous assumption
if (_scale <= 0) then {_scale = getResolution param [6, 0.75]};
if (_tanHalfV <= 0) then {_tanHalfV = _scale * _fov};

missionNamespace setVariable ["fza_ihadss_viewScale", [diag_frameNo, _tanHalfV, _scale]];
[_tanHalfV, _scale]
