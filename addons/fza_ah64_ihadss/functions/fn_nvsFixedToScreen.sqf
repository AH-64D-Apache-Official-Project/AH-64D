/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_nvsFixedToScreen

Description:
    Where a point is in the NVS MODE FIXED picture, on screen: its direction
    in the fixed LOS's frame turned into the camera's, as the picture is drawn
    conformally about the middle of the view (fza_ihadss_fnc_nvsFixedView).
    With no fixed view, where it is in the world.

Parameters:
    _view - fza_ihadss_fnc_nvsFixedView's view, or []
    _pos  - The point (ASL)

Returns:
    Screen position, or [] if it is behind

Examples:
    --- Code
    [_fixedView, _posASL] call fza_ihadss_fnc_nvsFixedToScreen
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_view", "_pos"];

if (_view isEqualTo []) exitWith {worldToScreen ASLToAGL _pos};
_view params ["_eye", "_los", "_cam"];

private _dir = _pos vectorDiff _eye;
private _fwd = _dir vectorDotProduct (_los # 0);
if (_fwd <= 0) exitWith {[]};
private _seen = _eye
    vectorAdd ((_cam # 0) vectorMultiply _fwd)
    vectorAdd ((_cam # 1) vectorMultiply (_dir vectorDotProduct (_los # 1)))
    vectorAdd ((_cam # 2) vectorMultiply (_dir vectorDotProduct (_los # 2)));
worldToScreen ASLToAGL _seen
