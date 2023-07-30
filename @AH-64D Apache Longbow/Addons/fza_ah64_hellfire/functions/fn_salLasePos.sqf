/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_salLasePos

Description:
    Fetches the laser position of the currently detected primary laser code

Parameters:
    _heli - The object who is seeking

Returns:
    ASL Position of the laser, or nil

Examples:
    --- Code
    [_heli] call fza_hellfire_fnc_salShouldStartLobl
    ---

---------------------------------------------------------------------------- */
params ["_heli"];
private _index = _heli getVariable "fza_ah64_laserMissilePrimaryCode";

if (_index == -1) exitWith {false};

private _channels = _heli getVariable "fza_ah64_laserChannelCodes";
private _hash = _heli getVariable "fza_ah64_laserChannelIndex";
private _laserCode = _hash get _channels # _index;

private _ammotype = getText (configFile >> "CfgWeapons" >> _heli getVariable "fza_ah64_selectedMissile" >> "fza_ammoType");
private _seekerConfig = configFile >> "CfgAmmo" >> _ammotype >> "ace_missileguidance";
private _seekerAngle = getNumber (_seekerConfig >> "seekerAngle");
private _seekerMaxRange = getNumber (_seekerConfig >> "seekerMaxRange");
([getPosASL _heli + [0,0,0.6], vectorDir _heli, _seekerAngle, _seekerMaxRange, [ACE_DEFAULT_LASER_WAVELENGTH, ACE_DEFAULT_LASER_WAVELENGTH], _laserCode, _heli] call ace_laser_fnc_seekerFindLaserSpot) params ["_laserPos"];
_laserPos;
