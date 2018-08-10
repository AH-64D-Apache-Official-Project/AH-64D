class fza_ah64_loadout2
{
	idd = -1;
	moving =true;
	movingEnable = true;
	movingEnabled = true;
	colorDisabled[] = { 0, 0, 1, 0.7 };
	controlsBackground[] = { fza_ah64_loadout_back };
	objects[] = {};
	controls[] = {fza_ah64_heli,fza_ah64_pylons,fza_ah64_weapons_list,fza_ah64_loadarea,fza_ah64_loadarea_mis1,fza_ah64_loadarea_mis2,fza_ah64_loadarea_mis3,fza_ah64_loadarea_mis4,fza_ah64_loadarea_act,fza_ah64_wepinfo,fza_ah64_hardpoint1,fza_ah64_hp1_pic,fza_ah64_hardpoint2,fza_ah64_hp2_pic,fza_ah64_hardpoint3,fza_ah64_hp3_pic,fza_ah64_hardpoint4,fza_ah64_hp4_pic,fza_ah64_hardpoint5,fza_ah64_hp5_pic,fza_ah64_load,fza_ah64_clear,fza_ah64_close,fza_ah64_repair,fza_ah64_cannon,fza_ah64_skins};
	class fza_ah64_loadout_back : fza_ah64_RscText
	{
		idc = 100;
		style = ST_PICTURE;
		x = 0.135;
		y = 0;
		w = 0.75;
		h = 1;
		text = "\fza_ah64_controls\arming\loadscreen.paa";
	};
	class fza_ah64_heli : fza_ah64_RscText
	{
		idc = 101;
		style = ST_PICTURE;
		type = ST_LEFT;
		x = 0.24;
		y = -0.038;
		w = 0.375;
		h = 0.5;
		text = "\fza_ah64_controls\arming\ah64db2.paa";
	};
	class fza_ah64_pylons : fza_ah64_RscText
	{
		idc = 102;
		style = ST_PICTURE;
		type = ST_LEFT;
		colorText[] = {1, 1, 1, 0.6};
		x = 0.055;
		y = -0.03;
		w = 0.75;
		h = 0.5;
		text = "\fza_ah64_controls\arming\wpn_area.paa";
	};
	class fza_ah64_weapons_list : fza_ah64_RscListbox
	{
		idc = 103;
		x = 0.705;
		y = 0.005;
		w = 0.175;
		h = 0.86;
		style = LB_MULTI;
		colorText[] = {0.92, 0.73, 0, 1};
		colorBackground[] = {0, 0, 0, 0};
		SizeEX = 0.02;
		colorSelect[] = {0.7, 0, 0, 0.8};
		colorSelectBackGround[] = {0, 0, 0.5, 0.8};
		RowHeight = 0.12;
		wholeHeight = 0.3;
		text="";
	};
	class fza_ah64_loadarea : fza_ah64_RscText
	{
		idc = 104;
		style = ST_PICTURE;
		type = ST_LEFT;
		x = 0.33;
		y = 0.46;
		w = 0.2;
		h = 0.135;
		text = "\fza_ah64_controls\arming\nowep_icn.paa";
	};
	class fza_ah64_loadarea_mis1 : fza_ah64_wepbtn
	{
		idc = 105;
		colorBackground[] = {0, 0, 0, 0};
		colorText[] = {0.9, 0.7, 0, 1};
		x = 0.54;
		y = 0.5;
		w = 0.045;
		h = 0.023;
		sizeEx = 0.03;
		text = "-";
		action = "";
	};
	class fza_ah64_loadarea_mis2 : fza_ah64_loadarea_mis1
	{
		idc = 117; //106 is taken? wtf? IDCs must not be local anymore
		x = 0.54;
		y = 0.533;
	};
	class fza_ah64_loadarea_mis3 : fza_ah64_loadarea_mis1
	{
		idc = 107;
		x = 0.585;
		y = 0.5;
	};
	class fza_ah64_loadarea_mis4 : fza_ah64_loadarea_mis1
	{
		idc = 108;
		x = 0.585;
		y = 0.533;
	};
	class fza_ah64_loadarea_act : fza_ah64_wepbtn
	{
		idc = 109;
		x = 0.33;
		y = 0.46;
		w = 0.2;
		h = 0.135;
		text = "";
		action = "";
	};
	class fza_ah64_wepinfo : fza_ah64_RscText
	{
		idc = 110;
		style = 16;
		linespacing = 1;
		colorBackground[] = {0, 0, 0, 0};
		colorText[] = {0.9, 0.7, 0, 1};
		x = 0.14;
		y = 0.68;
		w = 0.56;
		h = 0.182;
		sizeEx = 0.03;
		text = "-";
	};
	class fza_ah64_hardpoint1 : fza_ah64_wepbtn
	{
		idc = -1;
		colorBackground[] = {0, 0, 0, 0};
		x = 0.355;
		y = 0.016;
		w = 0.15;
		h = 0.1;
		text = "";
		action = "fza_ah64_hardpoint1 = fza_ah64_curwepsel; ctrlsettext [111,(ctrltext 104)];";
	};
	class fza_ah64_hp1_pic : fza_ah64_RscText
	{
		idc = 111;
		style = ST_PICTURE;
		type = ST_LEFT;
		x = 0.333;
		y = 0.0025;
		w = 0.19;
		h = 0.12825;
		text = "";
	};
	class fza_ah64_hardpoint2 : fza_ah64_wepbtn
	{
		idc = -1;
		colorBackground[] = {0, 0, 0, 0};
		x = 0.49;
		y = 0.125;
		w = 0.15;
		h = 0.1;
		text = "";
		action = "fza_ah64_hardpoint2 = fza_ah64_curwepsel; fza_ah64_hardpoint2_ord1 = fza_ah64_weppoint1; fza_ah64_hardpoint2_ord2 = fza_ah64_weppoint2; fza_ah64_hardpoint2_ord3 = fza_ah64_weppoint3; fza_ah64_hardpoint2_ord4 = fza_ah64_weppoint4; ctrlsettext [112,(ctrltext 104)];";
	};
	class fza_ah64_hp2_pic : fza_ah64_RscText
	{
		idc = 112;
		style = ST_PICTURE;
		type = ST_LEFT;
		x = 0.468;
		y = 0.1115;
		w = 0.19;
		h = 0.12825;
		text = "";
	};
	class fza_ah64_hardpoint3 : fza_ah64_wepbtn
	{
		idc = -1;
		colorBackground[] = {0, 0, 0, 0};
		x = 0.49;
		y = 0.27;
		w = 0.15;
		h = 0.1;
		text = "";
		action = "fza_ah64_hardpoint3 = fza_ah64_curwepsel; fza_ah64_hardpoint3_ord1 = fza_ah64_weppoint1; fza_ah64_hardpoint3_ord2 = fza_ah64_weppoint2; fza_ah64_hardpoint3_ord3 = fza_ah64_weppoint3; fza_ah64_hardpoint3_ord4 = fza_ah64_weppoint4; ctrlsettext [113,(ctrltext 104)];";
	};
	class fza_ah64_hp3_pic : fza_ah64_RscText
	{
		idc = 113;
		style = ST_PICTURE;
		type = ST_LEFT;
		x = 0.468;
		y = 0.2565;
		w = 0.19;
		h = 0.12825;
		text = "";
	};
	class fza_ah64_hardpoint4 : fza_ah64_wepbtn
	{
		idc = -1;
		colorBackground[] = {0, 0, 0, 0};
		x = 0.215;
		y = 0.125;
		w = 0.15;
		h = 0.1;
		text = "";
		action = "fza_ah64_hardpoint4 = fza_ah64_curwepsel; fza_ah64_hardpoint4_ord1 = fza_ah64_weppoint1; fza_ah64_hardpoint4_ord2 = fza_ah64_weppoint2; fza_ah64_hardpoint4_ord3 = fza_ah64_weppoint3; fza_ah64_hardpoint4_ord4 = fza_ah64_weppoint4; ctrlsettext [114,(ctrltext 104)];";
	};
	class fza_ah64_hp4_pic : fza_ah64_RscText
	{
		idc = 114;
		style = ST_PICTURE;
		type = ST_LEFT;
		x = 0.193;
		y = 0.1115;
		w = 0.19;
		h = 0.12825;
		text = "";
	};
	class fza_ah64_hardpoint5 : fza_ah64_wepbtn
	{
		idc = -1;
		colorBackground[] = {0, 0, 0, 0};
		x = 0.215;
		y = 0.27;
		w = 0.15;
		h = 0.1;
		text = "";
		action = "fza_ah64_hardpoint5 = fza_ah64_curwepsel; fza_ah64_hardpoint5_ord1 = fza_ah64_weppoint1; fza_ah64_hardpoint5_ord2 = fza_ah64_weppoint2; fza_ah64_hardpoint5_ord3 = fza_ah64_weppoint3; fza_ah64_hardpoint5_ord4 = fza_ah64_weppoint4; ctrlsettext [115,(ctrltext 104)];";
	};
	class fza_ah64_hp5_pic : fza_ah64_RscText
	{
		idc = 115;
		style = ST_PICTURE;
		type = ST_LEFT;
		x = 0.193;
		y = 0.2565;
		w = 0.19;
		h = 0.12825;
		text = "";
	};
	class fza_ah64_load : fza_ah64_wepbtn
	{
		idc = -1;
		colorBackground[] = {0.3, 0.2, 0.5, 0.5};
		colorBackgroundActive[] = { 0.5, 0.2, 0.3, 0.5 };
		colorText[] = {0.9, 0.7, 0, 1};
		colorBorder[] = { 0.9, 0.7, 0, 1 };
		sizeEx = 0.02;
		borderSize = 0.01;
		x = 0.15;
		y = 0.01;
		w = 0.1;
		h = 0.05;
		text = "LOAD";
		action = "[(vehicle player)] execvm ""\fza_ah64_controls\arming\loadweps.sqf""";
	};
	class fza_ah64_clear : fza_ah64_load
	{
		x = 0.6;
		y = 0.01;
		text = "CLEAR";
		action = "";
	};
	class fza_ah64_close : fza_ah64_load
	{
		x = 0.4;
		y = 0.9;
		text = "CLOSE";
		action = "closedialog 0";
	};
	class fza_ah64_repair : fza_ah64_load
	{
		x = 0.51;
		y = 0.9;
		w = 0.15;
		text = "REPAIR-REFUEL";
		action = "[(vehicle player)] execvm ""\fza_ah64_controls\arming\repair_refuel.sqf""";
	};
	class fza_ah64_skins : fza_ah64_load
	{
		x = 0.725;
		y = 0.9;
		w = 0.1;
		text = "SKINS";
		action = "[(vehicle player)] execvm ""\fza_ah64_controls\arming\skinsel.sqf""";
	};
	class fza_ah64_cannon : fza_ah64_loadarea_mis1
	{
		idc = 116;
		x = 0.405;
		y = 0.27;
		colorBackground[] = {0.5, 0, 0.5, 0.5};
		colorBackgroundActive[] = { 0.5, 0, 0.5, 0.5 };
		colorFocused[] = { 0.5, 0, 0.5, 0.5 };
		text = "1200";
		action = "fza_ah64_canmag = fza_ah64_canmag + 1;";
	};
};
