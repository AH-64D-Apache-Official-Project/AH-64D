/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_tadsSlew

Description:
    Slews the TADS from the aim input outside the heads down sight: its picture
    on the CPG's HDU or on an MPD. In first person the game slews the turret at
    the rate of the player's own view, far too fast against a magnified
    picture, so the input is scaled by the TADS field of view instead. Without
    input the commanded line of sight is held, not re-read from the turret.

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

// Commanded from where the TADS points now while slewing, so the command never runs ahead of the turret and stops with
// the input. Held without input: re-reading the turret each frame and re-aiming from the sight's position walks the
// line of sight away. Taken from the turret again after anything else has moved it.
private _az = _heli getVariable ["fza_ah64_tadsAzimuth", 0];
private _el = _heli getVariable ["fza_ah64_tadsElevation", 0];
private _hold = _heli getVariable ["fza_ihadss_tadsSlewHold", []];

// 60 deg/s at full input and unity field of view
private _fov = fza_ah64_tadsFOVs select (_heli getVariable ["fza_ihadss_tadsOpticsMode", _heli getTurretOpticsMode [0]]);
private _rate = 60 * _fov / (fza_ah64_tadsFOVs # 0) * _deltaTime;
// The aim input moves the head in free look, the cockpit cursor while it is detached, and the radial menu while open
if (freeLook || {uiNamespace getVariable ["fza_radialOpen", false]} || {(cameraView == "INTERNAL" && {((missionNamespace getVariable ["hct_interaction_trackIR_interaction_cursor", false]) && {!fza_ah64_tadsIgnoreHatchetCursor}) || {uiNamespace getVariable ["hct_interaction_mouseBlocker", false]}})}) then {_rate = 0};

private _inAz = inputAction "AimRight" - inputAction "AimLeft";
private _inEl = inputAction "AimUp" - inputAction "AimDown";
if (abs _inAz < 0.01) then {_inAz = 0};
if (abs _inEl < 0.01) then {_inEl = 0};
if (_rate == 0) then {_inAz = 0; _inEl = 0};

// Moved off the hold by something else (slave, LMC, the TADS as an NVS sensor): over half the view's half height away
private _offHold = 0.5 * atan (_fov * 0.75);
if (_inAz == 0 && {_inEl == 0} && {_hold isNotEqualTo []} && {time - (_hold # 0) < 0.2}
    && {abs ((_hold # 1) - _az) < _offHold} && {abs ((_hold # 2) - _el) < _offHold}) then {
    _az = _hold # 1;
    _el = _hold # 2;
} else {
    _az = ((_az + _inAz * _rate) max -120) min 120;
    _el = ((_el + _inEl * _rate) max -60) min 30;
};
_heli setVariable ["fza_ihadss_tadsSlewHold", [time, _az, _el]];

private _tadsPos = _heli modelToWorldVisualWorld (_heli selectionPosition "laserEnd");
_tadsPos vectorAdd (_heli vectorModelToWorldVisual ([5000, _az, _el] call CBA_fnc_polar2vect))
