#include "\fza_ah64_controls\headers\script_common.hpp"
#include "\fza_ah64_controls\headers\selections.h"
params ["_heli", "_system", "_control"];

switch(_control) do {
	case "t3": {
		fza_ah64_pl_mpd = "fuel";
	};
	case "wpn": {
		fza_ah64_pl_mpd = "wpn";
	};
	case "m": {
		fza_ah64_pl_mpd = "dms";
		_heli setobjecttexture [SEL_PL_MPD_BACK, "\fza_ah64_us\tex\dms.paa"];
		if (("fza_ah64_ldp_fail" in (_heli magazinesturret[-1])) && !("fza_ah64_rdp_fail" in (_heli magazinesturret[-1]))) then {
			fza_ah64_pr_mpd = "fail";
			_heli setobjecttexture [SEL_PR_MPD_BACK, ""];
		};
	};
};