_heli = _this select 0;
_laseron = 0;
_helilaser = objNull;

if("fza_ah64_tads_fail" in (_heli magazinesturret [-1]) || _heli in fza_ah64_desiglist) exitwith {};
if(player == gunner _heli && fza_ah64_laserstate == 0) exitwith {fza_ah64_laserstate = 1; _heli vehiclechat "Laser ON.";};
if(player == gunner _heli && fza_ah64_laserstate == 1) exitwith {fza_ah64_laserstate = 0; _heli vehiclechat "Laser OFF.";};

if(!(_heli hasweapon "Laserdesignator_mounted")) then
{
if(!(_heli iskindof "Man")) then
{
_heli addmagazine "Laserbatteries";
_heli addweapon "Laserdesignator_mounted";
};
};

_heli vehiclechat "Laser ready.";

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

_heli vehiclechat "Laser off.";