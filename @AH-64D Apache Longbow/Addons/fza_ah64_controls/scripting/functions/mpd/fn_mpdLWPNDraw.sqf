#include "\fza_ah64_controls\headers\selections.h"
params ["_heli"];
//TODO: Look at simplifying weapon operation, this is just a copy paste of page_wpn.sqf
//CM
_mags = magazines _heli;
_weps = weapons _heli;
_gunammo = 0;
_hf1l1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
_hf1l2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
_hf1r1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
_hf1r2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
_hf2l1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
_hf2l2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
_hf2r1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
_hf2r2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
_hf3l1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
_hf3l2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
_hf3r1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
_hf3r2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
_hf4l1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
_hf4l2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
_hf4r1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
_hf4r2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
_hfbracket = "\fza_ah64_us\tex\icons\mslxtra.paa";
_hfdesig = "\fza_ah64_us\tex\icons\self.paa";
_hfsaltype = "\fza_ah64_us\tex\icons\sal1.paa";
_hftraj = "\fza_ah64_us\tex\icons\dir.paa";
_hfcurtraj = "\fza_ah64_us\tex\icons\dir.paa";
_sight = "\fza_ah64_us\tex\icons\tads.paa";
_acq = "\fza_ah64_us\tex\icons\tads.paa";
_rgbracket = "\fza_ah64_us\tex\icons\gunxtra.paa";
_gunsel = "\fza_ah64_us\tex\icons\gun-sel_ca.paa";
_burst10 = "\fza_ah64_us\tex\icons\box_ca.paa";
_burst20 = "";
_burst50 = "";
_burst100 = "";
_ammocount = 0;
_rocketweps = ["fza_m261_1234_zoneE", "fza_m261_14", "fza_m261_14_zoneA", "fza_m261_14_zoneB", "fza_m261_14_zoneE", "fza_m261_23", "fza_m261_23_zoneC", "fza_m261_23_zoneD", "fza_m261_23_zoneE", "fza_m261_1", "fza_m261_1_zone1", "fza_m261_1_zone2", "fza_m261_1_zone3", "fza_m261_2", "fza_m261_2_zone1", "fza_m261_2_zone2", "fza_m261_2_zone3", "fza_m261_3", "fza_m261_3_zone1", "fza_m261_3_zone2", "fza_m261_3_zone3", "fza_m261_4", "fza_m261_4_zone1", "fza_m261_4_zone2", "fza_m261_4_zone3"];
_rocketweps1 = ["fza_m261_1", "fza_m261_1_zone1", "fza_m261_1_zone2", "fza_m261_1_zone3"];
_rocketweps2 = ["fza_m261_2", "fza_m261_2_zone1", "fza_m261_2_zone2", "fza_m261_2_zone3"];
_rocketweps3 = ["fza_m261_3", "fza_m261_3_zone1", "fza_m261_3_zone2", "fza_m261_3_zone3"];
_rocketweps4 = ["fza_m261_4", "fza_m261_4_zone1", "fza_m261_4_zone2", "fza_m261_4_zone3"];
_rocketweps14 = ["fza_m261_14", "fza_m261_14_zoneA", "fza_m261_14_zoneB", "fza_m261_14_zoneE"];
_rocketweps23 = ["fza_m261_23", "fza_m261_23_zoneC", "fza_m261_23_zoneD", "fza_m261_23_zoneE"];
_rocketwepsA = ["fza_m261_1_zone1", "fza_m261_4_zone1", "fza_m261_14_zoneA"];
_rocketwepsB = ["fza_m261_1_zone2", "fza_m261_4_zone2", "fza_m261_14_zoneB"];
_rocketwepsC = ["fza_m261_2_zone1", "fza_m261_3_zone1", "fza_m261_23_zoneC"];
_rocketwepsD = ["fza_m261_2_zone2", "fza_m261_3_zone2", "fza_m261_23_zoneD"];
_rocketwepsE = ["fza_m261_1_zone3", "fza_m261_4_zone3", "fza_m261_14_zoneE", "fza_m261_2_zone3", "fza_m261_3_zone3", "fza_m261_23_zoneE"];
_rktabshe = ["fza_m261_m151_14_38", "fza_m261_m151_23_38", "fza_m261_m151_1_19", "fza_m261_m151_2_19", "fza_m261_m151_3_19", "fza_m261_m151_4_19"];
_rktabshes = ["fza_m261_m229_14_38", "fza_m261_m229_23_38", "fza_m261_m229_1_19", "fza_m261_m229_2_19", "fza_m261_m229_3_19", "fza_m261_m229_4_19"];
_rktabsmp = ["fza_m261_m261_14_38", "fza_m261_m261_23_38", "fza_m261_m261_1_19", "fza_m261_m261_2_19", "fza_m261_m261_3_19", "fza_m261_m261_4_19"];
_rktabsfc = ["fza_m261_m255_14_38", "fza_m261_m255_23_38", "fza_m261_m255_1_19", "fza_m261_m255_2_19", "fza_m261_m255_3_19", "fza_m261_m255_4_19"];
_rktabsil = ["fza_m261_m257_14_38", "fza_m261_m257_23_38", "fza_m261_m257_1_19", "fza_m261_m257_2_19", "fza_m261_m257_3_19", "fza_m261_m257_4_19"];
_rktzoneahe = ["fza_m261_m151_1_zone1_12", "fza_m261_m151_4_zone1_12", "fza_m261_m151_14_zoneA"];
_rktzoneahes = ["fza_m261_m229_1_zone1_12", "fza_m261_m229_4_zone1_12", "fza_m261_m229_14_zoneA"];
_rktzoneamp = ["fza_m261_m261_1_zone1_12", "fza_m261_m261_4_zone1_12", "fza_m261_m261_14_zoneA"];
_rktzoneafc = ["fza_m261_m255_1_zone1_12", "fza_m261_m255_4_zone1_12", "fza_m261_m255_14_zoneA"];
_rktzoneail = ["fza_m261_m257_1_zone1_12", "fza_m261_m257_4_zone1_12", "fza_m261_m257_14_zoneA"];
_rktzonebhe = ["fza_m261_m151_1_zone2_4", "fza_m261_m151_4_zone2_4", "fza_m261_m151_14_zoneB"];
_rktzonebhes = ["fza_m261_m229_1_zone2_4", "fza_m261_m229_4_zone2_4", "fza_m261_m229_14_zoneB"];
_rktzonebmp = ["fza_m261_m261_1_zone2_4", "fza_m261_m261_4_zone2_4", "fza_m261_m261_14_zoneB"];
_rktzonebfc = ["fza_m261_m255_1_zone2_4", "fza_m261_m255_4_zone2_4", "fza_m261_m255_14_zoneB"];
_rktzonebil = ["fza_m261_m257_1_zone2_4", "fza_m261_m257_4_zone2_4", "fza_m261_m257_14_zoneB"];
_rktzoneche = ["fza_m261_m151_2_zone1_12", "fza_m261_m151_3_zone1_12", "fza_m261_m151_23_zoneC"];
_rktzoneches = ["fza_m261_m229_2_zone1_12", "fza_m261_m229_3_zone1_12", "fza_m261_m229_23_zoneC"];
_rktzonecmp = ["fza_m261_m261_2_zone1_12", "fza_m261_m261_3_zone1_12", "fza_m261_m261_23_zoneC"];
_rktzonecfc = ["fza_m261_m255_2_zone1_12", "fza_m261_m255_3_zone1_12", "fza_m261_m255_23_zoneC"];
_rktzonecil = ["fza_m261_m257_2_zone1_12", "fza_m261_m257_3_zone1_12", "fza_m261_m257_23_zoneC"];
_rktzonedhe = ["fza_m261_m151_2_zone2_4", "fza_m261_m151_3_zone2_4", "fza_m261_m151_23_zoneD"];
_rktzonedhes = ["fza_m261_m229_2_zone2_4", "fza_m261_m229_3_zone2_4", "fza_m261_m229_23_zoneD"];
_rktzonedmp = ["fza_m261_m261_2_zone2_4", "fza_m261_m261_3_zone2_4", "fza_m261_m261_23_zoneD"];
_rktzonedfc = ["fza_m261_m255_2_zone2_4", "fza_m261_m255_3_zone2_4", "fza_m261_m255_23_zoneD"];
_rktzonedil = ["fza_m261_m257_2_zone2_4", "fza_m261_m257_3_zone2_4", "fza_m261_m257_23_zoneD"];
_rktzoneehe = ["fza_m261_m151_1_zone3_3", "fza_m261_m151_4_zone3_3", "fza_m261_m151_2_zone3_3", "fza_m261_m151_3_zone3_3", "fza_m261_m151_14_zoneE", "fza_m261_m151_23_zoneE"];
_rktzoneehes = ["fza_m261_m229_1_zone3_3", "fza_m261_m229_4_zone3_3", "fza_m261_m229_2_zone3_3", "fza_m261_m229_3_zone3_3", "fza_m261_m229_14_zoneE", "fza_m261_m229_23_zoneE"];
_rktzoneemp = ["fza_m261_m261_1_zone3_3", "fza_m261_m261_4_zone3_3", "fza_m261_m261_2_zone3_3", "fza_m261_m261_3_zone3_3", "fza_m261_m261_14_zoneE", "fza_m261_m261_23_zoneE"];
_rktzoneefc = ["fza_m261_m255_1_zone3_3", "fza_m261_m255_4_zone3_3", "fza_m261_m255_2_zone3_3", "fza_m261_m255_3_zone3_3", "fza_m261_m255_14_zoneE", "fza_m261_m255_23_zoneE"];
_rktzoneeil = ["fza_m261_m257_1_zone3_3", "fza_m261_m257_4_zone3_3", "fza_m261_m257_2_zone3_3", "fza_m261_m257_3_zone3_3", "fza_m261_m257_14_zoneE", "fza_m261_m257_23_zoneE"];
_6pdmags = ["fza_m261_m151_14_38", "fza_m261_m151_23_38", "fza_m261_m151_1_19", "fza_m261_m151_2_19", "fza_m261_m151_3_19", "fza_m261_m151_4_19", "fza_m261_m151_1_zone1_12", "fza_m261_m151_1_zone2_4", "fza_m261_m151_1_zone3_3", "fza_m261_m151_2_zone1_12", "fza_m261_m151_2_zone2_4", "fza_m261_m151_2_zone3_3", "fza_m261_m151_3_zone1_12", "fza_m261_m151_3_zone2_4", "fza_m261_m151_3_zone3_3", "fza_m261_m151_4_zone1_12", "fza_m261_m151_4_zone2_4", "fza_m261_m151_4_zone3_3", "fza_m261_m151_14_zoneA", "fza_m261_m151_14_zoneB", "fza_m261_m151_14_zoneE", "fza_m261_m151_23_zoneC", "fza_m261_m151_23_zoneD", "fza_m261_m151_23_zoneE"];
_6rcmags = ["fza_m261_m229_14_38", "fza_m261_m229_23_38", "fza_m261_m229_1_19", "fza_m261_m229_2_19", "fza_m261_m229_3_19", "fza_m261_m229_4_19", "fza_m261_m229_1_zone1_12", "fza_m261_m229_1_zone2_4", "fza_m261_m229_1_zone3_3", "fza_m261_m229_2_zone1_12", "fza_m261_m229_2_zone2_4", "fza_m261_m229_2_zone3_3", "fza_m261_m229_3_zone1_12", "fza_m261_m229_3_zone2_4", "fza_m261_m229_3_zone3_3", "fza_m261_m229_4_zone1_12", "fza_m261_m229_4_zone2_4", "fza_m261_m229_4_zone3_3", "fza_m261_m229_14_zoneA", "fza_m261_m229_14_zoneB", "fza_m261_m229_14_zoneE", "fza_m261_m229_23_zoneC", "fza_m261_m229_23_zoneD", "fza_m261_m229_23_zoneE"];
_6mpmags = ["fza_m261_m261_14_38", "fza_m261_m261_23_38", "fza_m261_m261_1_19", "fza_m261_m261_2_19", "fza_m261_m261_3_19", "fza_m261_m261_4_19", "fza_m261_m261_1_zone1_12", "fza_m261_m261_1_zone2_4", "fza_m261_m261_1_zone3_3", "fza_m261_m261_2_zone1_12", "fza_m261_m261_2_zone2_4", "fza_m261_m261_2_zone3_3", "fza_m261_m261_3_zone1_12", "fza_m261_m261_3_zone2_4", "fza_m261_m261_3_zone3_3", "fza_m261_m261_4_zone1_12", "fza_m261_m261_4_zone2_4", "fza_m261_m261_4_zone3_3", "fza_m261_m261_14_zoneA", "fza_m261_m261_14_zoneB", "fza_m261_m261_14_zoneE", "fza_m261_m261_23_zoneC", "fza_m261_m261_23_zoneD", "fza_m261_m261_23_zoneE"];
_6fcmags = ["fza_m261_m255_14_38", "fza_m261_m255_23_38", "fza_m261_m255_1_19", "fza_m261_m255_2_19", "fza_m261_m255_3_19", "fza_m261_m255_4_19", "fza_m261_m255_1_zone1_12", "fza_m261_m255_1_zone2_4", "fza_m261_m255_1_zone3_3", "fza_m261_m255_2_zone1_12", "fza_m261_m255_2_zone2_4", "fza_m261_m255_2_zone3_3", "fza_m261_m255_3_zone1_12", "fza_m261_m255_3_zone2_4", "fza_m261_m255_3_zone3_3", "fza_m261_m255_4_zone1_12", "fza_m261_m255_4_zone2_4", "fza_m261_m255_4_zone3_3", "fza_m261_m255_14_zoneA", "fza_m261_m255_14_zoneB", "fza_m261_m255_14_zoneE", "fza_m261_m255_23_zoneC", "fza_m261_m255_23_zoneD", "fza_m261_m255_23_zoneE"];
_6ilmags = ["fza_m261_m257_14_38", "fza_m261_m257_23_38", "fza_m261_m257_1_19", "fza_m261_m257_2_19", "fza_m261_m257_3_19", "fza_m261_m257_4_19", "fza_m261_m257_1_zone1_12", "fza_m261_m257_1_zone2_4", "fza_m261_m257_1_zone3_3", "fza_m261_m257_2_zone1_12", "fza_m261_m257_2_zone2_4", "fza_m261_m257_2_zone3_3", "fza_m261_m257_3_zone1_12", "fza_m261_m257_3_zone2_4", "fza_m261_m257_3_zone3_3", "fza_m261_m257_4_zone1_12", "fza_m261_m257_4_zone2_4", "fza_m261_m257_4_zone3_3", "fza_m261_m257_14_zoneA", "fza_m261_m257_14_zoneB", "fza_m261_m257_14_zoneE", "fza_m261_m257_23_zoneC", "fza_m261_m257_23_zoneD", "fza_m261_m257_23_zoneE"];
_rkt1 = "\fza_ah64_us\tex\icons\PODINV.paa";
_rkt2 = "\fza_ah64_us\tex\icons\PODINV.paa";
_rkt3 = "\fza_ah64_us\tex\icons\PODINV.paa";
_rkt4 = "\fza_ah64_us\tex\icons\PODINV.paa";
_rktsel1 = "\fza_ah64_us\tex\icons\6PD-B_ca.paa";
_rktsel2 = "\fza_ah64_us\tex\icons\6PD-B_ca.paa";
_rktsel3 = "\fza_ah64_us\tex\icons\6PD-B_ca.paa";
_rktsel4 = "\fza_ah64_us\tex\icons\6PD-B_ca.paa";
_rktzone1 = "\fza_ah64_us\tex\icons\6PD-G_ca.paa";
_rktzone2 = "\fza_ah64_us\tex\icons\6PD-G_ca.paa";
_rktzone3 = "\fza_ah64_us\tex\icons\6PD-G_ca.paa";
_rktzone4 = "\fza_ah64_us\tex\icons\6PD-G_ca.paa";
_rktzone5 = "\fza_ah64_us\tex\icons\6PD-G_ca.paa";
_rktseltype = "\fza_ah64_us\tex\icons\6PD-B_ca.paa";
_rocketcount = 0;
_rocketcountA = 0;
_rocketcountB = 0;
_rocketcountC = 0;
_rocketcountD = 0;
_rocketcountE = 0;
_rkt14ammo = 0;
_rkt23ammo = 0;
_gunammo = _heli ammo "fza_m230";
if (currentweapon _heli == "fza_m230" || currentweapon _heli == "fza_burstlimiter") then {
	_rgbracket = "\fza_ah64_us\tex\icons\gunxtra.paa";
	_gunsel = "\fza_ah64_us\tex\icons\gun-sel_ca.paa";
	switch (_heli getVariable "fza_ah64_burst_limit") do {
		case 10: {
			_burst10 = "\fza_ah64_us\tex\icons\box_ca.paa";
			_burst20 = "";
			_burst50 = "";
			_burst100 = "";
		};
		case 20: {
			_burst10 = "";
			_burst20 = "\fza_ah64_us\tex\icons\box_ca.paa";
			_burst50 = "";
			_burst100 = "";
		};
		case 50: {
			_burst10 = "";
			_burst20 = "";
			_burst50 = "\fza_ah64_us\tex\icons\box_ca.paa";
			_burst100 = "";
		};
		case 100: {
			_burst10 = "";
			_burst20 = "";
			_burst50 = "";
			_burst100 = "\fza_ah64_us\tex\icons\box_ca.paa";
		};
	};
} else {
	_rgbracket = "";
	_gunsel = "";
	_burst10 = "";
	_burst20 = "";
	_burst50 = "";
	_burst100 = "";
};
_hfbracket = "";
_hfdesig = "";
_hfsaltype = "";
_hftraj = "";
_hf1l1_tex = "";
_hf1l2_tex = "";
_hf1r1_tex = "";
_hf1r2_tex = "";
_hf2l1_tex = "";
_hf2l2_tex = "";
_hf2r1_tex = "";
_hf2r2_tex = "";
_hf3l1_tex = "";
_hf3l2_tex = "";
_hf3r1_tex = "";
_hf3r2_tex = "";
_hf4l1_tex = "";
_hf4l2_tex = "";
_hf4r1_tex = "";
_hf4r2_tex = "";

