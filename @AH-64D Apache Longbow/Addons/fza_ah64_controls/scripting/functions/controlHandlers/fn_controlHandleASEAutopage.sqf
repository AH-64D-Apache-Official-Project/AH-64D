params ["_heli"];

switch(fza_ah64_aseautopage) do {
	case 0: {
		fza_ah64_aseautopage = 1;
	};
	case 1: {
		fza_ah64_aseautopage = 2;
	};
	case 2: {
		fza_ah64_aseautopage = 0;
	};
};