/* ----------------------------------------------------------------------------
Function: fza_fnc_aseBetty

Description:
    Audio & text warning of direction of incoming missile

Parameters:
    _heli - The helicopter that fired it
    _munition - Missile
    _hostile - is it hostile
	
Returns:
	Nothing
	
Examples:
	_this spawn fza_fnc_asebetty;
	
Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli","_munition","_hostile"];

if !(player == driver _heli || player == gunner _heli) exitwith {};
if (!(_munition isKindOf "missileBase") || !(isengineon _heli || (alive _heli))) exitwith {};

fza_ah64_incomingAudio = true;
private _missile = nearestobject [_hostile,_munition];
private _posHeli = getpos _heli;
private _posInc = getpos _missile;
private _range = _posInc distance _posHeli;
waitUntil {_posInc distance _posHeli < 6000};

//private _highLow = ["High", "Low"] select (_posHeli select 2 > _posInc select 2);

private _theta = [_heli, (getpos _heli select 0), (getpos _heli select 1), (_posInc select 0), (_posInc select 1)] call fza_fnc_relativeDirection;
private _clock = [_theta] call fza_fnc_bearingClock;
private _dirAud = format ["fza_ah64_bt_%1oclock", _clock];

//Audio and Text Warning
//_heli vehiclechat format ["Missile %1 OClock %2 %3 Meters",_clock,_highLow,_range];
private _VertAud = "fza_ah64_bt_";// + _highLow;
["fza_ah64_bt_missile", 0.65, _dirAud, 1.3, _VertAud, 0.62] call fza_fnc_playAudio;
fza_ah64_incomingAudio = false;