class CfgVehicles {
    class Helicopter;
    class Helicopter_Base_F : Helicopter {
        class MFD;
        class Turrets;
    };
    class fza_ah64base : Helicopter_Base_F {
        class NewTurret;
        class Turrets : Turrets {
            class MainTurret : NewTurret {
                class MFD;
            }
        };
        class EventHandlers;
    };
    class fza_ah64d_b2e : fza_ah64base {
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
        class Turrets : Turrets {
            class MainTurret : NewTurret {
                class MFD : MFD {
                    #define MFD_IND_PAGE MFD_IND_PAGE_LEFT
                    #define MFD_OFFSET MFD_OFFSET_L
                    class MPD_L {
                        topLeft = "CPG_MPD_L_TL";
                        topRight = "CPG_MPD_L_TR";
                        bottomLeft = "CPG_MPD_L_BL";
                        #include "mpd.hpp"
                    };
                    #define MFD_IND_PAGE MFD_IND_PAGE_RIGHT
                    #define MFD_OFFSET MFD_OFFSET_R
                    class MPD_R {
                        topLeft = "CPG_MPD_R_TL";
                        topRight = "CPG_MPD_R_TR";
                        bottomLeft = "CPG_MPD_R_BL";
                        #include "mpd.hpp"
                    };
                };
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
            class ENG {
                index = MPD_PAGE_ENG;
                draw = "fza_mpd_fnc_pageENGDraw";
                handleControl = "fza_mpd_fnc_pageENGHandleControl";
            };
            class FLT {
                index = MPD_PAGE_FLT;
                draw = "fza_mpd_fnc_pageFLTDraw";
                handleControl = "fza_mpd_fnc_pageFLTHandleControl";
            };
            class WCA {
                index = MPD_PAGE_WCA;
                draw = "fza_mpd_fnc_pageWCADraw";
                handleControl = "fza_mpd_fnc_pageWCAHandleControl";
            };
            class Fuel {
                index = MPD_PAGE_FUEL;
                draw = "fza_mpd_fnc_pageFUELDraw";
                handleControl = "fza_mpd_fnc_pageFUELHandleControl";
            };
            class WPN {
                index = MPD_PAGE_WPN;
                draw = "fza_mpd_fnc_pageWpnDraw";
                handleControl = "fza_mpd_fnc_pageWPNHandleControl";
                class InitState {
                    selectedWeapon = 0;
                    variant = 0;
                    wasOverride = 0;
                    popOutMenu = 0;
                };
            };
            #include "\fza_ah64_mpd\headers\tsd.hpp"
            class TSD {
                index = MPD_PAGE_TSD;
                draw  = "fza_mpd_fnc_pageTSDDraw";
                drawCanvas = "fza_mpd_fnc_pageTSDDrawCanvas";
                handleControl = "fza_mpd_fnc_pageTSDHandleControl";
                usesIcons = 1;
                class InitState {
                    subPageVarPage[] = {0,0};
                    showScale = 0;
                };
                class PersistState {
                    mode = "nav";
                    ctr = 0;
                    tsdScale = 25000;
                };
            };
            class DMS {
                index = MPD_PAGE_DMS;
                draw  = "fza_mpd_fnc_pageDMSDraw";
                handleControl = "fza_mpd_fnc_pageDMSHandleControl";
                class InitState {
                    subPageVarPage[] = {1,0};
                };
            };
            class DTU {
                index = MPD_PAGE_DTU;
                draw  = "fza_mpd_fnc_pageDTUDraw";
                handleControl = "fza_mpd_fnc_pageDTUHandleControl";
                class InitState {
                    subPage = DTU_ROOT;
                    loadState = MFD_DTU_LOAD_COMPLETE;
                };
            };
            class FCR {
                index = MPD_PAGE_FCR;
                draw  = "fza_mpd_fnc_pageFCRDraw";
                handleControl = "fza_mpd_fnc_pageFCRHandleControl";
                usesIcons = 1;
                class InitState {
                    subPageVarPage[] = {5,0};
                };
            };
            class ASE {
                index = MPD_PAGE_ASE;
                draw  = "fza_mpd_fnc_pageASEDraw";
                handleControl = "fza_mpd_fnc_pageASEHandleControl";
                usesIcons = 1;
            };
            class CHAN {
                index = MPD_PAGE_CHAN;
                draw = "fza_mpd_fnc_pageCHANDraw";
                handleControl = "fza_mpd_fnc_pageCHANHandleControl";
                class PersistState {
                    missileChannel = 1;
                };
            };
            class FREQ {
                index = MPD_PAGE_FREQ;
                draw = "fza_mpd_fnc_pageFREQDraw";
                handleControl = "fza_mpd_fnc_pageFREQHandleControl";
            };
            class CODE {
                index = MPD_PAGE_CODE;
                draw = "fza_mpd_fnc_pageCODEDraw";
                handleControl = "fza_mpd_fnc_pageCODEHandleControl";
                class PersistState {
                    set = "LRFD";
                };
            };
            class PERF {
                index = MPD_PAGE_PERF;
                draw  = "fza_mpd_fnc_pagePERFDraw";
                handleControl = "fza_mpd_fnc_pagePerfHandleControl";
            };
            class ACUTIL {
                index = MPD_PAGE_ACUTIL;
                draw  = "fza_mpd_fnc_pageACUtilDraw";
                handleControl = "fza_mpd_fnc_pageACUtilHandleControl";
            };
            class ABR {
                index = MPD_PAGE_ABR;
                draw  = "fza_mpd_fnc_pageABRDraw";
                handleControl = "fza_mpd_fnc_pageABRHandleControl";
                class PersistState {
                    pageNumber = 1;
                };
            };
        };
    };
};