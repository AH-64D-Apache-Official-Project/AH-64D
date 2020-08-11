#include "\fza_ah64_controls\headers\script_common.hpp"
#include "\fza_ah64_controls\headers\selections.h"
params ["_heli", "_system", "_control"];

switch(_control) do {
	case "r1": {
		[_heli, "OUT"] call fza_fnc_mpdHandleZoom;
	};
	case "r2": {
		[_heli, "IN"] call fza_fnc_mpdHandleZoom;
	};
	case "r4": {
		[_heli] execvm "\fza_ah64_controls\scripting\rf_jammer.sqf";
	};
	case "r5": {
		fza_ah64_rfjstate = fza_ah64_rfjstate + 1;
		if (fza_ah64_rfjstate == 2) then {
			fza_ah64_rfjstate = 0;
		};
	};
	case "r6": {
		fza_ah64_rfjon = 0;
	};
	case "l1": {
		_autpg = [_heli] call fza_fnc_controlHandleASEAutopage;
	};
	case "l4": {
		_irjamonoff = [_heli] execvm "\fza_ah64_controls\scripting\ir_jammer.sqf";
	};
	case "l5": {
		fza_ah64_irjstate = fza_ah64_irjstate + 1;
		if (fza_ah64_irjstate == 2) then {
			fza_ah64_irjstate = 0;
		};
		fza_ah64_l1clicked = 1;
	};
	case "l6": {
		fza_ah64_irjon = 0;
	};
	case "tsd": {
		fza_ah64_pr_mpd = "tsd";
	};
	case "m": {
		if(fza_ah64_pr_mpd != "dms") then {
			fza_ah64_pr_mpd = "dms";
			_heli setobjecttexture [SEL_PR_MPD_BACK, "\fza_ah64_us\tex\dms.paa"];
			if (("fza_ah64_rdp_fail" in (_heli magazinesturret[-1])) && !("fza_ah64_ldp_fail" in (_heli magazinesturret[-1]))) then {
				fza_ah64_pl_mpd = "fail";
				_heli setobjecttexture [SEL_PL_MPD_BACK, ""];
			};
		};
	};
};