_heli = _this select 0;
_laseron = 0;
_helilaser = objNull;

if("fza_ah64_tads_fail" in (_heli magazinesturret [-1]) || _heli in fza_ah64_desiglist) exitwith {};
if(player == gunner _heli && fza_ah64_laserstate == 0) exitwith {fza_ah64_laserstate = 1;};
if(player == gunner _heli && fza_ah64_laserstate == 1) exitwith 
{
	fza_ah64_laserstate = 0; 
	if (fza_ah64_ihadssoff isEqualTo 0 && player in _heli) then 
	{
		fza_ah64_ihadssoff = 1;
		sleep 0.1;
		fza_ah64_ihadssoff = 0;
	};
	//_heli vehiclechat "Laser OFF.";
};

if (player == driver _heli) then 
{
	_weapons = _heli weaponsTurret [0];
	if(!("Laserdesignator_mounted" in _weapons)) then
	{
		if(!(_heli iskindof "Man")) then
		{
			_heli addmagazineturret ["Laserbatteries",[0]];
			_heli addWeaponTurret ["Laserdesignator_mounted",[0]];
			_heli vehiclechat "Laser Armed.";
			sleep 1;
			fza_ah64_pltlaser = 0;
		};
	};
	if ("Laserdesignator_mounted" in _weapons && isManualFire _heli) then {
		if (fza_ah64_pltlaser == 0) exitWith
		{
			_heli fireAtTarget [_heli,"Laserdesignator_mounted"];
			sleep 0.1;
			//_heli vehiclechat "Laser ON.";
			fza_ah64_pltlaser = 1;
		};
		if (fza_ah64_pltlaser == 1) exitWith 
		{
			_heli fireAtTarget [_heli,"Laserdesignator_mounted"];
			sleep 0.1;
			//_heli vehiclechat "Laser OFF.";
			fza_ah64_pltlaser = 0;
		};
	};

};
if (player == gunner _heli) then 
{
	_weapons = _heli weaponsTurret [0];
	if(!("Laserdesignator_mounted" in _weapons)) then
	{
		if(!(_heli iskindof "Man")) then
		{
			_heli addmagazineturret ["Laserbatteries",[0]];
			_heli addWeaponTurret ["Laserdesignator_mounted",[0]];
			_heli vehiclechat "Laser Armed.";
			sleep 1;
			_heli fireAtTarget [_heli,"Laserdesignator_mounted"];
		};
	};
	if ("Laserdesignator_mounted" in _weapons) then {
		if (fza_ah64_laserstate == 0) exitWith
		{
			_heli fireAtTarget [_heli,"Laserdesignator_mounted"];
			sleep 0.1;
		};
		if (fza_ah64_laserstate == 1) exitWith 
		{
			_heli fireAtTarget [_heli,"Laserdesignator_mounted"];
			sleep 0.1;
		};
	};

};
while {(alive _heli && _heli hasweapon "Laserdesignator_mounted") || (alive _heli && _heli hasweapon "Laserdesignator")} do
{
	if(_laseron == 0 && !(isNull lasertarget _heli)) then
	{
		_helilaser = lasertarget _heli;
		fza_ah64_desiglist = fza_ah64_desiglist + [_helilaser];
		publicvariable "fza_ah64_desiglist";
		_laseron = 1;
	};
	if(_laseron == 1 && isNull lasertarget _heli) then
	{
		fza_ah64_desiglist = fza_ah64_desiglist - [_helilaser];
		publicvariable "fza_ah64_desiglist";
		_laseron = 0;
		_helilaser = objNull;
	};
sleep 1;
};

_heli vehiclechat "Laser Disarmed.";
