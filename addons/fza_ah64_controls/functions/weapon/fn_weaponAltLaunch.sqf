/* ----------------------------------------------------------------------------
Function: fza_fnc_weaponAltLaunch

Description:
    ALT LAUNCH, a gun inhibit: the player's trigger pressed within 2 s of a
    rocket volley or missile launch, until those 2 s are up. Only a press
    after the launch counts.

Parameters:
    _heli - The helicopter

Returns:
    True while ALT LAUNCH applies

Examples:
    --- Code
    [_heli] call fza_fnc_weaponAltLaunch
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

private _lastLaunch = (_heli getVariable ["fza_ah64_mslLaunchAt", -1e6]) max (_heli getVariable ["fza_ah64_rocketLaunchAt", -1e6]);
CBA_missionTime - _lastLaunch < 2 && {(missionNamespace getVariable ["fza_ah64_triggerPressedAt", -1e6]) > _lastLaunch}
