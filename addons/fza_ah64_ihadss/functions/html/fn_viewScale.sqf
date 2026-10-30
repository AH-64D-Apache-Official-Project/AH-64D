/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_viewScale

Description:
    The projection of the player's view, measured from worldToScreen rather
    than assumed: the half height tangent per unit of FOV. A camera of any
    FOV, render targets included, covers a half height tangent of FOV * the
    scale.

    Measured once and then fixed, as the heads up format is sized from it and
    its browser reopens at a new size (fza_ihadss_fnc_htmlDraw). Measured
    again only when the resolution or the profile FOV changes. Only the
    measuring caller, the controller in the player's own Draw3D pass, takes
    readings: elsewhere (EachFrame, a render target's pass) the camera and the
    projection disagree. The median of several readings is kept.

Parameters:
    _heli    - The helicopter
    _measure - True to take a reading this frame (default: false)

Returns:
    [half height tangent per unit FOV, settled]. Until measured the scale is
    the profile's top FOV; settled once measured, or after 3 s of measuring
    without a result.

Examples:
    --- Code
    ([_heli] call fza_ihadss_fnc_viewScale) params ["_scale", "_settled"];
    ---

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli", ["_measure", false]];

private _key = [getResolution, typeOf _heli];
(missionNamespace getVariable ["fza_ihadss_viewScale", [[], 0, [], -1]]) params ["_scaleKey", "_scale", "_readings", "_since"];
if (_scaleKey isNotEqualTo _key) then {
    _scale    = 0;
    _readings = [];
    _since    = -1;
    missionNamespace setVariable ["fza_ihadss_viewScale", [_key, _scale, _readings, _since]];
};
if (_scale > 0) exitWith {[_scale, true]};

if (_measure && {cameraView == "INTERNAL"}) then {
    if (_since < 0) then {
        _since = diag_tickTime;
        missionNamespace setVariable ["fza_ihadss_viewScale", [_key, _scale, _readings, _since]];
    };
    private _fov = getObjectFOV player;
    // Only with the FOV steady: while it animates (zooming) the drawn view and the FOV read disagree
    (missionNamespace getVariable ["fza_ihadss_viewFov", [-1, -1]]) params ["_lastFov", "_fovSince"];
    if (_lastFov <= 0 || {abs (_fov / _lastFov - 1) > 0.005}) then {
        _fovSince = diag_tickTime;
        missionNamespace setVariable ["fza_ihadss_viewFov", [_fov, _fovSince]];
    };
    if (_fov > 0 && {diag_tickTime - _fovSince > 0.5}) then {
        // A point 0.1 tangent above the camera axis; the screen spans safeZoneH over twice the half height tangent. The
        // camera axis lands on the screen centre only when the camera and the projection are the same view's.
        private _centre = worldToScreen positionCameraToWorld [0, 0, 1];
        private _above  = worldToScreen positionCameraToWorld [0, 0.1, 1];
        if (_centre isNotEqualTo [] && {_above isNotEqualTo []
            && {abs ((_centre # 0) - 0.5) < 0.005 && {abs ((_centre # 1) - 0.5) < 0.005 && {(_centre # 1) > (_above # 1)}}}}) then {
            _readings pushBack ((safeZoneH / 2) / (((_centre # 1) - (_above # 1)) / 0.1) / _fov);
        };
    };
    if (count _readings >= 9) then {
        _readings sort true;
        _scale = _readings # 4;
        missionNamespace setVariable ["fza_ihadss_viewScale", [_key, _scale, [], _since]];
    };
};
if (_scale > 0) exitWith {[_scale, true]};
[getResolution param [6, 0.75], _since >= 0 && {diag_tickTime - _since > 3}]
