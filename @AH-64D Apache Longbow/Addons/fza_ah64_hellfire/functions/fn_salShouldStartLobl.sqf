/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_salShouldStartLobl

Description:
    Defines whether a SAL missile should start in LOBL
    (can see valid laser energy)

Parameters:
    _heli - The object who is seeking

Returns:
    startLobl

Examples:
    --- Code
    [_heli] call fza_hellfire_fnc_salShouldStartLobl
    ---

---------------------------------------------------------------------------- */
params ["_heli"];
_index = _heli getVariable "fza_ah64_laserMissilePrimaryCode";

if (_index == -1) exitWith {false};

private _channels = _heli getVariable "fza_ah64_laserChannelCodes";
private _hash = _heli getVariable "fza_ah64_laserChannelIndex";
private _laserCode = _hash get _channels # _index;

private _ammotype = _heli getVariable "fza_ah64_selectedMissile";
private _seekerConfig = configFile >> "CfgAmmo" >> _ammotype >> "ace_missileguidance";
private _seekerAngle = getNumber (_seekerConfig >> "seekerAngle");
private _seekerMaxRange = getNumber (_seekerConfig >> "seekerMaxRange");
([getPosASL _heli, vectorDir _heli, _seekerAngle, _seekerMaxRange, [ACE_DEFAULT_LASER_WAVELENGTH, ACE_DEFAULT_LASER_WAVELENGTH], _laserCode, _heli] call ace_laser_fnc_seekerFindLaserSpot) params ["_laserPos"];
!isNil "_laserPos";
