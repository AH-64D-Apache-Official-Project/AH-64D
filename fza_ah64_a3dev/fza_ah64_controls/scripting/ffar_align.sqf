_array = _this;
_ah64 = _this select 0;
_weapon = _this select 1;
_muzzle = _this select 2;
_mode = _this select 3;
_ammotype = _this select 4;
_missobj = _this select 6;
_mags = magazines _ah64;

if (_weapon == "fza_m230") then
{
drop ["\fza_ah64_us\weps\m789\m789_case","","SpaceObject",1,7,(_ah64 selectionPosition "osahlavne"),[random 0.5,random 0.5,-12],1,2.5,1,0,[1],[[1,1,1,1]],[0],0,0,"","",_ah64];
};

if (_weapon == "fza_ah64_chaff30") then
{
drop [["\A3\data_f\ParticleEffects\Universal\Universal",16,14,5,1],"","Billboard",1,10,[-1,-6,0],[-5,0,7],(random 2),1.1,0.8,0.5,[5],[[1,1,1,1]],[1.5],0.2,0.2,"","",_ah64];
drop [["\A3\data_f\ParticleEffects\Universal\Universal",16,14,5,1],"","Billboard",1,10,[-1,-6,0],[-5,0,7],(random 2),1.1,0.8,0.5,[5],[[1,1,1,1]],[1.5],0.2,0.2,"","",_ah64];
drop [["\A3\data_f\ParticleEffects\Universal\Universal",16,14,5,1],"","Billboard",1,10,[-1,-6,0],[-5,0,7],(random 2),1.1,0.8,0.5,[5],[[1,1,1,1]],[1.5],0.2,0.2,"","",_ah64];
};

if(!(player == driver _ah64 || player == gunner _ah64)) exitwith{};

if (_weapon == "fza_ah64_chaff30") then
{
fza_ah64_curchfln = fza_ah64_curchfln + 1;
fza_ah64_chaffcount = fza_ah64_chaffcount - 1;
if(_mode == "Single") then {fza_ah64_cmsel = 0;};
if(_mode == "Burst") then {fza_ah64_cmsel = 1;};
sleep 3;
fza_ah64_curchfln = fza_ah64_curchfln - 1;
};

if (_weapon == "CMFlareLauncher") then
{
fza_ah64_curflrln = fza_ah64_curflrln + 2;
fza_ah64_flarecount = fza_ah64_flarecount - 1;
if(_mode == "Single") then {fza_ah64_cmsel = 2;};
if(_mode == "Burst") then {fza_ah64_cmsel = 3;};
sleep 3;
fza_ah64_curflrln = fza_ah64_curflrln - 2;
};

if (_weapon == "fza_m230" && (player == gunner _ah64 || local gunner _ah64 || isNull gunner _ah64)) then
{
//if(cameraView == "GUNNER") then {addCamShake [0.1, 0.5, 50];};
/*
if(fza_ah64_burst >= fza_ah64_burst_limit) then
{
_sleeptime = 4;
if(fza_ah64_gunheat >= 20) then {_sleeptime = 8;};
if(fza_ah64_gunheat >= 50) then {_sleeptime = 16;};
if(fza_ah64_gunheat >= 100) then {_sleeptime = 32;};
if(fza_ah64_gunheat >= 200) then {_sleeptime = 64;};
if(fza_ah64_gunheat >= 300) then {_sleeptime = 128;};
//if(!(_ah64 hasweapon "fza_burstlimiter")) then {_ah64 addweapon "fza_burstlimiter";};
//_ah64 removeweapon "fza_m230";
//_ah64 selectweapon "fza_burstlimiter";
//fza_ah64_cmsel = 0;
sleep (_sleeptime);
//if(!(_ah64 hasweapon "fza_m230")) then {_ah64 addweapon "fza_m230";};
//_selectedweapon = currentweapon _ah64;
//if(_selectedweapon == "fza_burstlimiter") then {_selectedweapon = "fza_m230";};
//_ah64 removeweapon "fza_burstlimiter";
//_ah64 selectweapon _selectedweapon;
//fza_ah64_cmsel = 0;
fza_ah64_burst = 0;
fza_ah64_gunheat = 0;
};
*/
if(time - fza_ah64_firekeypressed > 1) then {fza_ah64_burst = 0;};
if(fza_ah64_gunheat > 105) then {[_ah64] call fza_ah64_weaponfault;};
fza_ah64_burst = fza_ah64_burst + 1;
fza_ah64_gunheat = fza_ah64_gunheat + 1;
fza_ah64_firekeypressed = time;
};

//special scripts//

//damage any outside occupants if wing stores used
if(!(_weapon == "fza_m230")) then
{
{
_x setdamage ((damage _x) + 0.05);
} foreach (crew _ah64 - [gunner _ah64,driver _ah64]);
};

if (_missobj isKindOf "fza_agm114l") then
{
sleep 0.1;
[_ah64,_missobj] execvm "\fza_ah64_controls\scripting\missile_guide.sqf";
};


if (typeOf _missobj == "fza_fim92") then
{
[_ah64,_missobj] execvm "\fza_ah64_controls\scripting\missile_guide.sqf";
};

if(player == gunner _ah64 || local gunner _ah64 || isNull gunner _ah64) then
{
sleep 0.011;
if(fza_ah64_rocketsalvo > 0 && fza_ah64_salvofired < fza_ah64_rocketsalvo && (_weapon in fza_ah64_rocketweps14 || _weapon in fza_ah64_rocketweps23 || _weapon in fza_ah64_rocketweps1 || _weapon in fza_ah64_rocketweps2 || _weapon in fza_ah64_rocketweps3 || _weapon in fza_ah64_rocketweps4)) then
{
	if(_ah64 ammo _weapon <= 0) then {fza_ah64_salvofired = 0;};
	_weaponindex = 1;
	_wpncounter = 0;
	{if(_x == _weapon) then {_weaponindex = _wpncounter;}; _wpncounter = _wpncounter + 1;} foreach (weapons _ah64);
	_ah64 setWeaponReloadingTime [gunner _ah64, _weapon, 0];
	_ah64 action ["useWeapon",_ah64,gunner _ah64,_weaponindex];
};

if(fza_ah64_salvofired >= fza_ah64_rocketsalvo) then {sleep 0.1; fza_ah64_salvofired = 0;};
};