_curwpn = weaponState [_heli, [0]];

if (_curwpn # 0 iskindof ["fza_agm114_16", configFile / "CfgWeapons"]) then {
	switch (_curwpn # 2) do {
		case "Cruise": {
			_hfcurtraj = "\fza_ah64_us\tex\icons\hi.paa";
		};
		case "TopDown": {
			_hfcurtraj = "\fza_ah64_us\tex\icons\lo.paa"
		};
		case "LoalDistance" : {
			_hfcurtraj = "\fza_ah64_us\tex\icons\dir.paa";
		};
		default {
			_hfcurtraj = "";
		}
	}
};

_sight = "\fza_ah64_us\tex\icons\tads.paa";
_acq = "\fza_ah64_us\tex\icons\tads.paa";
if (_heli getVariable "fza_ah64_agmode" < 2) then {
	_sight = "\fza_ah64_us\tex\icons\fcr.paa";
};

if (_heli getVariable "fza_ah64_agmode" < 2 && fza_ah64_hfmode == _heli) then {
	_acq = "\fza_ah64_us\tex\icons\fcr.paa";
};
if (!(gettext(configFile >> "CfgMagazines" >> currentMagazine _heli >> "ammo") iskindof "fza_agm114k")) then {
	_acq = _sight
};


if (fza_ah64_hfmode != _heli) then {
	_acq = "\fza_ah64_us\tex\icons\REMT.paa";
};
switch ([_heli] call fza_fnc_targetingGetAcquisitionSource) do {
	case 1: {
		_acq = "\fza_ah64_us\tex\icons\HMD.paa";
	};
	case 2: {
		_acq = "\fza_ah64_us\tex\icons\AUTO.paa";
	};
	case 3: {
		_acq = "\fza_ah64_us\tex\icons\FXD.paa";
	}
};

