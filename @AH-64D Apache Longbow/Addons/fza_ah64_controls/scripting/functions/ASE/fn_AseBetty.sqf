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
	_this call fza_fnc_asebetty;
	
Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli","_munition","_hostile"];
////stop one of the double event handler Beg
_Counter = _hostile getVariable ["fza_ah64_shotCounter", 0];
_hostile setVariable ["fza_ah64_shotCounter", (_Counter + 1) % 2];
if (_Counter % 2 == 1) exitWith {};
////stop one of the double event handler End

if !(player == driver _heli || player == gunner _heli) exitwith {};
if (!(_munition isKindOf "missileBase") || !(isengineon _heli || (alive _heli))) exitwith {};

fza_ah64_Incomingaudio = true;
_theta = 0;
_missile = nearestobject [_hostile,_munition];
_posHeli = getpos _heli;
_posInc = getpos _missile;
_range = _posInc distance _posHeli;
_highLow = "High";
_dir = 12;
_dirAud = "fza_ah64_bt_12oclock";
waitUntil {(_posInc distance _posHeli < 6000)};

if (_posHeli select 2 > _posInc select 2) then
{
	_highLow = "Low";
};

_theta = [_heli, (getpos _heli select 0), (getpos _heli select 1), (_posInc select 0), (_posInc select 1)] call fza_fnc_relativeDirection;
_clock = [_theta] call fza_fnc_bearingClock;
_dirAud = format ["fza_ah64_bt_%1oclock", _clock];

//Audio and Text Warning
_heli vehiclechat format ["Missile %1 OClock %2 %3 Meters",_clock,_highLow,_range];
_VertAud = "fza_ah64_bt_" + _highLow;
["fza_ah64_bt_missile", 0.65, _dirAud, 1.3, _VertAud, 0.62] spawn fza_fnc_playAudio;

fza_ah64_Incomingaudio = true;
sleep 3;
fza_ah64_Incomingaudio = false;