#include "\fza_ah64_controls\headers\script_common.hpp"
params ["_heli", "_system", "_control"];

switch(_control) do {
	case "l3": {
		fza_ah64_pr_mpd = "ase";
	};
	case "l4": {
		fza_ah64_pr_mpd = "tsd";
	};
	case "l6": {
		fza_ah64_pr_mpd = "fcr";
	};
	case "b1": {
		fza_ah64_pr_mpd = "eng";
	};
	case "tsd": {
		fza_ah64_pr_mpd = "tsd";
	};
	case "fcr" : {
		fza_ah64_pr_mpd = "fcr";
	};
	case "m": {
		fza_ah64_pr_mpd = "wca";
	};
};