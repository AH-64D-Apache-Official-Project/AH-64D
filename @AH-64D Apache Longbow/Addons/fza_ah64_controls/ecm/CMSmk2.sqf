_ac = _this select 0;
_munition = _this select 1;
_hostile = _this select 2;
_highlow = "Low";
_theta = 0;
_clockaud = "fza_ah64_bt_12oclock";
_usesound = false;
_mistheta = 0;

if(player == driver _ac || player == gunner _ac) then {_usesound = true;};

if(!(_munition isKindOf "missileBase") || !(isengineon _ac || (alive _ac))) exitwith {};

_missile = nearestobject [_hostile,_munition];
_posac = getpos _ac;
_poshostile = getpos _missile;
_range = _poshostile distance _posac;
_highlow = "High";

////Reduces the missiles 2 cores to 1 activation
_fza_ah64_incominghandled = _hostile getVariable ["fza_ah64_shotCounter", 0];
_hostile setVariable ["fza_ah64_shotCounter", (_fza_ah64_incominghandled + 1) % 2];
if (_fza_ah64_incominghandled % 2 == 1) exitWith {};

if(typeOf _ac == "fza_ah64d_b2e" || typeOf _ac == "fza_ah64d_b2exp" || typeOf _ac == "fza_ah64d_b3") then
{
	{
		if (_hostile iskindof _x && !(_hostile in fza_ah64_targetlist)) then {fza_ah64_targetlist = fza_ah64_targetlist + [_hostile];};
	} foreach fza_ah64_ada_units;
};

{
    if (_hostile iskindof _x && _ac getVariable "fza_ah64_rfjstate" == 1 &&  _ac getVariable "fza_ah64_rfjon" == 0 && _ac getVariable "fza_ah64_aseautopage" == 2) then {
        _rfjammerscript = [_ac] execvm "\fza_ah64_controls\scripting\rf_jammer.sqf";
    };
    if (_hostile iskindof _x && _ac getVariable "fza_ah64_irjstate" == 1 && _ac getVariable "fza_ah64_irjon" == 0 && _ac getVariable "fza_ah64_aseautopage" == 2) then {
        _irjammerscript = [_ac] execvm "\fza_ah64_controls\scripting\ir_jammer.sqf";
    };
}
foreach fza_ah64_ada_units;

if (_posac select 2 > _poshostile select 2) then
{
	_highlow = "Low";
};

_theta = [_ac, (getpos _ac select 0), (getpos _ac select 1), (_poshostile select 0), (_poshostile select 1)] call fza_fnc_relativeDirection;
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

if(!(_hostile in fza_ah64_threatfiring)) then {fza_ah64_threatfiring = fza_ah64_threatfiring + [_hostile];};
if (_ac getVariable "fza_ah64_aseautopage" == 2) then {
        [_ac, 1, "ase"] call fza_fnc_mpdSetDisplay;
    };

if (_ac getVariable "fza_ah64_aseautopage" >= 1 && (_range < 8000)) then {
	_ac vehiclechat format ["Missile %1 OClock %2 %3 Meters",_oclock,_highlow,_range];
	_bthlsound = "fza_ah64_bt_" + _highlow;
	if (_usesound) then { 
		["fza_ah64_bt_missile", 0.65, _clockaud, 1.3, _bthlsound, 0.62] spawn fza_fnc_playAudio;
	};
};

fza_ah64_threatfiring = fza_ah64_threatfiring - [_hostile];
if (_ac getVariable "fza_ah64_rfjstate" == 1) then {_ac setVariable ["fza_ah64_rfjon", 0, true];};
if (_ac getVariable "fza_ah64_irjstate" == 1) then {_ac setVariable ["fza_ah64_irjon", 0, true];};

if(local _ac && !(player == driver _ac) || !(player == gunner _ac)) then
{
	_missile = nearestobject [_hostile,_munition];
	_posac = getpos _ac;
	_poshostile = getpos _missile;
	_range = _poshostile distance _posac;
	_highlow = "High";
	_chance1 = 200;
	_rand = 4;

	////ASE PAGE LINK////
	waitUntil {((_ac getVariable "fza_ah64_rfjstate" == 1 && (_ac getVariable "fza_ah64_aseautopage" == 2)) || (_ac getVariable "fza_ah64_rfjon" == 1) || !(alive _missile))};
	if !(alive _missile) exitwith {};
	////ASE PAGE LINK END////

	if(typeof _missile in fza_ah64_mis_ir) then {_rand = 5;};
	if(typeof _missile in fza_ah64_mis_rf) then {_rand = 4;};
	if (floor random 10 < _rand) exitwith {};
	waitUntil {_missile distance _ac < 350};
	while {(alive _missile) && (alive _ac)} do
	{
		_mistheta = [_ac, (getpos _ac select 0), (getpos _ac select 1), (_poshostile select 0), (_poshostile select 1)] call fza_fnc_relativeDirection;
		_missile setdir (_mistheta - (random _chance1));
		_pbvar = _missile call fza_fnc_getPitchBank;
		_pitch = _pbvar select 0;
		_bank = _pbvar select 1;
		_bank = _bank - (random _chance1);
		_pitch = _pitch - (random _chance1);
		[_missile, _pitch, _bank] call fza_fnc_setPitchBank;
		sleep 0.1;
	};
    /* // to be added in case munitions inside arma without 2 cores are found
	sleep 5;
	_hostile setVariable ["fza_ah64_shotCounter", 0];*/
};