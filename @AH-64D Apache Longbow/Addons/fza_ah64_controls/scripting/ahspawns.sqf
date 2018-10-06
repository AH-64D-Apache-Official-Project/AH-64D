///COLD AND DARK SETUP FOR AH-64D///
_heli = _this select 0;
_heli animate ["pdoor",1]; 
_heli animate ["gdoor",1];
_heli animate ["plt_rtrbrake",1];

/*
if(fza_ah64_pwron == 0) then
{
fza_ah64_pl_mpd = "off";
fza_ah64_pr_mpd = "off";
fza_ah64_ihadssoff = 1;
} else {
fza_ah64_pl_mpd = "fuel";
fza_ah64_pr_mpd = "eng";
};
*/


//TRYING TO FIX TADS ORIENTATION BUG

if(fza_ah64_apuon == 1 || isEngineOn _heli) then
{
_heli animate ["tads_stow",0];
} else {
_heli animate ["tads_stow",1];
};



/*
//A TESTER

if(fza_ah64_apuon == 0 || !isEngineOn _heli) then
{
_heli animate ["tads_stow",1];
waitUntil {
_heli animationphase "tads_stow" == 0;
};
};
*/