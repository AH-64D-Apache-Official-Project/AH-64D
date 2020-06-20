#include "\fza_ah64_controls\headers\script_common.hpp"
params ["_heli", "_system", "_control"];

switch(_control) do {
	case "b2": {
		fza_ah64_pl_mpd = "flt";
	};
	case "b3": {
		fza_ah64_pl_mpd = "fuel";
	};
	case "l5": {
		fza_ah64_pl_mpd = "wpn";
	};
	case "wpn": {
		fza_ah64_pl_mpd = "wpn";
	};
	case "m": {
		fza_ah64_pl_mpd = "wca";
	};
};