_heli = _this select 0;


_heli setfuel 1;
fza_ah64_fuelsave = 1;
sleep 0.1;
_heli setdammage 0;

_heli removemagazine "fza_ah64_firepdisch";
_heli removemagazinesturret ["fza_ah64_firepdisch",[-1]];

_heli removemagazine "fza_ah64_firerdisch";
_heli removemagazinesturret ["fza_ah64_firerdisch",[-1]];

_heli vehiclechat "Repaired and refueled.";