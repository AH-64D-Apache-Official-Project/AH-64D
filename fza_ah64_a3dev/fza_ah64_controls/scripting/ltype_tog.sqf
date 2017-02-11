_ah64 = _this select 0;

if (fza_ah64_ltype == "lobl.sqf") exitwith {fza_ah64_ltype = "loaldir.sqf";};
if (fza_ah64_ltype == "loaldir.sqf") exitwith {fza_ah64_ltype = "loallo.sqf";};
if (fza_ah64_ltype == "loallo.sqf") exitwith {fza_ah64_ltype = "loalhi.sqf";};
if (fza_ah64_ltype == "loalhi.sqf") exitwith {fza_ah64_ltype = "lobl.sqf";};