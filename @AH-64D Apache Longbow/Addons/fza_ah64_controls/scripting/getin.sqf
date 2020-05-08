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