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
if (_theta > 15 && _theta < 46) then {
	_dir = 1;
	_dirAud = "fza_ah64_bt_1oclock";
};

if (_theta > 45 && _theta < 76) then {
	_dir = 2;
	_dirAud = "fza_ah64_bt_2oclock";
};

if (_theta > 75 && _theta < 106) then {
	_dir = 3;
	_dirAud = "fza_ah64_bt_3oclock";
};

if (_theta > 105 && _theta < 136) then {
	_dir = 4;
	_dirAud = "fza_ah64_bt_4oclock";
};

if (_theta > 135 && _theta < 166) then {
	_dir = 5;
	_dirAud = "fza_ah64_bt_5oclock";
};

if (_theta > 165 && _theta < 196) then {
	_dir = 6;
	_dirAud = "fza_ah64_bt_6oclock";
};

if (_theta > 195 && _theta < 226) then {
	_dir = 7;
	_dirAud = "fza_ah64_bt_7oclock";
};

if (_theta > 225 && _theta < 256) then {
	_dir = 8;
	_dirAud = "fza_ah64_bt_8oclock";
};

if (_theta > 255 && _theta < 286) then {
	_dir = 9;
	_dirAud = "fza_ah64_bt_9oclock";
};

if (_theta > 285 && _theta < 316) then {
	_dir = 10;
	_dirAud = "fza_ah64_bt_10oclock";
};

if (_theta > 315 && _theta < 346) then {
	_dir = 11; 
	_dirAud = "fza_ah64_bt_11oclock";
};

//Audio and Text Warning
_heli vehiclechat format ["Missile %1 OClock %2 %3 Meters",_dir,_highLow,_range];
_VertAud = "fza_ah64_bt_" + _highLow;
["fza_ah64_bt_missile", 0.65, _dirAud, 1.3, _VertAud, 0.62] spawn fza_fnc_playAudio;