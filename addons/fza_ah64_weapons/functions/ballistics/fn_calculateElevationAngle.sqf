/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_calculateElevationAngle

Description:
    Finds the absolute launch elevation angle (radians) needed to achieve the
    given horizontal ground range, using bisection (binary) search.

    Range increases monotonically with elevation angle below ~45°, so binary
    search is valid over the cannon's operational window.  16 iterations give
    sub-arc-second precision — far below weapon dispersion.

Parameters:
    _platformFwdSpeed  - Forward speed of launch platform (m/s).
    _platformAlt       - Launch altitude above terrain (m).
    _targetRange       - Desired horizontal range to target (m).
    _muzzleVelocity    - Muzzle velocity relative to platform (m/s).
    _airFriction       - ArmA airFriction value (negative, from CfgAmmo).
    _elevMin           - Minimum absolute elevation to search (radians).
    _elevMax           - Maximum absolute elevation to search (radians).

Returns:
    Best-fit absolute elevation angle in radians.

Author:
    fza_ah64 ballistics system
---------------------------------------------------------------------------- */
params ["_platformFwdSpeed", "_platformAlt", "_targetRange", "_muzzleVelocity", "_airFriction", "_elevMin", "_elevMax"];

private _lo = _elevMin;
private _hi = _elevMax;

for "_i" from 0 to 15 do {
    private _mid   = (_lo + _hi) * 0.5;
    private _range = [_platformFwdSpeed, _platformAlt, _mid, _muzzleVelocity, _airFriction] call fza_weapons_fnc_calculateRange;
    if (_range < _targetRange) then { _lo = _mid } else { _hi = _mid };
};

(_lo + _hi) * 0.5
