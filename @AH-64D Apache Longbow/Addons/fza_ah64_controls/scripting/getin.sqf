_heli = _this select 0;

if(player == driver _heli) then
{
	if (_heli iskindof "fza_ah64d_b2e_nr") then
	{
	fza_ah64_agmode = 2;
	} else {
	fza_ah64_agmode = 0;
	};
	
fza_ah64_hfmode = _heli;
fza_ah64_guncontrol = 0;
};

//TURNS ON VANILLA A3 RADAR SENSOR

if(typeof _heli == "fza_ah64d_b2e") then 
{
_d = CreateAgent ["VirtualMan_F", position player, [], 0, "FORM"]; 
_d moveInCargo _heli;
_d setVehicleRadar 1;
if (isVehicleRadarOn _heli) then {_d setdamage 1;deleteVehicle _d;};
};