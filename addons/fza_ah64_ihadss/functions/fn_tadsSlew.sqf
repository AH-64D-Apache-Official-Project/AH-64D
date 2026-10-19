/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_tadsSlew

Description:
    Slews the TADS from the aim input while its picture is on the CPG's HDU.
    In first person the game slews the turret at the rate of the player's own
    view, far too fast against a magnified picture, so the input is scaled by
    the TADS field of view instead.

Parameters:
    _heli - The helicopter

Returns:
    ASL position to lock the TADS camera to

Examples:
    --- Code
    [_heli] call fza_ihadss_fnc_tadsSlew
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

private _deltaTime = ["fza_ihadss_tadsSlew"] call BIS_fnc_deltaTime;

// Commanded from where the TADS points now, so the command never runs ahead of the turret and it stops with the input
private _az = _heli getVariable ["fza_ah64_tadsAzimuth", 0];
private _el = _heli getVariable ["fza_ah64_tadsElevation", 0];

// 60 deg/s at full input and unity field of view
private _fov = fza_ah64_tadsFOVs select (_heli getTurretOpticsMode [0]);
private _rate = 60 * _fov / (fza_ah64_tadsFOVs # 0) * _deltaTime;
// The aim input moves the head in free look, and the cockpit cursor while it is detached
if (freeLook || {(cameraView == "INTERNAL" && {((missionNamespace getVariable ["hct_interaction_trackIR_interaction_cursor", false]) && {!fza_ah64_tadsIgnoreHatchetCursor}) || {uiNamespace getVariable ["hct_interaction_mouseBlocker", false]}})}) then {_rate = 0};

_az = ((_az + (inputAction "AimRight" - inputAction "AimLeft") * _rate) max -120) min 120;
_el = ((_el + (inputAction "AimUp" - inputAction "AimDown") * _rate) max -60) min 30;

private _tadsPos = _heli modelToWorldVisualWorld (_heli selectionPosition "laserEnd");
_tadsPos vectorAdd (_heli vectorModelToWorldVisual ([5000, _az, _el] call CBA_fnc_polar2vect))
