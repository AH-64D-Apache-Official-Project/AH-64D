_heli = _this select 0;

if(fza_ah64_rocketsalvo <= 1) exitwith {fza_ah64_rocketsalvo = 2;};
if(fza_ah64_rocketsalvo == 2) exitwith {fza_ah64_rocketsalvo = 4;};
if(fza_ah64_rocketsalvo == 4) exitwith {fza_ah64_rocketsalvo = 8;};
if(fza_ah64_rocketsalvo == 8) exitwith {fza_ah64_rocketsalvo = 12;};
if(fza_ah64_rocketsalvo == 12) exitwith {fza_ah64_rocketsalvo = 24;};
if(fza_ah64_rocketsalvo == 24) exitwith {fza_ah64_rocketsalvo = 38;};
if(fza_ah64_rocketsalvo == 38) exitwith {fza_ah64_rocketsalvo = 1;};