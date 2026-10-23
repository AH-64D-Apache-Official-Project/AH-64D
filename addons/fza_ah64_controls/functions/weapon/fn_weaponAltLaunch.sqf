/* ----------------------------------------------------------------------------
Function: fza_fnc_weaponAltLaunch

Description:
    ALT LAUNCH, a gun inhibit: a crew station's trigger pressed within 2 s of
    a rocket volley or missile launch, until those 2 s are up. Only a press
    after the launch counts.

Parameters:
    _heli - The helicopter
    _seat - (optional, default the player's) The crew station, "plt" or "cpg"

Returns:
    True while ALT LAUNCH applies

Examples:
    --- Code
    [_heli] call fza_fnc_weaponAltLaunch
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", ["_seat", ""]];

if (_seat == "") then {_seat = [_heli] call fza_fnc_getSeat};
if (isNil "_seat") exitWith {false};
private _lastLaunch = (_heli getVariable ["fza_ah64_mslLaunchAt", -1e6]) max (_heli getVariable ["fza_ah64_rocketLaunchAt", -1e6]);
CBA_missionTime - _lastLaunch < 2 && {((_heli getVariable ["fza_ah64_trigger_" + _seat, [-1e6, -1]]) # 0) > _lastLaunch}
