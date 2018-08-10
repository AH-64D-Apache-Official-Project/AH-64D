
///////////////////////////////
//////AIRCRAFT SKIN MENU///////
///////////////////////////////
class fza_ah64_skinmenu
{
	idd = 199;
	moving = true;
	movingEnable = true;
	movingEnabled = true;
	colorDisabled[] = { 0, 0, 1, 0.7 };
	controlsBackground[] = { fza_ah64_skinmenu_back };
	objects[] = { };
	controls[] = { fza_ah64_skin_list,fza_ah64_skin_act,fza_ah64_skininfo,fza_ah64_skin_close,fza_ah64_skin_ok,fza_ah64_custskinpath,fza_ah64_testskin };
	class fza_ah64_skinmenu_back : fza_ah64_RscText
	{
		idc = 200;
		style = CT_STATIC;
		x = safezoneX + (0.25 * safezoneW);
		y = safezoneY + (0.72 * safezoneH);
		w = safezoneW * 0.5;
		h = safezoneH * 0.26;
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = { 0.1, 0.1, 0.1, 0.8 };
		colorBorder[] = { 0, 0, 0, 0 };
		borderSize = 1;
		text = "";
	};
	class fza_ah64_skin_list : fza_ah64_RscListbox
	{
		idc = 201;
		x = safezoneX + (0.25 * safezoneW);
     	y = safezoneY + (0.72 * safezoneH);
    	w = safezoneW * 0.5;
     	h = safezoneH * 0.075;
		style = LB_MULTI;
		colorText[] = {0.92, 0.73, 0, 1};
		colorBackground[] = {0, 0, 0, 0};
		SizeEX = 0.02;
		colorSelect[] = {0.7, 0, 0, 0.8};
		colorSelectBackGround[] = {0, 0, 0.5, 0.8};
		RowHeight = 0.06;
		wholeHeight = 0.125;
		text="";
	};
	class fza_ah64_skin_act : fza_ah64_wepbtn
	{
		idc = 202;
		x = 0.33;
		y = 0.46;
		w = 0.2;
		h = 0.135;
		text = "";
		action = "";
	};
	class fza_ah64_skininfo : fza_ah64_RscText
	{
		idc = 203;
		style = ST_PICTURE;
		linespacing = 1;
		colorBackground[] = {0, 0, 0, 0};
		colorText[] = {1, 1, 1, 1};
     	x = safezoneX + (0.47 * safezoneW);
     	y = safezoneY + (0.8 * safezoneH);
    	w = safezoneW * 0.06;
     	h = safezoneH * 0.1;
		sizeEx = 0.03;
		text = "";
	};
	class fza_ah64_custskinpath : fza_ah64_TEMPL_EDIT
	{
		idc = 204;
		colorText[] = {0.92, 0.73, 0, 1};
		colorSelect[] = {0.7, 0, 0, 0.8};
		colorSelectBackGround[] = {0, 0, 0.5, 0.8};
     	x = safezoneX + (0.25 * safezoneW);
     	y = safezoneY + (0.9 * safezoneH);
    	w = safezoneW * 0.5;
     	h = safezoneH * 0.025;
		sizeEx = 0.03;
		text = "N/A";
		action = "";
	};
	class fza_ah64_skin_close : fza_ah64_wepbtn
	{
		idc = -1;
		colorBackground[] = {0.3, 0.2, 0.5, 0.5};
		colorBackgroundActive[] = { 0.5, 0.2, 0.3, 0.5 };
		colorText[] = {0.9, 0.7, 0, 1};
		colorBorder[] = { 0.9, 0.7, 0, 1 };
		sizeEx = 0.02;
		borderSize = 0.01;
     	x = safezoneX + (0.25 * safezoneW);
     	y = safezoneY + (0.95 * safezoneH);
    	w = safezoneW * 0.05;
     	h = safezoneH * 0.025;
		text = "CLOSE";
		action = "closedialog 0; fza_ah64_skindialog = false;";
	};
	class fza_ah64_skin_ok : fza_ah64_wepbtn
	{
		idc = -1;
		colorBackground[] = {0.3, 0.2, 0.5, 0.5};
		colorBackgroundActive[] = { 0.5, 0.2, 0.3, 0.5 };
		colorText[] = {0.9, 0.7, 0, 1};
		colorBorder[] = { 0.9, 0.7, 0, 1 };
		sizeEx = 0.02;
		borderSize = 0.01;
     	x = safezoneX + (0.7 * safezoneW);
     	y = safezoneY + (0.95 * safezoneH);
    	w = safezoneW * 0.05;
     	h = safezoneH * 0.025;
		text = "OK";
		action = "[(vehicle player)] execvm ""\fza_ah64_controls\arming\setskin.sqf"";";
	};
	class fza_ah64_testskin : fza_ah64_wepbtn
	{
		idc = -1;
		colorBackground[] = {0.3, 0.2, 0.5, 0.5};
		colorBackgroundActive[] = { 0.5, 0.2, 0.3, 0.5 };
		colorText[] = {0.9, 0.7, 0, 1};
		colorBorder[] = { 0.9, 0.7, 0, 1 };
		sizeEx = 0.02;
		borderSize = 0.01;
     	x = safezoneX + (0.4875 * safezoneW);
     	y = safezoneY + (0.95 * safezoneH);
    	w = safezoneW * 0.05;
     	h = safezoneH * 0.025;
		text = "Test Skin";
		action = "ctrlsettext [203,(ctrlText 204)];";
	};
};
