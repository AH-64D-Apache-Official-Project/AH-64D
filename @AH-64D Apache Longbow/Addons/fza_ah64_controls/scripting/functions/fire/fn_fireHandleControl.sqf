#include "\fza_ah64_controls\headers\script_common.hpp"
params ["_heli", "_system", "_control"];

switch(_control) do {
	case "apu": {
		if (isnil "fza_ah64_firetest") then {
			fza_ah64_firetest = 0;
		};
		if (fza_ah64_firetest == 0) exitwith {
			_heli setobjecttexture[1192, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture[1194, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture[1196, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture[1200, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture[1201, "\fza_ah64_us\tex\in\pushbut.paa"];
			fza_ah64_firetest = 1;
			fza_ah64_l1clicked = 1;

			if (player == driver _heli) then {
				_heli animate["plt_firesw", 1];
			} else {
				_heli animate["cpg_firesw", 0];
			};



			_clicksound = ["fza_ah64_switch_flip4", 0.1];
			[player, "fza_ah64_warntest_3D"] remoteExec["say3d"];
		};
		if (fza_ah64_firetest == 1) exitwith {
			_heli setobjecttexture[1192, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture[1194, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture[1196, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture[1198, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture[1199, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture[1200, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture[1201, "\fza_ah64_us\tex\in\pushbut.paa"];
			fza_ah64_firetest = 2;
			fza_ah64_l1clicked = 1;

			if (player == driver _heli) then {
				_heli animate["plt_firesw", 0];
			} else {
				_heli animate["cpg_firesw", 1];
			};

			_clicksound = ["fza_ah64_switch_flip4", 0.1];
			[player, "fza_ah64_warntest_3D"] remoteExec["say3d"];
		};
		if (fza_ah64_firetest == 2) exitwith {
			_heli setobjecttexture[1192, ""];
			_heli setobjecttexture[1194, ""];
			_heli setobjecttexture[1196, ""];
			_heli setobjecttexture[1200, ""];
			_heli setobjecttexture[1201, ""];
			if (!("fza_ah64_firepdisch" in (_heli magazinesturret[-1]))) then {
				_heli setobjecttexture[1198, ""];
			};
			if (!("fza_ah64_firerdisch" in (_heli magazinesturret[-1]))) then {
				_heli setobjecttexture[1199, ""];
			};
			fza_ah64_firetest = 0;
			fza_ah64_l1clicked = 1;

			if (player == driver _heli) then {
				_heli animate["plt_firesw", 0.5];
			} else {
				_heli animate["cpg_firesw", 0.5];
			};

			_clicksound = ["fza_ah64_switch_flip4", 0.1];
		};
	};
	case "fe1": {
		if (fza_ah64_fire1arm == 0) exitwith {
			_heli setobjecttexture[1193, "\fza_ah64_us\tex\in\pushbut.paa"];
			fza_ah64_fire1arm = 1;
			["fza_ah64_button_click2", 0.1];
		};
		if (fza_ah64_fire1arm == 1) exitwith {
			_heli setobjecttexture[1193, ""];
			fza_ah64_fire1arm = 0;
			["fza_ah64_button_click2", 0.1];
		};
	};
	case "fe2": {
		if (fza_ah64_fire2arm == 0) exitwith {
			_heli setobjecttexture[1195, "\fza_ah64_us\tex\in\pushbut.paa"];
			fza_ah64_fire2arm = 1;
			["fza_ah64_button_click2", 0.1];
		};
		if (fza_ah64_fire2arm == 1) exitwith {
			_heli setobjecttexture[1195, ""];
			fza_ah64_fire2arm = 0;
			["fza_ah64_button_click2", 0.1];
		};
	};
	case "fapu": {
			if (fza_ah64_fireapuarm == 0) exitwith {
				_heli setobjecttexture[1197, "\fza_ah64_us\tex\in\pushbut.paa"];
				fza_ah64_fireapuarm = 1;
				["fza_ah64_button_click2", 0.1];
			};
			if (fza_ah64_fireapuarm == 1) exitwith {
				_heli setobjecttexture[1197, ""];
				fza_ah64_fireapuarm = 0;
				["fza_ah64_button_click2", 0.1];
			};
	};
	case "fbp": {
		if ((fza_ah64_fireapuarm == 1 || fza_ah64_fire2arm == 1 || fza_ah64_fire1arm == 1) && !("fza_ah64_firepdisch" in (_heli magazinesturret[-1])) && !("fza_ah64_firepdisch" in magazines _heli)) then {
				_heli setobjecttexture[1198, "\fza_ah64_us\tex\in\pushbut.paa"];
				_heli addmagazine "fza_ah64_firepdisch";
				_heli addmagazineturret["fza_ah64_firepdisch", [-1]];
			};
			["fza_ah64_button_click2", 0.1];
		};
		case "fbr": {
			if ((fza_ah64_fireapuarm == 1 || fza_ah64_fire2arm == 1 || fza_ah64_fire1arm == 1) && !("fza_ah64_firerdisch" in (_heli magazinesturret[-1])) && !("fza_ah64_firerdisch" in magazines _heli)) then {
				_heli setobjecttexture[1199, "\fza_ah64_us\tex\in\pushbut.paa"];
				_heli addmagazine "fza_ah64_firerdisch";
				_heli addmagazineturret["fza_ah64_firerdisch", [-1]];
			};
			["fza_ah64_button_click2", 0.1];
		};
		case "test": {
			if (isnil "fza_ah64_firetest") then {
			fza_ah64_firetest = 0;
		};
		if (fza_ah64_firetest == 0) exitwith {
			_heli setobjecttexture[1192, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture[1194, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture[1196, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture[1200, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture[1201, "\fza_ah64_us\tex\in\pushbut.paa"];
			fza_ah64_firetest = 1;
			fza_ah64_l1clicked = 1;

			if (player == driver _heli) then {
				_heli animate["plt_firesw", 1];
			} else {
				_heli animate["cpg_firesw", 0];
			};



			_clicksound = ["fza_ah64_switch_flip4", 0.1];
			[player, "fza_ah64_warntest_3D"] remoteExec["say3d"];
		};
		if (fza_ah64_firetest == 1) exitwith {
			_heli setobjecttexture[1192, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture[1194, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture[1196, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture[1198, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture[1199, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture[1200, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture[1201, "\fza_ah64_us\tex\in\pushbut.paa"];
			fza_ah64_firetest = 2;
			fza_ah64_l1clicked = 1;

			if (player == driver _heli) then {
				_heli animate["plt_firesw", 0];
			} else {
				_heli animate["cpg_firesw", 1];
			};

			_clicksound = ["fza_ah64_switch_flip4", 0.1];
			[player, "fza_ah64_warntest_3D"] remoteExec["say3d"];
		};
		if (fza_ah64_firetest == 2) exitwith {
			_heli setobjecttexture[1192, ""];
			_heli setobjecttexture[1194, ""];
			_heli setobjecttexture[1196, ""];
			_heli setobjecttexture[1200, ""];
			_heli setobjecttexture[1201, ""];
			if (!("fza_ah64_firepdisch" in (_heli magazinesturret[-1]))) then {
				_heli setobjecttexture[1198, ""];
			};
			if (!("fza_ah64_firerdisch" in (_heli magazinesturret[-1]))) then {
				_heli setobjecttexture[1199, ""];
			};
			fza_ah64_firetest = 0;
			fza_ah64_l1clicked = 1;

			if (player == driver _heli) then {
				_heli animate["plt_firesw", 0.5];
			} else {
				_heli animate["cpg_firesw", 0.5];
			};

			_clicksound = ["fza_ah64_switch_flip4", 0.1];
		};
	};
};