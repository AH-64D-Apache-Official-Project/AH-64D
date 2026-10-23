/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_nvsFixedView

Description:
    With the crew station's NVS MODE FIXED, its HDU picture is the view fixed
    forward along the aircraft's fixed LOS (NVS_FIXED_EL), wherever the head
    looks. Symbols conformal with that picture rather than the world (the TPM
    C-scope) are placed by fza_ihadss_fnc_nvsFixedToScreen with this frame's
    view: the eye, the fixed LOS's axes and the camera's, all world space.

Parameters:
    _heli - The helicopter

Returns:
    [eye ASL, [LOS forward, right, up], [camera forward, right, up]], or [] when NVS MODE is not FIXED

Examples:
    --- Code
    private _fixedView = [_heli] call fza_ihadss_fnc_nvsFixedView;
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

if ((([_heli] call fza_ihadss_fnc_nvsState) # 0) != NVS_MODE_FIXED) exitWith {[]};

private _eye   = AGLToASL positionCameraToWorld [0, 0, 0];
private _losF  = _heli vectorModelToWorldVisual ([1, 0, NVS_FIXED_EL] call CBA_fnc_polar2vect);
private _losR  = _heli vectorModelToWorldVisual [1, 0, 0];
[
    _eye,
    [_losF, _losR, _losR vectorCrossProduct _losF],
    [[0, 0, 1], [1, 0, 0], [0, 1, 0]] apply {(AGLToASL positionCameraToWorld _x) vectorDiff _eye}
]
