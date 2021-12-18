color[] = {0.2, 1, 0, 1};
helmetMountedDisplay = false;
borderLeft=0;
borderRight=0;
borderTop=0;
font="fza_ticketing";
helmetDown[] = {0,-0.075,0};
helmetPosition[] = {-0.0375,0.0375,0.1};
helmetRight[] = {0.075,0,0};
borderBottom=0;
class material
{
	ambient[]	= { 0.8, 0.8, 0.8, 1 };
	diffuse[]	= { 0.8, 0.8, 0.8, 1 };
	emissive[]	= { 20, 20, 20, 1 };
};
class Bones {
    class Null {
        type = fixed;
        pos[] = {0, 0};
    };
    #include "pages\flt_bones.hpp"
    #include "pages\eng_bones.hpp"
    #include "pages\tsd_bones.hpp"
};
// HUD-Elements definitions
class Draw
{
    class Wpn {
        condition = EQ(USER_NUM(MFD_IND_PAGE), MPD_PAGE_WPN);
        #include "pages\wpn_draw.hpp"
    }
    class Menu {
        condition = EQ(USER_NUM(MFD_IND_PAGE), MPD_PAGE_MENU);
        #include "pages\menu_draw.hpp"
    };
    class Flt {
        condition = EQ(USER_NUM(MFD_IND_PAGE), MPD_PAGE_FLT);
        #include "pages\flt_draw.hpp"
    };
    class Wca {
        condition = EQ(USER_NUM(MFD_IND_PAGE), MPD_PAGE_WCA);
        #include "pages\wca_draw.hpp"
    };
    class Eng{
        condition = EQ(USER_NUM(MFD_IND_PAGE), MPD_PAGE_ENG);
        #include "pages\eng_draw.hpp"
    };
    class Fuel{
        condition = EQ(USER_NUM(MFD_IND_PAGE), MPD_PAGE_FUEL);
        #include "pages\fuel_draw.hpp"
    };
    class Tsd{
        condition = EQ(USER_NUM(MFD_IND_PAGE), MPD_PAGE_TSD);
        #include "pages\tsd_draw.hpp"
    };
};