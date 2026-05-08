/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_salFindLaserDesignation
Description: Returns the ASL position of a laser spot on the primary missile
    channel, or nil if none is visible.
Parameters: _heli - The helicopter
Returns: ASL position, or nil
Author: Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

private _index = _heli getVariable "fza_ah64_laserMissilePrimaryCode";

if (_index == -1) exitWith { nil };

private _channels   = _heli getVariable "fza_ah64_laserChannelCodes";
private _hash       = _heli getVariable "fza_ah64_laserChannelIndex";
private _laserCode  = _hash get (_channels # _index);

private _ammotype      = getText (configFile >> "CfgWeapons" >> (_heli getVariable "fza_ah64_selectedMissile") >> "fza_ammoType");
private _seekerConfig  = configFile >> "CfgAmmo" >> _ammotype >> "ace_missileguidance";
private _seekerAngle   = getNumber (_seekerConfig >> "seekerAngle");
private _seekerMaxRange = getNumber (_seekerConfig >> "seekerMaxRange");

([eyePos _heli, vectorDir _heli, _seekerAngle, _seekerMaxRange, [ACE_DEFAULT_LASER_WAVELENGTH, ACE_DEFAULT_LASER_WAVELENGTH], _laserCode, _heli] call ace_laser_fnc_seekerFindLaserSpot) params ["_laserPos"];
_laserPos
