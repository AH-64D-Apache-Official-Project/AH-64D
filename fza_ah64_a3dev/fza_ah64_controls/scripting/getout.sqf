_array = _this;
_heli = _this select 0;
_position = _this select 1;
_unit = _this select 2;

if(local _unit && player == _unit) then
{
if(_position == "gunner" || _position == "driver") then
{
	if(fza_ah64_cem) then
	{
		fza_ah64_pl_mpd = "off";
		fza_ah64_pr_mpd = "off";
		fza_ah64_ihadssoff = 1;
		1 cuttext ["", "PLAIN",0.1];
		2 cuttext ["", "PLAIN",0.1];
	} else {
		fza_ah64_pl_mpd = "fuel";
		fza_ah64_pr_mpd = "eng";
	};
	fza_ah64_guncontrol = 0;
	fza_ah64_estarted = false;
	fza_ah64_apuon = 0;
	fza_ah64_pwron = 0;
	1 cuttext ["", "PLAIN",0.1];
	2 cuttext ["", "PLAIN",0.1];
	if(!(isNil "fza_ah64_bweff")) then
	{
		fza_ah64_bweff ppEffectEnable false;
		fza_ah64_fgeff ppEffectEnable false;
	};
	_engoffscr = [_heli,false] execvm "\fza_ah64_controls\scripting\engon.sqf";
};
};

if(local _unit) then
{
_para = (vehicle _unit);
if(_para iskindof "ParachuteBase") then {_unit action ["eject", _para]; deletevehicle _para;};
};