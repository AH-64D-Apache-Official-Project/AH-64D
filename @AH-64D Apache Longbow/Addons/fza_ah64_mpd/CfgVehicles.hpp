class CfgVehicles {
    class Helicopter;
    class Helicopter_Base_F : Helicopter {
        class MFD;
		class EventHandlers;
    };
    class fza_ah64base : Helicopter_Base_F {
        class MFD : MFD {
			#define MFD_IND_PAGE MFD_IND_PAGE_LEFT
			#define MFD_OFFSET MFD_OFFSET_L
			class MPD_L {
				topLeft = "PLT_MPD_L_TL";
				topRight = "PLT_MPD_L_TR";
				bottomLeft = "PLT_MPD_L_BL";
				#include "mpd.hpp"
			};
			#define MFD_IND_PAGE MFD_IND_PAGE_RIGHT
			#define MFD_OFFSET MFD_OFFSET_R
			class MPD_R {
				topLeft = "PLT_MPD_R_TL";
				topRight = "PLT_MPD_R_TR";
				bottomLeft = "PLT_MPD_R_BL";
				#include "mpd.hpp"
			};
		};
		class EventHandlers : EventHandlers {
			class fza_mpd {
				init = "[_this # 0] call fza_mpd_fnc_init";
			};
		};
		class FzaMpdPages {
			class Off {
				index = MPD_PAGE_OFF;
			};
			class Menu {
				index = MPD_PAGE_MENU;
				handleControl = "fza_mpd_fnc_pageMENUHandleControl";
			};
			class Eng {
				index = MPD_PAGE_ENG;
				draw = "fza_mpd_fnc_pageENGDraw";
				handleControl = "fza_mpd_fnc_pageENGHandleControl";
			};
			class Flt {
				index = MPD_PAGE_FLT;
				draw = "fza_mpd_fnc_pageFLTDraw";
				handleControl = "fza_mpd_fnc_pageFLTHandleControl";
			};
			class Wca {
				index = MPD_PAGE_WCA;
				draw = "fza_mpd_fnc_pageWCADraw";
				handleControl = "fza_mpd_fnc_pageWCAHandleControl";
			};
			class Fuel {
				index = MPD_PAGE_FUEL;
				draw = "fza_mpd_fnc_pageFUELDraw";
				handleControl = "fza_mpd_fnc_pageFUELHandleControl";
			};
			class Wpn {
				index = MPD_PAGE_WPN;
				draw = "fza_mpd_fnc_pageWpnDraw";
				handleControl = "fza_mpd_fnc_pageWPNHandleControl";
				class InitState {
					selectedWeapon = 0;
					wasOverride = 0;
				};
			};
			#include "\fza_ah64_mpd\headers\tsd.hpp"
			class Tsd {
				index = MPD_PAGE_TSD;
				draw = "fza_mpd_fnc_pageTSDDraw";
				handleControl = "fza_mpd_fnc_pageTSDHandleControl";
				class InitState {
					subPageVarPage[] = {0,0};
				};
			};
		};
    };
};