if ("fza_agm114_23_8" in _weps) then {
	if (currentweapon _heli == "fza_agm114_23_8") then {
		_hfbracket = "\fza_ah64_us\tex\icons\mslxtra.paa";
		if (fza_ah64_hfmode == _heli) then {
			_hfdesig = "\fza_ah64_us\tex\icons\self.paa";
		} else {
			_hfdesig = "\fza_ah64_us\tex\icons\remt.paa";
		};
		_hfsaltype = "\fza_ah64_us\tex\icons\sal1.paa";
		_hftraj = _hfcurtraj;
		if ("fza_agm114c_23_8" in _mags || "fza_agm114a_23_8" in _mags) then {
			_hf2l1_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			_hf2l2_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			_hf2r1_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			_hf2r2_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			_hf3l1_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			_hf3l2_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			_hf3r1_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			_hf3r2_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			//_acq = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114k_23_8" in _mags || "fza_agm114m_23_8" in _mags || "fza_agm114n_23_8" in _mags) then {
			_hf2l1_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hf2l2_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hf2r1_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hf2r2_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hf3l1_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hf3l2_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hf3r1_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hf3r2_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			//_acq = "\fza_ah64_us\tex\icons\tads.paa";
			_hfsaltype = "\fza_ah64_us\tex\icons\sal2.paa";
		};
		if ("fza_agm114l_23_8" in _mags) then {
			_hf2l1_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			_hf2l2_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			_hf2r1_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			_hf2r2_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			_hf3l1_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			_hf3l2_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			_hf3r1_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			_hf3r2_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\fcr.paa";
		};
	} else {
		if ("fza_agm114c_23_8" in _mags || "fza_agm114a_23_8" in _mags) then {
			_hf2l1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
			_hf2l2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
			_hf2r1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
			_hf2r2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
			_hf3l1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
			_hf3l2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
			_hf3r1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
			_hf3r2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
		};
		if ("fza_agm114k_23_8" in _mags || "fza_agm114m_23_8" in _mags || "fza_agm114n_23_8" in _mags) then {
			_hf2l1_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
			_hf2l2_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
			_hf2r1_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
			_hf2r2_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
			_hf3l1_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
			_hf3l2_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
			_hf3r1_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
			_hf3r2_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
		};
		if ("fza_agm114l_23_8" in _mags) then {
			_hf2l1_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
			_hf2l2_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
			_hf2r1_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
			_hf2r2_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
			_hf3l1_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
			_hf3l2_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
			_hf3r1_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
			_hf3r2_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
		};
	};
	_ammocount = _heli ammo "fza_agm114_23_8";
	if (_ammocount < 1) then {
		_hf2r2_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
	if (_ammocount < 2) then {
		_hf3r2_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
	if (_ammocount < 3) then {
		_hf2l2_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
	if (_ammocount < 4) then {
		_hf3l2_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
	if (_ammocount < 5) then {
		_hf2r1_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
	if (_ammocount < 6) then {
		_hf3r1_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
	if (_ammocount < 7) then {
		_hf2l1_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
	if (_ammocount < 8) then {
		_hf3l1_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
};
if ("fza_agm114_14_8" in _weps) then {
	if (currentweapon _heli == "fza_agm114_14_8") then {
		_hfbracket = "\fza_ah64_us\tex\icons\mslxtra.paa";
		if (fza_ah64_hfmode == _heli) then {
			_hfdesig = "\fza_ah64_us\tex\icons\self.paa";
		} else {
			_hfdesig = "\fza_ah64_us\tex\icons\remt.paa";
		};
		_hfsaltype = "\fza_ah64_us\tex\icons\sal1.paa";
		_hftraj = _hfcurtraj;
		if ("fza_agm114c_14_8" in _mags || "fza_agm114a_14_8" in _mags) then {
			_hf1l1_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			_hf1l2_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			_hf1r1_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			_hf1r2_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			_hf4l1_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			_hf4l2_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			_hf4r1_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			_hf4r2_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114k_14_8" in _mags || "fza_agm114m_14_8" in _mags || "fza_agm114n_14_8" in _mags) then {
			_hf1l1_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hf1l2_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hf1r1_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hf1r2_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hf4l1_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hf4l2_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hf4r1_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hf4r2_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
			_hfsaltype = "\fza_ah64_us\tex\icons\sal2.paa";
		};
		if ("fza_agm114l_14_8" in _mags) then {
			_hf1l1_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			_hf1l2_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			_hf1r1_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			_hf1r2_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			_hf4l1_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			_hf4l2_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			_hf4r1_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			_hf4r2_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\fcr.paa";
		};
	} else {
		if ("fza_agm114c_14_8" in _mags || "fza_agm114a_14_8" in _mags) then {
			_hf1l1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
			_hf1l2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
			_hf1r1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
			_hf1r2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
			_hf4l1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
			_hf4l2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
			_hf4r1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
			_hf4r2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
		};
		if ("fza_agm114k_14_8" in _mags || "fza_agm114m_14_8" in _mags || "fza_agm114n_14_8" in _mags) then {
			_hf1l1_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
			_hf1l2_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
			_hf1r1_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
			_hf1r2_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
			_hf4l1_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
			_hf4l2_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
			_hf4r1_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
			_hf4r2_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
		};
		if ("fza_agm114l_14_8" in _mags) then {
			_hf1l1_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
			_hf1l2_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
			_hf1r1_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
			_hf1r2_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
			_hf4l1_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
			_hf4l2_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
			_hf4r1_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
			_hf4r2_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
		};
	};
	_ammocount = _heli ammo "fza_agm114_14_8";
	if (_ammocount < 1) then {
		_hf1r2_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
	if (_ammocount < 2) then {
		_hf4r2_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
	if (_ammocount < 3) then {
		_hf1l2_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
	if (_ammocount < 4) then {
		_hf4l2_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
	if (_ammocount < 5) then {
		_hf1r1_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
	if (_ammocount < 6) then {
		_hf4r1_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
	if (_ammocount < 7) then {
		_hf1l1_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
	if (_ammocount < 8) then {
		_hf4l1_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
};
if ("fza_agm114_1_4" in _weps) then {
	if (currentweapon _heli == "fza_agm114_1_4") then {
		_hfbracket = "\fza_ah64_us\tex\icons\mslxtra.paa";
		if (fza_ah64_hfmode == _heli) then {
			_hfdesig = "\fza_ah64_us\tex\icons\self.paa";
		} else {
			_hfdesig = "\fza_ah64_us\tex\icons\remt.paa";
		};
		_hfsaltype = "\fza_ah64_us\tex\icons\sal1.paa";
		_hftraj = _hfcurtraj;
		if ("fza_agm114c_1_4" in _mags || "fza_agm114a_1_4" in _mags) then {
			_hf1l1_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			_hf1l2_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			_hf1r1_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			_hf1r2_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114k_1_4" in _mags || "fza_agm114m_1_4" in _mags || "fza_agm114n_1_4" in _mags) then {
			_hf1l1_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hf1l2_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hf1r1_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hf1r2_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
			_hfsaltype = "\fza_ah64_us\tex\icons\sal2.paa";
		};
		if ("fza_agm114l_1_4" in _mags) then {
			_hf1l1_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			_hf1l2_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			_hf1r1_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			_hf1r2_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\fcr.paa";
		};
	} else {
		if ("fza_agm114c_1_4" in _mags || "fza_agm114a_1_4" in _mags) then {
			_hf1l1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
			_hf1l2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
			_hf1r1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
			_hf1r2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
		};
		if ("fza_agm114k_1_4" in _mags || "fza_agm114m_1_4" in _mags || "fza_agm114n_1_4" in _mags) then {
			_hf1l1_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
			_hf1l2_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
			_hf1r1_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
			_hf1r2_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
		};
		if ("fza_agm114l_1_4" in _mags) then {
			_hf1l1_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
			_hf1l2_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
			_hf1r1_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
			_hf1r2_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
		};
	};
	_ammocount = _heli ammo "fza_agm114_1_4";
	if (_ammocount < 1) then {
		_hf1r2_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
	if (_ammocount < 2) then {
		_hf1l2_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
	if (_ammocount < 3) then {
		_hf1r1_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
	if (_ammocount < 4) then {
		_hf1l1_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
};
if ("fza_agm114_4_4" in _weps) then {
	if (currentweapon _heli == "fza_agm114_4_4") then {
		_hfbracket = "\fza_ah64_us\tex\icons\mslxtra.paa";
		if (fza_ah64_hfmode == _heli) then {
			_hfdesig = "\fza_ah64_us\tex\icons\self.paa";
		} else {
			_hfdesig = "\fza_ah64_us\tex\icons\remt.paa";
		};
		_hfsaltype = "\fza_ah64_us\tex\icons\sal1.paa";
		_hftraj = _hfcurtraj;
		if ("fza_agm114c_4_4" in _mags || "fza_agm114a_4_4" in _mags) then {
			_hf4l1_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			_hf4l2_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			_hf4r1_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			_hf4r2_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114k_4_4" in _mags || "fza_agm114m_4_4" in _mags || "fza_agm114n_4_4" in _mags) then {
			_hf4l1_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hf4l2_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hf4r1_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hf4r2_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
			_hfsaltype = "\fza_ah64_us\tex\icons\sal2.paa";
		};
		if ("fza_agm114l_4_4" in _mags) then {
			_hf4l1_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			_hf4l2_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			_hf4r1_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			_hf4r2_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\fcr.paa";
		};
	} else {
		if ("fza_agm114c_4_4" in _mags || "fza_agm114a_4_4" in _mags) then {
			_hf4l1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
			_hf4l2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
			_hf4r1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
			_hf4r2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
		};
		if ("fza_agm114k_4_4" in _mags || "fza_agm114m_4_4" in _mags || "fza_agm114n_4_4" in _mags) then {
			_hf4l1_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
			_hf4l2_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
			_hf4r1_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
			_hf4r2_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
		};
		if ("fza_agm114l_4_4" in _mags) then {
			_hf4l1_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
			_hf4l2_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
			_hf4r1_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
			_hf4r2_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
		};
	};
	_ammocount = _heli ammo "fza_agm114_4_4";
	if (_ammocount < 1) then {
		_hf4r2_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
	if (_ammocount < 2) then {
		_hf4l2_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
	if (_ammocount < 3) then {
		_hf4r1_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
	if (_ammocount < 4) then {
		_hf4l1_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
};
if ("fza_agm114_2_4" in _weps) then {
	if (currentweapon _heli == "fza_agm114_2_4") then {
		_hfbracket = "\fza_ah64_us\tex\icons\mslxtra.paa";
		if (fza_ah64_hfmode == _heli) then {
			_hfdesig = "\fza_ah64_us\tex\icons\self.paa";
		} else {
			_hfdesig = "\fza_ah64_us\tex\icons\remt.paa";
		};
		_hfsaltype = "\fza_ah64_us\tex\icons\sal1.paa";
		_hftraj = _hfcurtraj;
		if ("fza_agm114c_2_4" in _mags || "fza_agm114a_2_4" in _mags) then {
			_hf2l1_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			_hf2l2_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			_hf2r1_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			_hf2r2_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114k_2_4" in _mags || "fza_agm114m_2_4" in _mags || "fza_agm114n_2_4" in _mags) then {
			_hf2l1_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hf2l2_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hf2r1_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hf2r2_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
			_hfsaltype = "\fza_ah64_us\tex\icons\sal2.paa";
		};
		if ("fza_agm114l_2_4" in _mags) then {
			_hf2l1_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			_hf2l2_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			_hf2r1_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			_hf2r2_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\fcr.paa";
		};
	} else {
		if ("fza_agm114c_2_4" in _mags || "fza_agm114a_2_4" in _mags) then {
			_hf2l1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
			_hf2l2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
			_hf2r1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
			_hf2r2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
		};
		if ("fza_agm114k_2_4" in _mags || "fza_agm114m_2_4" in _mags || "fza_agm114n_2_4" in _mags) then {
			_hf2l1_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
			_hf2l2_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
			_hf2r1_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
			_hf2r2_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
		};
		if ("fza_agm114l_2_4" in _mags) then {
			_hf2l1_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
			_hf2l2_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
			_hf2r1_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
			_hf2r2_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
		};
	};
	_ammocount = _heli ammo "fza_agm114_2_4";
	if (_ammocount < 1) then {
		_hf2r2_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
	if (_ammocount < 2) then {
		_hf2l2_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
	if (_ammocount < 3) then {
		_hf2r1_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
	if (_ammocount < 4) then {
		_hf2l1_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
};
if ("fza_agm114_3_4" in _weps) then {
	if (currentweapon _heli == "fza_agm114_3_4") then {
		_hfbracket = "\fza_ah64_us\tex\icons\mslxtra.paa";
		if (fza_ah64_hfmode == _heli) then {
			_hfdesig = "\fza_ah64_us\tex\icons\self.paa";
		} else {
			_hfdesig = "\fza_ah64_us\tex\icons\remt.paa";
		};
		_hfsaltype = "\fza_ah64_us\tex\icons\sal1.paa";
		_hftraj = _hfcurtraj;
		if ("fza_agm114c_3_4" in _mags || "fza_agm114a_3_4" in _mags) then {
			_hf3l1_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			_hf3l2_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			_hf3r1_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			_hf3r2_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114k_3_4" in _mags || "fza_agm114m_3_4" in _mags || "fza_agm114n_3_4" in _mags) then {
			_hf3l1_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hf3l2_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hf3r1_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hf3r2_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
			_hfsaltype = "\fza_ah64_us\tex\icons\sal2.paa";
		};
		if ("fza_agm114l_3_4" in _mags) then {
			_hf3l1_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			_hf3l2_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			_hf3r1_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			_hf3r2_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\fcr.paa";
		};
	} else {
		if ("fza_agm114c_3_4" in _mags || "fza_agm114a_3_4" in _mags) then {
			_hf3l1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
			_hf3l2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
			_hf3r1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
			_hf3r2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
		};
		if ("fza_agm114k_3_4" in _mags || "fza_agm114m_3_4" in _mags || "fza_agm114n_3_4" in _mags) then {
			_hf3l1_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
			_hf3l2_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
			_hf3r1_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
			_hf3r2_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
		};
		if ("fza_agm114l_3_4" in _mags) then {
			_hf3l1_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
			_hf3l2_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
			_hf3r1_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
			_hf3r2_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
		};
	};
	_ammocount = _heli ammo "fza_agm114_3_4";
	if (_ammocount < 1) then {
		_hf3r2_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
	if (_ammocount < 2) then {
		_hf3l2_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
	if (_ammocount < 3) then {
		_hf3r1_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
	if (_ammocount < 4) then {
		_hf3l1_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
};
if ("fza_agm114_1_ul" in _weps) then {
	if (currentweapon _heli == "fza_agm114_1_ul") then {
		_hfbracket = "\fza_ah64_us\tex\icons\mslxtra.paa";
		if (fza_ah64_hfmode == _heli) then {
			_hfdesig = "\fza_ah64_us\tex\icons\self.paa";
		} else {
			_hfdesig = "\fza_ah64_us\tex\icons\remt.paa";
		};
		_hfsaltype = "\fza_ah64_us\tex\icons\sal1.paa";
		_hftraj = _hfcurtraj;
		if ("fza_agm114c_1_ul" in _mags || "fza_agm114a_1_ul" in _mags) then {
			_hf1l1_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114k_1_ul" in _mags || "fza_agm114m_1_ul" in _mags || "fza_agm114n_1_ul" in _mags) then {
			_hf1l1_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
			_hfsaltype = "\fza_ah64_us\tex\icons\sal2.paa";
		};
		if ("fza_agm114l_1_ul" in _mags) then {
			_hf1l1_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\fcr.paa";
		};
	} else {
		if ("fza_agm114c_1_ul" in _mags || "fza_agm114a_1_ul" in _mags) then {
			_hf1l1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
		};
		if ("fza_agm114k_1_ul" in _mags || "fza_agm114m_1_ul" in _mags || "fza_agm114n_1_ul" in _mags) then {
			_hf1l1_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
		};
		if ("fza_agm114l_1_ul" in _mags) then {
			_hf1l1_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
		};
	};
	_ammocount = _heli ammo "fza_agm114_1_ul";
	if (_ammocount < 1) then {
		_hf1l1_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
};
if ("fza_agm114_1_ur" in _weps) then {
	if (currentweapon _heli == "fza_agm114_1_ur") then {
		_hfbracket = "\fza_ah64_us\tex\icons\mslxtra.paa";
		if (fza_ah64_hfmode == _heli) then {
			_hfdesig = "\fza_ah64_us\tex\icons\self.paa";
		} else {
			_hfdesig = "\fza_ah64_us\tex\icons\remt.paa";
		};
		_hfsaltype = "\fza_ah64_us\tex\icons\sal1.paa";
		_hftraj = _hfcurtraj;
		if ("fza_agm114c_1_ur" in _mags || "fza_agm114a_1_ur" in _mags) then {
			_hf1r1_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114k_1_ur" in _mags || "fza_agm114m_1_ur" in _mags || "fza_agm114n_1_ur" in _mags) then {
			_hf1r1_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hfsaltype = "\fza_ah64_us\tex\icons\sal2.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114l_1_ur" in _mags) then {
			_hf1r1_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\fcr.paa";
		};
	} else {
		if ("fza_agm114c_1_ur" in _mags || "fza_agm114a_1_ur" in _mags) then {
			_hf1r1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
		};
		if ("fza_agm114k_1_ur" in _mags || "fza_agm114m_1_ur" in _mags || "fza_agm114n_1_ur" in _mags) then {
			_hf1r1_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
		};
		if ("fza_agm114l_1_ur" in _mags) then {
			_hf1r1_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
		};
	};
	_ammocount = _heli ammo "fza_agm114_1_ur";
	if (_ammocount < 1) then {
		_hf1r1_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
};
if ("fza_agm114_1_ll" in _weps) then {
	if (currentweapon _heli == "fza_agm114_1_ll") then {
		_hfbracket = "\fza_ah64_us\tex\icons\mslxtra.paa";
		if (fza_ah64_hfmode == _heli) then {
			_hfdesig = "\fza_ah64_us\tex\icons\self.paa";
		} else {
			_hfdesig = "\fza_ah64_us\tex\icons\remt.paa";
		};
		_hfsaltype = "\fza_ah64_us\tex\icons\sal1.paa";
		_hftraj = _hfcurtraj;
		if ("fza_agm114c_1_ll" in _mags || "fza_agm114a_1_ll" in _mags) then {
			_hf1l2_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114k_1_ll" in _mags || "fza_agm114m_1_ll" in _mags || "fza_agm114n_1_ll" in _mags) then {
			_hf1l2_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hfsaltype = "\fza_ah64_us\tex\icons\sal2.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114l_1_ll" in _mags) then {
			_hf1l2_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\fcr.paa";
		};
	} else {
		if ("fza_agm114c_1_ll" in _mags || "fza_agm114a_1_ll" in _mags) then {
			_hf1l2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
		};
		if ("fza_agm114k_1_ll" in _mags || "fza_agm114m_1_ll" in _mags || "fza_agm114n_1_ll" in _mags) then {
			_hf1l2_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
		};
		if ("fza_agm114l_1_ll" in _mags) then {
			_hf1l2_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
		};
	};
	_ammocount = _heli ammo "fza_agm114_1_ll";
	if (_ammocount < 1) then {
		_hf1l2_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
};
if ("fza_agm114_1_lr" in _weps) then {
	if (currentweapon _heli == "fza_agm114_1_lr") then {
		_hfbracket = "\fza_ah64_us\tex\icons\mslxtra.paa";
		if (fza_ah64_hfmode == _heli) then {
			_hfdesig = "\fza_ah64_us\tex\icons\self.paa";
		} else {
			_hfdesig = "\fza_ah64_us\tex\icons\remt.paa";
		};
		_hfsaltype = "\fza_ah64_us\tex\icons\sal1.paa";
		_hftraj = _hfcurtraj;
		if ("fza_agm114c_1_lr" in _mags || "fza_agm114a_1_lr" in _mags) then {
			_hf1r2_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114k_1_lr" in _mags || "fza_agm114m_1_lr" in _mags || "fza_agm114n_1_lr" in _mags) then {
			_hf1r2_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hfsaltype = "\fza_ah64_us\tex\icons\sal2.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114l_1_lr" in _mags) then {
			_hf1r2_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\fcr.paa";
		};
	} else {
		if ("fza_agm114c_1_lr" in _mags || "fza_agm114a_1_lr" in _mags) then {
			_hf1r2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
		};
		if ("fza_agm114k_1_lr" in _mags || "fza_agm114m_1_lr" in _mags || "fza_agm114n_1_lr" in _mags) then {
			_hf1r2_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
		};
		if ("fza_agm114l_1_lr" in _mags) then {
			_hf1r2_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
		};
	};
	_ammocount = _heli ammo "fza_agm114_1_lr";
	if (_ammocount < 1) then {
		_hf1r2_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
};
if ("fza_agm114_2_ul" in _weps) then {
	if (currentweapon _heli == "fza_agm114_2_ul") then {
		_hfbracket = "\fza_ah64_us\tex\icons\mslxtra.paa";
		if (fza_ah64_hfmode == _heli) then {
			_hfdesig = "\fza_ah64_us\tex\icons\self.paa";
		} else {
			_hfdesig = "\fza_ah64_us\tex\icons\remt.paa";
		};
		_hfsaltype = "\fza_ah64_us\tex\icons\sal1.paa";
		_hftraj = _hfcurtraj;
		if ("fza_agm114c_2_ul" in _mags || "fza_agm114a_2_ul" in _mags) then {
			_hf2l1_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114k_2_ul" in _mags || "fza_agm114m_2_ul" in _mags || "fza_agm114n_2_ul" in _mags) then {
			_hf2l1_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hfsaltype = "\fza_ah64_us\tex\icons\sal2.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114l_2_ul" in _mags) then {
			_hf2l1_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\fcr.paa";
		};
	} else {
		if ("fza_agm114c_2_ul" in _mags || "fza_agm114a_2_ul" in _mags) then {
			_hf2l1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
		};
		if ("fza_agm114k_2_ul" in _mags || "fza_agm114m_2_ul" in _mags || "fza_agm114n_2_ul" in _mags) then {
			_hf2l1_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
		};
		if ("fza_agm114l_2_ul" in _mags) then {
			_hf2l1_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
		};
	};
	_ammocount = _heli ammo "fza_agm114_2_ul";
	if (_ammocount < 1) then {
		_hf2l1_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
};
if ("fza_agm114_2_ur" in _weps) then {
	if (currentweapon _heli == "fza_agm114_2_ur") then {
		_hfbracket = "\fza_ah64_us\tex\icons\mslxtra.paa";
		if (fza_ah64_hfmode == _heli) then {
			_hfdesig = "\fza_ah64_us\tex\icons\self.paa";
		} else {
			_hfdesig = "\fza_ah64_us\tex\icons\remt.paa";
		};
		_hfsaltype = "\fza_ah64_us\tex\icons\sal1.paa";
		_hftraj = _hfcurtraj;
		if ("fza_agm114c_2_ur" in _mags || "fza_agm114a_2_ur" in _mags) then {
			_hf2r1_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114k_2_ur" in _mags || "fza_agm114m_2_ur" in _mags || "fza_agm114n_2_ur" in _mags) then {
			_hf2r1_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hfsaltype = "\fza_ah64_us\tex\icons\sal2.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114l_2_ur" in _mags) then {
			_hf2r1_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\fcr.paa";
		};
	} else {
		if ("fza_agm114c_2_ur" in _mags || "fza_agm114a_2_ur" in _mags) then {
			_hf2r1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
		};
		if ("fza_agm114k_2_ur" in _mags || "fza_agm114m_2_ur" in _mags || "fza_agm114n_2_ur" in _mags) then {
			_hf2r1_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
		};
		if ("fza_agm114l_2_ur" in _mags) then {
			_hf2r1_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
		};
	};
	_ammocount = _heli ammo "fza_agm114_2_ur";
	if (_ammocount < 1) then {
		_hf2r1_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
};
if ("fza_agm114_2_ll" in _weps) then {
	if (currentweapon _heli == "fza_agm114_2_ll") then {
		_hfbracket = "\fza_ah64_us\tex\icons\mslxtra.paa";
		if (fza_ah64_hfmode == _heli) then {
			_hfdesig = "\fza_ah64_us\tex\icons\self.paa";
		} else {
			_hfdesig = "\fza_ah64_us\tex\icons\remt.paa";
		};
		_hfsaltype = "\fza_ah64_us\tex\icons\sal1.paa";
		_hftraj = _hfcurtraj;
		if ("fza_agm114c_2_ll" in _mags || "fza_agm114a_2_ll" in _mags) then {
			_hf2l2_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114k_2_ll" in _mags || "fza_agm114m_2_ll" in _mags || "fza_agm114n_2_ll" in _mags) then {
			_hf2l2_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hfsaltype = "\fza_ah64_us\tex\icons\sal2.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114l_2_ll" in _mags) then {
			_hf2l2_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\fcr.paa";
		};
	} else {
		if ("fza_agm114c_2_ll" in _mags || "fza_agm114a_2_ll" in _mags) then {
			_hf2l2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
		};
		if ("fza_agm114k_2_ll" in _mags || "fza_agm114m_2_ll" in _mags || "fza_agm114n_2_ll" in _mags) then {
			_hf2l2_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
		};
		if ("fza_agm114l_2_ll" in _mags) then {
			_hf2l2_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
		};
	};
	_ammocount = _heli ammo "fza_agm114_2_ll";
	if (_ammocount < 1) then {
		_hf2l2_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
};
if ("fza_agm114_2_lr" in _weps) then {
	if (currentweapon _heli == "fza_agm114_2_lr") then {
		_hfbracket = "\fza_ah64_us\tex\icons\mslxtra.paa";
		if (fza_ah64_hfmode == _heli) then {
			_hfdesig = "\fza_ah64_us\tex\icons\self.paa";
		} else {
			_hfdesig = "\fza_ah64_us\tex\icons\remt.paa";
		};
		_hfsaltype = "\fza_ah64_us\tex\icons\sal1.paa";
		_hftraj = _hfcurtraj;
		if ("fza_agm114c_2_lr" in _mags || "fza_agm114a_2_lr" in _mags) then {
			_hf2r2_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114k_2_lr" in _mags || "fza_agm114m_2_lr" in _mags || "fza_agm114n_2_lr" in _mags) then {
			_hf2r2_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hfsaltype = "\fza_ah64_us\tex\icons\sal2.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114l_2_lr" in _mags) then {
			_hf2r2_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\fcr.paa";
		};
	} else {
		if ("fza_agm114c_2_lr" in _mags || "fza_agm114a_2_lr" in _mags) then {
			_hf2r2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
		};
		if ("fza_agm114k_2_lr" in _mags || "fza_agm114m_2_lr" in _mags || "fza_agm114n_2_lr" in _mags) then {
			_hf2r2_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
		};
		if ("fza_agm114l_2_lr" in _mags) then {
			_hf2r2_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
		};
	};
	_ammocount = _heli ammo "fza_agm114_2_lr";
	if (_ammocount < 1) then {
		_hf2r2_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
};
if ("fza_agm114_3_ul" in _weps) then {
	if (currentweapon _heli == "fza_agm114_3_ul") then {
		_hfbracket = "\fza_ah64_us\tex\icons\mslxtra.paa";
		if (fza_ah64_hfmode == _heli) then {
			_hfdesig = "\fza_ah64_us\tex\icons\self.paa";
		} else {
			_hfdesig = "\fza_ah64_us\tex\icons\remt.paa";
		};
		_hfsaltype = "\fza_ah64_us\tex\icons\sal1.paa";
		_hftraj = _hfcurtraj;
		if ("fza_agm114c_3_ul" in _mags || "fza_agm114a_3_ul" in _mags) then {
			_hf3l1_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114k_3_ul" in _mags || "fza_agm114m_3_ul" in _mags || "fza_agm114n_3_ul" in _mags) then {
			_hf3l1_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hfsaltype = "\fza_ah64_us\tex\icons\sal2.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114l_3_ul" in _mags) then {
			_hf3l1_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\fcr.paa";
		};
	} else {
		if ("fza_agm114c_3_ul" in _mags || "fza_agm114a_3_ul" in _mags) then {
			_hf3l1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
		};
		if ("fza_agm114k_3_ul" in _mags || "fza_agm114m_3_ul" in _mags || "fza_agm114n_3_ul" in _mags) then {
			_hf3l1_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
		};
		if ("fza_agm114l_3_ul" in _mags) then {
			_hf3l1_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
		};
	};
	_ammocount = _heli ammo "fza_agm114_3_ul";
	if (_ammocount < 1) then {
		_hf3l1_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
};
if ("fza_agm114_3_ur" in _weps) then {
	if (currentweapon _heli == "fza_agm114_3_ur") then {
		_hfbracket = "\fza_ah64_us\tex\icons\mslxtra.paa";
		if (fza_ah64_hfmode == _heli) then {
			_hfdesig = "\fza_ah64_us\tex\icons\self.paa";
		} else {
			_hfdesig = "\fza_ah64_us\tex\icons\remt.paa";
		};
		_hfsaltype = "\fza_ah64_us\tex\icons\sal1.paa";
		_hftraj = _hfcurtraj;
		if ("fza_agm114c_3_ur" in _mags || "fza_agm114a_3_ur" in _mags) then {
			_hf3r1_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114k_3_ur" in _mags || "fza_agm114m_3_ur" in _mags || "fza_agm114n_3_ur" in _mags) then {
			_hf3r1_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hfsaltype = "\fza_ah64_us\tex\icons\sal2.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114l_3_ur" in _mags) then {
			_hf3r1_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\fcr.paa";
		};
	} else {
		if ("fza_agm114c_3_ur" in _mags || "fza_agm114a_3_ur" in _mags) then {
			_hf3r1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
		};
		if ("fza_agm114k_3_ur" in _mags || "fza_agm114m_3_ur" in _mags || "fza_agm114n_3_ur" in _mags) then {
			_hf3r1_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
		};
		if ("fza_agm114l_3_ur" in _mags) then {
			_hf3r1_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
		};
	};
	_ammocount = _heli ammo "fza_agm114_3_ur";
	if (_ammocount < 1) then {
		_hf3r1_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
};
if ("fza_agm114_3_ll" in _weps) then {
	if (currentweapon _heli == "fza_agm114_3_ll") then {
		_hfbracket = "\fza_ah64_us\tex\icons\mslxtra.paa";
		if (fza_ah64_hfmode == _heli) then {
			_hfdesig = "\fza_ah64_us\tex\icons\self.paa";
		} else {
			_hfdesig = "\fza_ah64_us\tex\icons\remt.paa";
		};
		_hfsaltype = "\fza_ah64_us\tex\icons\sal1.paa";
		_hftraj = _hfcurtraj;
		if ("fza_agm114c_3_ll" in _mags || "fza_agm114a_3_ll" in _mags) then {
			_hf3l2_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114k_3_ll" in _mags || "fza_agm114m_3_ll" in _mags || "fza_agm114n_3_ll" in _mags) then {
			_hf3l2_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hfsaltype = "\fza_ah64_us\tex\icons\sal2.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114l_3_ll" in _mags) then {
			_hf3l2_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\fcr.paa";
		};
	} else {
		if ("fza_agm114c_3_ll" in _mags || "fza_agm114a_3_ll" in _mags) then {
			_hf3l2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
		};
		if ("fza_agm114k_3_ll" in _mags || "fza_agm114m_3_ll" in _mags || "fza_agm114n_3_ll" in _mags) then {
			_hf3l2_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
		};
		if ("fza_agm114l_3_ll" in _mags) then {
			_hf3l2_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
		};
	};
	_ammocount = _heli ammo "fza_agm114_3_ll";
	if (_ammocount < 1) then {
		_hf3l2_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
};
if ("fza_agm114_3_lr" in _weps) then {
	if (currentweapon _heli == "fza_agm114_3_lr") then {
		_hfbracket = "\fza_ah64_us\tex\icons\mslxtra.paa";
		if (fza_ah64_hfmode == _heli) then {
			_hfdesig = "\fza_ah64_us\tex\icons\self.paa";
		} else {
			_hfdesig = "\fza_ah64_us\tex\icons\remt.paa";
		};
		_hfsaltype = "\fza_ah64_us\tex\icons\sal1.paa";
		_hftraj = _hfcurtraj;
		if ("fza_agm114c_3_lr" in _mags || "fza_agm114a_3_lr" in _mags) then {
			_hf3r2_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114k_3_lr" in _mags || "fza_agm114m_3_lr" in _mags || "fza_agm114n_3_lr" in _mags) then {
			_hf3r2_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hfsaltype = "\fza_ah64_us\tex\icons\sal2.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114l_3_lr" in _mags) then {
			_hf3r2_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\fcr.paa";
		};
	} else {
		if ("fza_agm114c_3_lr" in _mags || "fza_agm114a_3_lr" in _mags) then {
			_hf3r2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
		};
		if ("fza_agm114k_3_lr" in _mags || "fza_agm114m_3_lr" in _mags || "fza_agm114n_3_lr" in _mags) then {
			_hf3r2_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
		};
		if ("fza_agm114l_3_lr" in _mags) then {
			_hf3r2_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
		};
	};
	_ammocount = _heli ammo "fza_agm114_3_lr";
	if (_ammocount < 1) then {
		_hf3r2_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
};
if ("fza_agm114_4_ul" in _weps) then {
	if (currentweapon _heli == "fza_agm114_4_ul") then {
		_hfbracket = "\fza_ah64_us\tex\icons\mslxtra.paa";
		if (fza_ah64_hfmode == _heli) then {
			_hfdesig = "\fza_ah64_us\tex\icons\self.paa";
		} else {
			_hfdesig = "\fza_ah64_us\tex\icons\remt.paa";
		};
		_hfsaltype = "\fza_ah64_us\tex\icons\sal1.paa";
		_hftraj = _hfcurtraj;
		if ("fza_agm114c_4_ul" in _mags || "fza_agm114a_4_ul" in _mags) then {
			_hf4l1_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114k_4_ul" in _mags || "fza_agm114m_4_ul" in _mags || "fza_agm114n_4_ul" in _mags) then {
			_hf4l1_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hfsaltype = "\fza_ah64_us\tex\icons\sal2.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114l_4_ul" in _mags) then {
			_hf4l1_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\fcr.paa";
		};
	} else {
		if ("fza_agm114c_4_ul" in _mags || "fza_agm114a_4_ul" in _mags) then {
			_hf4l1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
		};
		if ("fza_agm114k_4_ul" in _mags || "fza_agm114m_4_ul" in _mags || "fza_agm114n_4_ul" in _mags) then {
			_hf4l1_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
		};
		if ("fza_agm114l_4_ul" in _mags) then {
			_hf4l1_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
		};
	};
	_ammocount = _heli ammo "fza_agm114_4_ul";
	if (_ammocount < 1) then {
		_hf4l1_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
};
if ("fza_agm114_4_ur" in _weps) then {
	if (currentweapon _heli == "fza_agm114_4_ur") then {
		_hfbracket = "\fza_ah64_us\tex\icons\mslxtra.paa";
		if (fza_ah64_hfmode == _heli) then {
			_hfdesig = "\fza_ah64_us\tex\icons\self.paa";
		} else {
			_hfdesig = "\fza_ah64_us\tex\icons\remt.paa";
		};
		_hfsaltype = "\fza_ah64_us\tex\icons\sal1.paa";
		_hftraj = _hfcurtraj;
		if ("fza_agm114c_4_ur" in _mags || "fza_agm114a_4_ur" in _mags) then {
			_hf4r1_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114k_4_ur" in _mags || "fza_agm114m_4_ur" in _mags || "fza_agm114n_4_ur" in _mags) then {
			_hf4r1_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hfsaltype = "\fza_ah64_us\tex\icons\sal2.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114l_4_ur" in _mags) then {
			_hf4r1_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\fcr.paa";
		};
	} else {
		if ("fza_agm114c_4_ur" in _mags || "fza_agm114a_4_ur" in _mags) then {
			_hf4r1_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
		};
		if ("fza_agm114k_4_ur" in _mags || "fza_agm114m_4_ur" in _mags || "fza_agm114n_4_ur" in _mags) then {
			_hf4r1_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
		};
		if ("fza_agm114l_4_ur" in _mags) then {
			_hf4r1_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
		};
	};
	_ammocount = _heli ammo "fza_agm114_4_ur";
	if (_ammocount < 1) then {
		_hf4r1_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
};
if ("fza_agm114_4_ll" in _weps) then {
	if (currentweapon _heli == "fza_agm114_4_ll") then {
		_hfbracket = "\fza_ah64_us\tex\icons\mslxtra.paa";
		if (fza_ah64_hfmode == _heli) then {
			_hfdesig = "\fza_ah64_us\tex\icons\self.paa";
		} else {
			_hfdesig = "\fza_ah64_us\tex\icons\remt.paa";
		};
		_hfsaltype = "\fza_ah64_us\tex\icons\sal1.paa";
		_hftraj = _hfcurtraj;
		if ("fza_agm114c_4_ll" in _mags || "fza_agm114a_4_ll" in _mags) then {
			_hf4l2_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114k_4_ll" in _mags || "fza_agm114m_4_ll" in _mags || "fza_agm114n_4_ll" in _mags) then {
			_hf4l2_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hfsaltype = "\fza_ah64_us\tex\icons\sal2.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114l_4_ll" in _mags) then {
			_hf4l2_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\fcr.paa";
		};
	} else {
		if ("fza_agm114c_4_ll" in _mags || "fza_agm114a_4_ll" in _mags) then {
			_hf4l2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
		};
		if ("fza_agm114k_4_ll" in _mags || "fza_agm114m_4_ll" in _mags || "fza_agm114n_4_ll" in _mags) then {
			_hf4l2_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
		};
		if ("fza_agm114l_4_ll" in _mags) then {
			_hf4l2_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
		};
	};
	_ammocount = _heli ammo "fza_agm114_4_ll";
	if (_ammocount < 1) then {
		_hf4l2_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
};
if ("fza_agm114_4_lr" in _weps) then {
	if (currentweapon _heli == "fza_agm114_4_lr") then {
		_hfbracket = "\fza_ah64_us\tex\icons\mslxtra.paa";
		if (fza_ah64_hfmode == _heli) then {
			_hfdesig = "\fza_ah64_us\tex\icons\self.paa";
		} else {
			_hfdesig = "\fza_ah64_us\tex\icons\remt.paa";
		};
		_hfsaltype = "\fza_ah64_us\tex\icons\sal1.paa";
		_hftraj = _hfcurtraj;
		if ("fza_agm114c_4_lr" in _mags || "fza_agm114a_4_lr" in _mags) then {
			_hf4r2_tex = "\fza_ah64_us\tex\ICONS\114LSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114k_4_lr" in _mags || "fza_agm114m_4_lr" in _mags || "fza_agm114n_4_lr" in _mags) then {
			_hf4r2_tex = "\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa";
			_hfsaltype = "\fza_ah64_us\tex\icons\sal2.paa";
			//_sight = "\fza_ah64_us\tex\icons\tads.paa";
		};
		if ("fza_agm114l_4_lr" in _mags) then {
			_hf4r2_tex = "\fza_ah64_us\tex\ICONS\114RSEL_ca.paa";
			//_sight = "\fza_ah64_us\tex\icons\fcr.paa";
		};
	} else {
		if ("fza_agm114c_4_lr" in _mags || "fza_agm114a_4_lr" in _mags) then {
			_hf4r2_tex = "\fza_ah64_us\tex\ICONS\114LINV_ca.paa";
		};
		if ("fza_agm114k_4_lr" in _mags || "fza_agm114m_4_lr" in _mags || "fza_agm114n_4_lr" in _mags) then {
			_hf4r2_tex = "\fza_ah64_us\tex\ICONS\114LINV2_ca.paa";
		};
		if ("fza_agm114l_4_lr" in _mags) then {
			_hf4r2_tex = "\fza_ah64_us\tex\ICONS\114RINV_ca.paa";
		};
	};
	_ammocount = _heli ammo "fza_agm114_4_lr";
	if (_ammocount < 1) then {
		_hf4r2_tex = "\fza_ah64_us\tex\ICONS\rail.paa";
	};
};

_rocketcount = 0;
_rocketcountA = 0;
_rocketcountB = 0;
_rocketcountC = 0;
_rocketcountD = 0;
_rocketcountE = 0;
_rkt1 = "";
_rkt2 = "";
_rkt3 = "";
_rkt4 = ""; {
	if (_x in _rocketweps) then {
		_rocketcount = _rocketcount + (_heli ammo _x);
	};
	if (_x in _rocketweps1) then {
		_rkt1 = "\fza_ah64_us\tex\icons\PODINV.paa";
		if (currentweapon _heli in _rocketweps1) then {
			_rkt1 = "\fza_ah64_us\tex\icons\PODSEL.paa";
		};
	};
	if (_x in _rocketweps2) then {
		_rkt2 = "\fza_ah64_us\tex\icons\PODINV.paa";
		if (currentweapon _heli in _rocketweps2) then {
			_rkt2 = "\fza_ah64_us\tex\icons\PODSEL.paa";
		};
	};
	if (_x in _rocketweps3) then {
		_rkt3 = "\fza_ah64_us\tex\icons\PODINV.paa";
		if (currentweapon _heli in _rocketweps3) then {
			_rkt3 = "\fza_ah64_us\tex\icons\PODSEL.paa";
		};
	};
	if (_x in _rocketweps4) then {
		_rkt4 = "\fza_ah64_us\tex\icons\PODINV.paa";
		if (currentweapon _heli in _rocketweps4) then {
			_rkt4 = "\fza_ah64_us\tex\icons\PODSEL.paa";
		};
	};
	if (_x in _rocketweps14) then {
		_rkt1 = "\fza_ah64_us\tex\icons\PODINV.paa";
		_rkt4 = "\fza_ah64_us\tex\icons\PODINV.paa";
		if (currentweapon _heli in _rocketweps14) then {
			_rkt1 = "\fza_ah64_us\tex\icons\PODSEL.paa";
			_rkt4 = "\fza_ah64_us\tex\icons\PODSEL.paa";
		};
	};
	if (_x in _rocketweps23) then {
		_rkt2 = "\fza_ah64_us\tex\icons\PODINV.paa";
		_rkt3 = "\fza_ah64_us\tex\icons\PODINV.paa";
		if (currentweapon _heli in _rocketweps23) then {
			_rkt2 = "\fza_ah64_us\tex\icons\PODSEL.paa";
			_rkt3 = "\fza_ah64_us\tex\icons\PODSEL.paa";
		};
	};
	if (_x in _rocketwepsA) then {
		_rocketcountA = _rocketcountA + (_heli ammo _x);
	};
	if (_x in _rocketwepsB) then {
		_rocketcountB = _rocketcountB + (_heli ammo _x);
	};
	if (_x in _rocketwepsC) then {
		_rocketcountC = _rocketcountC + (_heli ammo _x);
	};
	if (_x in _rocketwepsD) then {
		_rocketcountD = _rocketcountD + (_heli ammo _x);
	};
	if (_x in _rocketwepsE) then {
		_rocketcountE = _rocketcountE + (_heli ammo _x);
	};
}
foreach weapons _heli;

_rktsel1 = "";
_rktsel2 = "";
_rktsel3 = "";
_rktsel4 = "";
_rktzone1 = "";
_rktzone2 = "";
_rktzone3 = "";
_rktzone4 = "";
_rktzone5 = "";

if (currentweapon _heli in _rocketweps) then {
	_rgbracket = switch (_heli getVariable "fza_ah64_rocketsalvo") do {
		case 1: {"\fza_ah64_us\tex\icons\RKTxtra_1.paa"};
		case 2: {"\fza_ah64_us\tex\icons\RKTxtra.paa"};
		case 4: {"\fza_ah64_us\tex\icons\RKTxtra_4.paa"};
		case 8: {"\fza_ah64_us\tex\icons\RKTxtra_8.paa"};
		case 12: {"\fza_ah64_us\tex\icons\RKTxtra_12.paa"};
		case 24: {"\fza_ah64_us\tex\icons\RKTxtra_24.paa"};
		case 38: {"\fza_ah64_us\tex\icons\RKTxtra_all.paa"};
	};
	{
		if ((_heli hasweapon "fza_m261_14") && (_x in _rktabshe || _x in _rktabshes || _x in _rktabsmp || _x in _rktabsfc)) then {
			_rkt14ammo = _heli ammo "fza_m261_14";
			_rocketcountA = _rkt14ammo - 14;
			_rocketcountB = 8;
			_rocketcountE = 6;
			if (_rkt14ammo < 14) then {
				_rocketcountB = _rkt14ammo - 6;
			};
			if (_rkt14ammo < 6) then {
				_rocketcountE = _rkt14ammo;
			};
			if (_rocketcountA < 0) then {
				_rocketcountA = 0;
			};
			if (_rocketcountB < 0) then {
				_rocketcountB = 0;
			};
			if (_rocketcountE < 0) then {
				_rocketcountE = 0;
			};
		};
		if ((_heli hasweapon "fza_m261_23") && (_x in _rktabshe || _x in _rktabshes || _x in _rktabsmp || _x in _rktabsfc)) then {
			_rkt23ammo = _heli ammo "fza_m261_23";
			_rocketcountC = _rkt23ammo - 14;
			_rocketcountD = 8;
			_rocketcountE = 6;
			if (_rkt23ammo < 14) then {
				_rocketcountD = _rkt23ammo - 6;
			};
			if (_rkt23ammo < 6) then {
				_rocketcountE = _rkt23ammo;
			};
			if (_rocketcountC < 0) then {
				_rocketcountC = 0;
			};
			if (_rocketcountD < 0) then {
				_rocketcountD = 0;
			};
			if (_rocketcountE < 0) then {
				_rocketcountE = 0;
			};
		};
		if ((_heli hasweapon "fza_m261_14") && (_heli hasweapon "fza_m261_23") && (_x in _rktabshe || _x in _rktabshes || _x in _rktabsmp || _x in _rktabsfc)) then {
			_rocketcountE = 12;
			if (_rkt14ammo < 6 && _rkt23ammo >= 6) then {
				_rocketcountE = _rkt14ammo + 6;
			};
			if (_rkt23ammo < 6 && _rkt14ammo >= 6) then {
				_rocketcountE = _rkt23ammo + 6;
			};
			if (_rkt14ammo < 6 && _rkt23ammo < 6) then {
				_rocketcountE = _rocketcount;
			};
			if (_rocketcountE < 0) then {
				_rocketcountE = 0;
			};
		};
	}
	foreach magazines _heli;

	if (_rocketcountA == 0) then {
		CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PL_RKT1_TOT);
	} else {
		[_heli, _rocketcountA, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PL_RKT1_TOT] call fza_fnc_drawNumberSelections;
	};
	if (_rocketcountB == 0) then {
		CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PL_RKT2_TOT);
	} else {
		[_heli, _rocketcountB, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PL_RKT2_TOT] call fza_fnc_drawNumberSelections;
	};
	if (_rocketcountC == 0) then {
		CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PL_RKT3_TOT);
	} else {
		[_heli, _rocketcountC, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PL_RKT3_TOT] call fza_fnc_drawNumberSelections;
	};
	if (_rocketcountD == 0) then {
		CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PL_RKT4_TOT);
	} else {
		[_heli, _rocketcountD, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PL_RKT4_TOT] call fza_fnc_drawNumberSelections;
	};
	if (_rocketcountE == 0) then {
		CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PL_RKT5_TOT);
	} else {
		[_heli, _rocketcountE, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PL_RKT5_TOT] call fza_fnc_drawNumberSelections;
	};
	[_heli, _rocketcount, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PL_RKT_TOT] call fza_fnc_drawNumberSelections;

	{
		if (_x == "fza_m261_m151_14_38") then {
			_rktzone1 = "\fza_ah64_us\tex\icons\6PD-G_ca.paa";
			_rktzone2 = "\fza_ah64_us\tex\icons\6PD-G_ca.paa";
			_rktzone5 = "\fza_ah64_us\tex\icons\6PD-G_ca.paa";
		};
		if (_x == "fza_m261_m229_14_38") then {
			_rktzone1 = "\fza_ah64_us\tex\icons\6RC-G_ca.paa";
			_rktzone2 = "\fza_ah64_us\tex\icons\6RC-G_ca.paa";
			_rktzone5 = "\fza_ah64_us\tex\icons\6RC-G_ca.paa";
		};
		if (_x == "fza_m261_m261_14_38") then {
			_rktzone1 = "\fza_ah64_us\tex\icons\6MP-G_ca.paa";
			_rktzone2 = "\fza_ah64_us\tex\icons\6MP-G_ca.paa";
			_rktzone5 = "\fza_ah64_us\tex\icons\6MP-G_ca.paa";
		};
		if (_x == "fza_m261_m255_14_38") then {
			_rktzone1 = "\fza_ah64_us\tex\icons\6FL-G_ca.paa";
			_rktzone2 = "\fza_ah64_us\tex\icons\6FL-G_ca.paa";
			_rktzone5 = "\fza_ah64_us\tex\icons\6FL-G_ca.paa";
		};
		if (_x == "fza_m261_m257_14_38") then {
			_rktzone1 = "\fza_ah64_us\tex\icons\6IL-G_ca.paa";
			_rktzone2 = "\fza_ah64_us\tex\icons\6IL-G_ca.paa";
			_rktzone5 = "\fza_ah64_us\tex\icons\6IL-G_ca.paa";
		};
		if (_x == "fza_m261_m151_23_38") then {
			_rktzone3 = "\fza_ah64_us\tex\icons\6PD-G_ca.paa";
			_rktzone4 = "\fza_ah64_us\tex\icons\6PD-G_ca.paa";
			_rktzone5 = "\fza_ah64_us\tex\icons\6PD-G_ca.paa";
		};
		if (_x == "fza_m261_m229_23_38") then {
			_rktzone3 = "\fza_ah64_us\tex\icons\6RC-G_ca.paa";
			_rktzone4 = "\fza_ah64_us\tex\icons\6RC-G_ca.paa";
			_rktzone5 = "\fza_ah64_us\tex\icons\6RC-G_ca.paa";
		};
		if (_x == "fza_m261_m261_23_38") then {
			_rktzone3 = "\fza_ah64_us\tex\icons\6MP-G_ca.paa";
			_rktzone4 = "\fza_ah64_us\tex\icons\6MP-G_ca.paa";
			_rktzone5 = "\fza_ah64_us\tex\icons\6MP-G_ca.paa";
		};
		if (_x == "fza_m261_m255_23_38") then {
			_rktzone3 = "\fza_ah64_us\tex\icons\6FL-G_ca.paa";
			_rktzone4 = "\fza_ah64_us\tex\icons\6FL-G_ca.paa";
			_rktzone5 = "\fza_ah64_us\tex\icons\6FL-G_ca.paa";
		};
		if (_x == "fza_m261_m257_23_38") then {
			_rktzone3 = "\fza_ah64_us\tex\icons\6IL-G_ca.paa";
			_rktzone4 = "\fza_ah64_us\tex\icons\6IL-G_ca.paa";
			_rktzone5 = "\fza_ah64_us\tex\icons\6IL-G_ca.paa";
		};
		if (_x in _rktzoneahe) then {
			_rktzone1 = "\fza_ah64_us\tex\icons\6PD-G_ca.paa";
		};
		if (_x in _rktzoneahes) then {
			_rktzone1 = "\fza_ah64_us\tex\icons\6RC-G_ca.paa";
		};
		if (_x in _rktzoneamp) then {
			_rktzone1 = "\fza_ah64_us\tex\icons\6MP-G_ca.paa";
		};
		if (_x in _rktzoneafc) then {
			_rktzone1 = "\fza_ah64_us\tex\icons\6FL-G_ca.paa";
		};
		if (_x in _rktzoneail) then {
			_rktzone1 = "\fza_ah64_us\tex\icons\6IL-G_ca.paa";
		};
		if (_x in _rktzonebhe) then {
			_rktzone2 = "\fza_ah64_us\tex\icons\6PD-G_ca.paa";
		};
		if (_x in _rktzonebhes) then {
			_rktzone2 = "\fza_ah64_us\tex\icons\6RC-G_ca.paa";
		};
		if (_x in _rktzonebmp) then {
			_rktzone2 = "\fza_ah64_us\tex\icons\6MP-G_ca.paa";
		};
		if (_x in _rktzonebfc) then {
			_rktzone2 = "\fza_ah64_us\tex\icons\6FL-G_ca.paa";
		};
		if (_x in _rktzonebil) then {
			_rktzone2 = "\fza_ah64_us\tex\icons\6IL-G_ca.paa";
		};
		if (_x in _rktzoneche) then {
			_rktzone3 = "\fza_ah64_us\tex\icons\6PD-G_ca.paa";
		};
		if (_x in _rktzoneches) then {
			_rktzone3 = "\fza_ah64_us\tex\icons\6RC-G_ca.paa";
		};
		if (_x in _rktzonecmp) then {
			_rktzone3 = "\fza_ah64_us\tex\icons\6MP-G_ca.paa";
		};
		if (_x in _rktzonecfc) then {
			_rktzone3 = "\fza_ah64_us\tex\icons\6FL-G_ca.paa";
		};
		if (_x in _rktzonecil) then {
			_rktzone3 = "\fza_ah64_us\tex\icons\6IL-G_ca.paa";
		};
		if (_x in _rktzonedhe) then {
			_rktzone4 = "\fza_ah64_us\tex\icons\6PD-G_ca.paa";
		};
		if (_x in _rktzonedhes) then {
			_rktzone4 = "\fza_ah64_us\tex\icons\6RC-G_ca.paa";
		};
		if (_x in _rktzonedmp) then {
			_rktzone4 = "\fza_ah64_us\tex\icons\6MP-G_ca.paa";
		};
		if (_x in _rktzonedfc) then {
			_rktzone4 = "\fza_ah64_us\tex\icons\6FL-G_ca.paa";
		};
		if (_x in _rktzonedil) then {
			_rktzone4 = "\fza_ah64_us\tex\icons\6IL-G_ca.paa";
		};
		if (_x in _rktzoneehe) then {
			_rktzone5 = "\fza_ah64_us\tex\icons\6PD-G_ca.paa";
		};
		if (_x in _rktzoneehes) then {
			_rktzone5 = "\fza_ah64_us\tex\icons\6RC-G_ca.paa";
		};
		if (_x in _rktzoneemp) then {
			_rktzone5 = "\fza_ah64_us\tex\icons\6MP-G_ca.paa";
		};
		if (_x in _rktzoneefc) then {
			_rktzone5 = "\fza_ah64_us\tex\icons\6FL-G_ca.paa";
		};
		if (_x in _rktzoneeil) then {
			_rktzone5 = "\fza_ah64_us\tex\icons\6IL-G_ca.paa";
		};
	}
	foreach magazines _heli;

	if (currentmagazine _heli in _6pdmags) then {
		_rktseltype = "\fza_ah64_us\tex\icons\6PD-B_ca.paa";
	};
	if (currentmagazine _heli in _6rcmags) then {
		_rktseltype = "\fza_ah64_us\tex\icons\6RC-B_ca.paa";
	};
	if (currentmagazine _heli in _6mpmags) then {
		_rktseltype = "\fza_ah64_us\tex\icons\6MP-B_ca.paa";
	};
	if (currentmagazine _heli in _6fcmags) then {
		_rktseltype = "\fza_ah64_us\tex\icons\6FL-B_ca.paa";
	};
	if (currentmagazine _heli in _6ilmags) then {
		_rktseltype = "\fza_ah64_us\tex\icons\6IL-B_ca.paa";
	};
	if (currentweapon _heli in _rocketweps1) then {
		_rktsel1 = _rktseltype;
	};
	if (currentweapon _heli in _rocketweps2) then {
		_rktsel2 = _rktseltype;
	};
	if (currentweapon _heli in _rocketweps3) then {
		_rktsel3 = _rktseltype;
	};
	if (currentweapon _heli in _rocketweps4) then {
		_rktsel4 = _rktseltype;
	};
	if (currentweapon _heli in _rocketweps14) then {
		_rktsel1 = _rktseltype;
		_rktsel4 = _rktseltype;
	};
	if (currentweapon _heli in _rocketweps23) then {
		_rktsel2 = _rktseltype;
		_rktsel3 = _rktseltype;
	};
} else {
	CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PL_RKT_TOT);
	CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PL_RKT1_TOT);
	CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PL_RKT2_TOT);
	CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PL_RKT3_TOT);
	CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PL_RKT4_TOT);
	CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PL_RKT5_TOT);
};
_heli setobjecttexture [SEL_PL_MPD_BACK, "\fza_ah64_us\tex\WPN.paa"];

if (currentweapon _heli == "fza_ma_safe") then {
	_heli setobjecttexture [SEL_PL_MPD_BACK, "\fza_ah64_us\tex\WPN_SAFE.paa"];
} else {
	_heli setobjecttexture [SEL_PL_MPD_BACK, "\fza_ah64_us\tex\WPN.paa"];
};
//TODO: When chaff re-added, add here
[_heli, 0, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PL_CHAFF_QTY] call fza_fnc_drawNumberSelections;
[_heli, _heli ammo "fza_CMFlareLauncher", "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PL_FLARE1_QTY] call fza_fnc_drawNumberSelections;
[_heli, _heli ammo "fza_CMFlareLauncher", "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PL_FLARE2_QTY] call fza_fnc_drawNumberSelections;
[_heli, _gunammo, ["\fza_ah64_us\tex\CHAR\G", "\fza_ah64_us\tex\CHAR\B"] select (currentweapon _heli == "fza_m230" || currentweapon _heli == "fza_burstlimiter"),SEL_DIGITS_MPD_PL_GUN_AMMO] call fza_fnc_drawNumberSelections;
_heli setobjecttexture [SEL_MPD_PL_GUN_BURST_1, _burst10];
_heli setobjecttexture [SEL_MPD_PL_GUN_BURST_2, _burst20];
_heli setobjecttexture [SEL_MPD_PL_GUN_BURST_3, _burst50];
_heli setobjecttexture [SEL_MPD_PL_GUN_BURST_4, _burst100];
_heli setobjecttexture [SEL_MPD_PL_GUN_SEL, _gunsel];
_heli setobjecttexture [SEL_MPD_PL_HF_BRACKET, _hfbracket];
_heli setobjecttexture [SEL_MPD_PL_HF_DESIG, _hfdesig];
_heli setobjecttexture [SEL_MPD_PL_HF_SALT, _hfsaltype];
_heli setobjecttexture [SEL_MPD_PL_HF_TRAJ, _hftraj];
_heli setobjecttexture [SEL_MPD_PL_HF1_L1, _hf1l1_tex];
_heli setobjecttexture [SEL_MPD_PL_HF1_L2, _hf1l2_tex];
_heli setobjecttexture [SEL_MPD_PL_HF1_R1, _hf1r1_tex];
_heli setobjecttexture [SEL_MPD_PL_HF1_R2, _hf1r2_tex];
_heli setobjecttexture [SEL_MPD_PL_HF2_L1, _hf2l1_tex];
_heli setobjecttexture [SEL_MPD_PL_HF2_L2, _hf2l2_tex];
_heli setobjecttexture [SEL_MPD_PL_HF2_R1, _hf2r1_tex];
_heli setobjecttexture [SEL_MPD_PL_HF2_R2, _hf2r2_tex];
_heli setobjecttexture [SEL_MPD_PL_HF3_L1, _hf3l1_tex];
_heli setobjecttexture [SEL_MPD_PL_HF3_L2, _hf3l2_tex];
_heli setobjecttexture [SEL_MPD_PL_HF3_R1, _hf3r1_tex];
_heli setobjecttexture [SEL_MPD_PL_HF3_R2, _hf3r2_tex];
_heli setobjecttexture [SEL_MPD_PL_HF4_L1, _hf4l1_tex];
_heli setobjecttexture [SEL_MPD_PL_HF4_L2, _hf4l2_tex];
_heli setobjecttexture [SEL_MPD_PL_HF4_R1, _hf4r1_tex];
_heli setobjecttexture [SEL_MPD_PL_HF4_R2, _hf4r2_tex];
_heli setobjecttexture [SEL_MPD_PL_RG_BASE, _rgbracket];
_heli setobjecttexture [SEL_MPD_PL_RG_BRACKET, _rgbracket];
_heli setobjecttexture [SEL_MPD_PL_RKT_BURST, _rgbracket];
_heli setobjecttexture [SEL_MPD_PL_RKT_SEL_TYPE_1, _rktsel1];
_heli setobjecttexture [SEL_MPD_PL_RKT_SEL_TYPE_2, _rktsel2];
_heli setobjecttexture [SEL_MPD_PL_RKT_SEL_TYPE_3, _rktsel3];
_heli setobjecttexture [SEL_MPD_PL_RKT_SEL_TYPE_4, _rktsel4];
_heli setobjecttexture [SEL_MPD_PL_RKT1_TYPE, _rktzone1];
_heli setobjecttexture [SEL_MPD_PL_RKT2_TYPE, _rktzone2];
_heli setobjecttexture [SEL_MPD_PL_RKT3_TYPE, _rktzone3];
_heli setobjecttexture [SEL_MPD_PL_RKT4_TYPE, _rktzone4];
_heli setobjecttexture [SEL_MPD_PL_RKT5_TYPE, _rktzone5];
_heli setobjecttexture [SEL_MPD_PL_SIGHT_ACQ, _sight];
_heli setobjecttexture [SEL_MPD_PL_WPN_ACQ, _acq];
_heli setobjecttexture [SEL_MPD_PL_WPN_HF_TYPE, _hfsaltype];
_heli setobjecttexture [SEL_MPD_PL_RKT1, _rkt1];
_heli setobjecttexture [SEL_MPD_PL_RKT2, _rkt2];
_heli setobjecttexture [SEL_MPD_PL_RKT3, _rkt3];
_heli setobjecttexture [SEL_MPD_PL_RKT4, _rkt4];