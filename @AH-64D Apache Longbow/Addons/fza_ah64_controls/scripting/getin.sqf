_array = _this;
_heli = _this select 0;
_position = _this select 1;
_unit = _this select 2;

if(isNil "fza_ah64_crewweapons") then
{
	fza_ah64_crewweapons = ["SMG_01_F","SMG_01_Holo_F","SMG_01_Holo_pointer_snds_F","SMG_01_ACO_F","SMG_02_F","SMG_02_ACO_F","SMG_02_ARCO_pointg_F","hgun_PDW2000_F","hgun_PDW2000_snds_F","hgun_PDW2000_Holo_F","hgun_PDW2000_Holo_snds_F"];
};

if(local _unit) then
{
if(_position == "gunner" || _position == "driver") then
{
if(_unit == player) then
{
if(isNil "fza_ah64_cem") then {fza_ah64_cem = true;};
if(fza_ah64_cem) then
{
	fza_ah64_pl_mpd = "off";
	fza_ah64_pr_mpd = "off";
	fza_ah64_ihadssoff = 1;
	fza_ah64_monocleinbox = 1;
	if(_position == "driver") then
	{
		sleep 0.1;
		if(isengineon _heli) then
		{
			_fuelsave = fuel _heli;
			_heli setfuel 0;
			fza_ah64_fuelsave = 0;
			player action ["EngineOff",_heli];
			sleep 0.5;
			player action ["EngineOff",_heli];
			fza_ah64_fuelsave = _fuelsave;
		};
	};
	2 cutrsc ["fza_ah64_click_helper", "PLAIN",0.1];
} else {
	fza_ah64_pl_mpd = "fuel";
	fza_ah64_pr_mpd = "eng";
};
//fza_ah64_fuelsave = fuel _heli;
fza_ah64_estarted = false;
_heli removeweapon "fza_m230";
_heli addweapon "fza_burstlimiter";
sleep 0.1;
_heli removeweapon "fza_burstlimiter";
sleep 0.1;
_heli addweapon "fza_m230";
_heli selectweapon "fza_m230";
fza_ah64_hfmode = _heli;
fza_ah64_guncontrol = 3;
if (_heli iskindof "fza_ah64d_b2e_nr") then
{
fza_ah64_agmode = 2;
} else {
fza_ah64_agmode = 0;
};
};
if(!((primaryWeapon _unit) in fza_ah64_crewweapons) && !(primaryWeapon _unit == "")) then
{
_unit groupchat "Ah damn it. I forgot to stow my weapon. I'll drop it.";
_weaponholder = createVehicle [ "WeaponHolder_Single_limited_weapon_F", (_heli modelToWorld (_heli selectionposition "pos driver")), [], 0, "CAN_COLLIDE" ];
_weaponholder addweaponcargo [(primaryweapon _unit),1];
_unit removeweapon (primaryWeapon _unit);
};
if(!(secondaryWeapon _unit == "")) then
{
_unit groupchat "Rats I'm an idiot. I can't carry that or stow that here!";
_weaponholder = createVehicle [ "WeaponHolder_Single_limited_weapon_F", (_heli modelToWorld (_heli selectionposition "pos driver")), [], 0, "CAN_COLLIDE" ];
_weaponholders addweaponcargo [(secondaryweapon _unit),1];
_unit removeweapon (secondaryWeapon _unit);
};
};
};