#include "\fza_ah64_controls\headers\script_common.hpp"
#include "\fza_ah64_controls\headers\selections.h"
params ["_heli", "_system", "_control"];

switch(_control) do {
	case "t1": {
		fza_ah64_fcrcscope = fza_ah64_fcrcscope + 1;
		if (fza_ah64_fcrcscope > 1) then {
			fza_ah64_fcrcscope = 0;
		};
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