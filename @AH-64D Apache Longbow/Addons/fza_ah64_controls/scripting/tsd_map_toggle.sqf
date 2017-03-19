_heli = _this select 0;
_mapcount = count fza_ah64_maplist;

if(fza_ah64_tsdmap == _mapcount) exitwith {fza_ah64_tsdmap = 0;};
fza_ah64_tsdmap = fza_ah64_tsdmap + 1;
fza_ah64_currentmap = fza_ah64_maplist select (fza_ah64_tsdmap - 1);