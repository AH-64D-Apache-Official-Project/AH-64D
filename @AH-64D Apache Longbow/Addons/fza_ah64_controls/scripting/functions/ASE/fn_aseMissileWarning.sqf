/* ----------------------------------------------------------------------------
Function: fza_fnc_aseMissileWarning

Description:
    Audio & text warning of direction of incoming missile

Parameters:
    _heli - The helicopter that fired it
    _munition - Missile
    _hostile - is it hostile
	
Returns:
	Nothing
	
Examples:
	_this spawn fza_fnc_aseMissileWarning;
	
Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli","_munition","_hostile"];

if !(player == driver _heli || player == gunner _heli) exitwith {};

private _rlwrPwr     = _heli getVariable "fza_ah64_ase_rlwrPwr";
private _missile = nearestobject [_hostile,_munition];
private _posHeli = getpos _heli;
private _posInc = getpos _missile;

private _seekerhead = getNumber (configFile >> "CfgAmmo" >> typeof _missile >> "weaponLockSystem");
if ([_seekerhead, 8] call BIS_fnc_bitwiseAND != 0 && _rlwrPwr == "on") then {
        
    _Classification = [_hostile] call fza_fnc_aseAdaClassification;
    private _identity = format ["fza_ah64_bt_%1", _Classification];

    //Detection range
    waitUntil {(_heli distance _missile <= ASE_LNC_RANGE_M);};

    private _theta = [_heli, (getpos _heli select 0), (getpos _heli select 1), (_posInc select 0), (_posInc select 1)] call fza_fnc_relativeDirection;
    private _clock = [_theta] call fza_fnc_bearingClock;
    private _dirAud = format ["fza_ah64_bt_%1oclock", _clock];

    //Audio
    [_heli, 9, _hostile, _identity, 1, _dirAud, 1.3, "fza_ah64_launch", 0.65] call fza_fnc_addQueuedAudio;
};