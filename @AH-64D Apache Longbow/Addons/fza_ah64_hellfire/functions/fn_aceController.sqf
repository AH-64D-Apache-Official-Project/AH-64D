/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_aceController

Description:
    Used to configure ace missile guidance elements to constantly align with Sal Missile variables

Parameters:
    _heli - the helicopter

Returns:
    Nothing

Examples:
    [_heli] call fza_hellfire_fnc_aceController;

Author:
    Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

//Laser designator
_channel = _heli getVariable "fza_ah64_laserLRFDCode";
_hash = _heli getVariable "fza_ah64_laserChannelIndex";
_code = _hash get _channel;
_heli setVariable ["ace_laser_code", _code];

//attackprofile
private _attackProfile = [_heli] call fza_hellfire_fnc_getattackProfile;
if (_heli getVariable "fza_ah64_selectedMissile" == "fza_agm114l_wep") then {
    _heli setVariable ["ace_missileguidance_attackProfile", "hellfire_hi"];
} else {
    _heli setVariable ["ace_missileguidance_attackProfile", _attackProfile];
};