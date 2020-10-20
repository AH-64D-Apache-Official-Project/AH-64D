_array = _this;
_ac = _this select 0;
_munition = _this select 1;
_hostile = _this select 2;
_highlow = "Low";
_theta = 0;
_clockaud = "fza_ah64_bt_12oclock";
_localasemisarray = [];
_usesound = false;
_mistheta = 0;

if(player == driver _ac || player == gunner _ac) then {_usesound = true;};

if(!(_munition isKindOf "missileBase") || !(isengineon _ac)) exitwith {};

if(local _ac && !(player == driver _ac) || !(player == gunner _ac)) then
{
	_missile = nearestobject [_hostile,_munition];

	_posac = getpos _ac;
	_poshostile = getpos _missile;
	_range = _poshostile distance _posac;
	_highlow = "High";
	_chance1 = 200;
	_rand = 6;

	if(typeof _missile in fza_ah64_mis_ir) then {_rand = 7;};
	if(typeof _missile in fza_ah64_mis_rf) then {_rand = 4;};
	if (floor random 10 < _rand) exitwith {};
	waitUntil {_missile distance _ac < 200};	
	while {(alive _missile) && (alive _ac)} do
	{
		_reldir = ((getposasl _ac select 0) - (getposasl _missile select 0)) atan2 ((getposasl _ac select 1) - (getposasl _missile select 1));
		if (_reldir < 0) then
		{
			_reldir = _reldir + 360;
		};
		_mistheta = (360 + (_reldir - (direction _missile))) Mod 360;
		_missile setdir (_mistheta - (random _chance1));
		_pbvar = _missile call fza_ah64_getpb;
		_pitch = _pbvar select 0;
		_bank = _pbvar select 1;
		_bank = _bank - (random _chance1);
		_pitch = _pitch - (random _chance1);
		[_missile, _pitch, _bank] call fza_ah64_setpb;
		sleep 0.1;
	};
};

if (!(isNil "fza_ah64_noscripts") || !(isengineon _ac) || !(alive _ac) || !(_munition isKindOf "MissileBase") || !(player in _ac)) exitwith {};

_missile = nearestobject [_hostile,_munition];

_posac = getpos _ac;
_poshostile = getpos _missile;
_range = _poshostile distance _posac;
_highlow = "High";

if(typeOf _ac == "fza_ah64d_b2e" || typeOf _ac == "fza_ah64d_b2exp" || typeOf _ac == "fza_ah64d_b3") then
{
	{
		if (_hostile iskindof _x && !(_hostile in fza_ah64_targetlist)) then {fza_ah64_targetlist = fza_ah64_targetlist + [_hostile];};
	} foreach fza_ah64_ada_units;
};

{
	if (_hostile iskindof _x && fza_ah64_rfjstate == 1 && fza_ah64_rfjon == 0 && fza_ah64_aseautopage == 2) then {_rfjammerscript = [_ac] execvm "\fza_ah64_controls\scripting\rf_jammer.sqf";};
	if (_hostile iskindof _x && fza_ah64_irjstate == 1 && fza_ah64_irjon == 0 && fza_ah64_aseautopage == 2) then {_irjammerscript = [_ac] execvm "\fza_ah64_controls\scripting\ir_jammer.sqf";};
} foreach fza_ah64_ada_units;

if (_posac select 2 > _poshostile select 2) then
{
	_highlow = "Low";
};

_reldir = ((_poshostile select 0) - (_posac select  0)) atan2 ((_poshostile select 1) - (_posac select 1));
if (_reldir < 0) then
{
	_reldir = _reldir + 360;
};

_theta = (360 + (_reldir - (direction _ac))) Mod 360;
_oclock = 12;

if (_theta > 15 && _theta < 46) then
{
	_oclock = 1;
	_clockaud = "fza_ah64_bt_1oclock";
};

if (_theta > 45 && _theta < 76) then
{
	_oclock = 2;
	_clockaud = "fza_ah64_bt_2oclock";
};

if (_theta > 75 && _theta < 106) then
{
	_oclock = 3;
	_clockaud = "fza_ah64_bt_3oclock";
};

if (_theta > 105 && _theta < 136) then
{
	_oclock = 4;
	_clockaud = "fza_ah64_bt_4oclock";
};

if (_theta > 135 && _theta < 166) then
{
	_oclock = 5;
	_clockaud = "fza_ah64_bt_5oclock";
};

if (_theta > 165 && _theta < 196) then
{
	_oclock = 6;
	_clockaud = "fza_ah64_bt_6oclock";
};

if (_theta > 195 && _theta < 226) then
{
	_oclock = 7;
	_clockaud = "fza_ah64_bt_7oclock";
};

if (_theta > 225 && _theta < 256) then
{
	_oclock = 8;
	_clockaud = "fza_ah64_bt_8oclock";
};

if (_theta > 255 && _theta < 286) then
{
	_oclock = 9;
	_clockaud = "fza_ah64_bt_9oclock";
};

if (_theta > 285 && _theta < 316) then
{
	_oclock = 10;
	_clockaud = "fza_ah64_bt_10oclock";
};

if (_theta > 315 && _theta < 346) then
{
	_oclock = 11;
	_clockaud = "fza_ah64_bt_11oclock";
};

_spoken = 1;
_read = 1;
if(!(_hostile in fza_ah64_threatfiring)) then {fza_ah64_threatfiring = fza_ah64_threatfiring + [_hostile];};
if(fza_ah64_aseautopage == 2) then {fza_ah64_pr_mpd = "ase";};
if (_read == 1 && _range < 8000) then
{
	_ac vehiclechat format ["Missile %1 OClock %2 %3 Meters",_oclock,_highlow,_range];
	hint str [_oclock,_highlow,_range];
	_read = 2;
};

if (_spoken == 1 && _range < 8000) then
{
	_bthlsound = "fza_ah64_bt_" + _highlow;
	if(_usesound) then {["fza_ah64_bt_missile",0.65,_clockaud,1.3,_bthlsound,0.62] execvm "\fza_ah64_controls\scripting\damage\dam_bt_audio.sqf";};
	_spoken = 2;
};

fza_ah64_threatfiring = fza_ah64_threatfiring - [_hostile];
if (fza_ah64_rfjstate == 1) then {fza_ah64_rfjon = 0;};
if (fza_ah64_irjstate == 1) then {fza_ah64_irjon = 0;};
