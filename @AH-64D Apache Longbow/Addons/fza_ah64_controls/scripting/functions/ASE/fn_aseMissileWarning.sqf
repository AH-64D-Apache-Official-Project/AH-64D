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

private _missile = nearestobject [_hostile,_munition];
private _posHeli = getpos _heli;
private _posInc = getpos _missile;

//Detection range
waitUntil {(_heli distance _missile <= ASE_LNC_RANGE_M);};
hint "Warning missile";

private _theta = [_heli, (getpos _heli select 0), (getpos _heli select 1), (_posInc select 0), (_posInc select 1)] call fza_fnc_relativeDirection;
private _clock = [_theta] call fza_fnc_bearingClock;
private _dirAud = format ["fza_ah64_bt_%1oclock", _clock];

//Audio
["fza_ah64_launch", 0.65, "fza_ah64_launch", 0.65, _dirAud, 1.3] spawn fza_fnc_playAudio;

private _future = time + 3;
while {(time >= _future)} do {
    fza_ah64_aseAudioPlaying = true;
};
fza_ah64_aseAudioPlaying = false;