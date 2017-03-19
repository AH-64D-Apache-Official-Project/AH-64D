_heli = _this select 0;

if((ctrlText 204) == "N/A" || (ctrlText 204) == "" || (ctrlText 204) == "none" || (ctrlText 204) == "NONE") then
{
	[_heli,(lbText [201, (lbcursel 201)])] execvm "\fza_ah64_controls\scripting\damage\skins.sqf";
} else {
	[_heli,(ctrlText 204)] execvm "\fza_ah64_controls\scripting\damage\skins.sqf";
};