_heli = _this select 0;

if(!(driver _heli == player || gunner _heli == player)) exitwith {};

fza_ah64_rangesetting = (fza_ah64_rangesetting) * 2;
if (fza_ah64_rangesetting == 0.00008) then {fza_ah64_rangesetting = 0.0001;};
if (fza_ah64_rangesetting == 0.0004) then {fza_ah64_rangesetting = 0.0005;};
if (fza_ah64_rangesetting == 0.002) then {fza_ah64_rangesetting = 0.00002;};