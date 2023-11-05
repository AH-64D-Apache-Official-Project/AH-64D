/* ----------------------------------------------------------------------------
Function: fza_laser_fnc_update

Description:
    set ace laser code perframe to match system laser value

Parameters:
    _heli - the helicopter

Returns:
    Nothing

Examples:
    [_heli] call fza_laser_fnc_update;

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

//Laser designator
_channel = _heli getVariable "fza_ah64_laserLRFDCode";
_hash = _heli getVariable "fza_ah64_laserChannelIndex";
_code = _hash get _channel;
_heli setVariable ["ace_laser_code", _code];

private _attackProfile = [_heli] call fza_hellfire_fnc_getattackProfile;
if (_heli getVariable "fza_ah64_selectedMissile" == "fza_agm114l_wep") then {
    _heli setVariable ["ace_missileguidance_attackProfile", "hellfire_hi"];
} else {
    _heli setVariable ["ace_missileguidance_attackProfile", _attackProfile];
};