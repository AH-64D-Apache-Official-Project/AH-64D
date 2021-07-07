/* ----------------------------------------------------------------------------
Function: fza_fnc_aseBetty

Description:
    Audio & text warning of direction of incoming missile

Parameters:
    _Heli - The helicopter that fired it
    _munition - Missile
    _Hostile - is it hostile
	
Returns:
	Nothing
	
Examples:
	_this call fza_fnc_asebetty;
	
Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_Heli","_munition","_Hostile"];
////stop one of the double event handler Beg
_Counter = _Hostile getVariable ["fza_ah64_shotCounter", 0];
_Hostile setVariable ["fza_ah64_shotCounter", (_Counter + 1) % 2];
if (_Counter % 2 == 1) exitWith {};
////stop one of the double event handler End

if !(player == driver _Heli || player == gunner _Heli) exitwith {};
if (!(_munition isKindOf "missileBase") || !(isengineon _Heli || (alive _Heli))) exitwith {};

_Theta = 0;
_Missile = nearestobject [_Hostile,_munition];
_PosHeli = getpos _Heli;
_PosInc = getpos _Missile;
_Range = _PosInc distance _PosHeli;
_HighLow = "High";
_Dir = 12;
_DirAud = "fza_ah64_bt_12oclock";
waitUntil {(_PosInc distance _PosHeli < 6000)};

if (_PosHeli select 2 > _PosInc select 2) then
{
	_HighLow = "Low";
};

_Theta = [_Heli, (getpos _Heli select 0), (getpos _Heli select 1), (_PosInc select 0), (_PosInc select 1)] call fza_fnc_relativeDirection;
if (_Theta > 15 && _Theta < 46) then {
	_Dir = 1;
	_DirAud = "fza_ah64_bt_1oclock";
};

if (_Theta > 45 && _Theta < 76) then {
	_Dir = 2;
	_DirAud = "fza_ah64_bt_2oclock";
};

if (_Theta > 75 && _Theta < 106) then {
	_Dir = 3;
	_DirAud = "fza_ah64_bt_3oclock";
};

if (_Theta > 105 && _Theta < 136) then {
	_Dir = 4;
	_DirAud = "fza_ah64_bt_4oclock";
};

if (_Theta > 135 && _Theta < 166) then {
	_Dir = 5;
	_DirAud = "fza_ah64_bt_5oclock";
};

if (_Theta > 165 && _Theta < 196) then {
	_Dir = 6;
	_DirAud = "fza_ah64_bt_6oclock";
};

if (_Theta > 195 && _Theta < 226) then {
	_Dir = 7;
	_DirAud = "fza_ah64_bt_7oclock";
};

if (_Theta > 225 && _Theta < 256) then {
	_Dir = 8;
	_DirAud = "fza_ah64_bt_8oclock";
};

if (_Theta > 255 && _Theta < 286) then {
	_Dir = 9;
	_DirAud = "fza_ah64_bt_9oclock";
};

if (_Theta > 285 && _Theta < 316) then {
	_Dir = 10;
	_DirAud = "fza_ah64_bt_10oclock";
};

if (_Theta > 315 && _Theta < 346) then {
	_Dir = 11; 
	_DirAud = "fza_ah64_bt_11oclock";
};

//Audio and Text Warning
_Heli vehiclechat format ["Missile %1 OClock %2 %3 Meters",_Dir,_HighLow,_Range];
_VertAud = "fza_ah64_bt_" + _HighLow;
["fza_ah64_bt_Missile", 0.65, _DirAud, 1.3, _VertAud, 0.62] spawn fza_fnc_playAudio;