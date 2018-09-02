_heli = _this select 0;
_enginestate = _this select 1;

if(local _heli && player in _heli) then
{
if(_enginestate) then
{
sleep 0.1;
_heli animate ["plt_rtrbrake",1];
_heli animate ["plt_eng1_start",1];
_heli animate ["plt_eng1_throttle",0.25];
//_heli animate ["tads_stow",0];
fza_ah64_estarted = true;
fza_ah64_apuon = 1;
fza_ah64_pwron = 1;

} else {
if(fza_ah64_cem) then
{
	fza_ah64_ihadssoff = 1;
};
sleep 0.1;
//_heli animate ["plt_rtrbrake",0];
_heli animate ["plt_eng1_start",0];
_heli animate ["plt_eng2_start",0];
_heli animate ["plt_eng1_throttle",0];
_heli animate ["plt_eng2_throttle",0];
_heli animate ["tads_stow",1];

fza_ah64_estarted = false;
//fza_ah64_apuon = 0;
//fza_ah64_pwron = 0;
};
};