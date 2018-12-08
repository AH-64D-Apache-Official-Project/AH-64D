///COLD AND DARK SETUP FOR AH-64D///
_heli = _this select 0;
_heli animate ["pdoor",1]; 
_heli animate ["gdoor",1];
_heli animate ["plt_rtrbrake",1];

//TADS ORIENTATION FIX

if(fza_ah64_apuon == 1 || isEngineOn _heli) then
{
_heli animate ["tads_stow",0];
} else {
_heli animate ["tads_stow",1];
};