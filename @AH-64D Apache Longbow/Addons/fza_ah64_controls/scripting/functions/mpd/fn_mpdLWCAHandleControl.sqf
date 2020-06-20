#include "\fza_ah64_controls\headers\script_common.hpp"
params ["_heli", "_system", "_control"];

switch(_control) do {
	case "m": {
		fza_ah64_pl_mpd = "dms";
		_heli setobjecttexture[302, "\fza_ah64_us\tex\dms.paa"];
		if (("fza_ah64_ldp_fail" in (_heli magazinesturret[-1])) && !("fza_ah64_rdp_fail" in (_heli magazinesturret[-1]))) then {
			fza_ah64_pr_mpd = "fail";
			_heli setobjecttexture[303, ""];
		};
	};
};