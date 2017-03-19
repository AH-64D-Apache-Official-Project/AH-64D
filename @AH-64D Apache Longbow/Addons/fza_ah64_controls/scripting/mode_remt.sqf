_heli = _this select 0;

if(count fza_ah64_desiglist < 1) exitwith {_heli vehiclechat "No remote targets!";};

fza_ah64_remtsel = fza_ah64_remtsel + 1;
if(fza_ah64_remtsel > (count fza_ah64_desiglist - 1)) then {fza_ah64_remtsel = 0;};

fza_ah64_hfmode = fza_ah64_desiglist select (fza_ah64_remtsel);

_heli vehiclechat format ["REMOTE: %1,%2",getposatl fza_ah64_hfmode select 0,getposatl fza_ah64_hfmode select 1];