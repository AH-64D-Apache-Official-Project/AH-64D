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
params ["_heli","_munition","_hostile"];

if !(player == driver _heli || player == gunner _heli) exitwith {};

//Detection range
private _distance_m = _heli distance2d _munition;
waitUntil {(distance_m <= ASE_LNC_RANGE_M);};

fza_ah64_aseAudioPlaying = true;
private _missile = nearestobject [_hostile,_munition];
private _posHeli = getpos _heli;
private _posInc = getpos _missile;
private _highLow = ["High", "Low"] select (_posHeli select 2 > _posInc select 2);

private _theta = [_heli, (getpos _heli select 0), (getpos _heli select 1), (_posInc select 0), (_posInc select 1)] call fza_fnc_relativeDirection;
private _clock = [_theta] call fza_fnc_bearingClock;
private _dirAud = format ["fza_ah64_bt_%1oclock", _clock];

//Audio
private _VertAud = "fza_ah64_bt_";// + _highLow;
["fza_ah64_bt_missile", 0.65, _dirAud, 1.3, _VertAud, 0.62] call fza_fnc_playAudio;
sleep 3;
fza_ah64_aseAudioPlaying = false;