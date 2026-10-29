#ifdef MPD_MASK_PASS
color[] = {0, 0, 0, 1};
font="fza_BMKApacheBlock";
#else
color[] = {0.2, 1, 0, 1};
font="fza_BMKApacheFont";
#endif
helmetMountedDisplay=0;
borderBottom=0;
borderLeft=0;
borderRight=0;
borderTop=0;
helmetDown[] = {0,-0.075,0};
helmetPosition[] = {-0.0375,0.0375,0.1};
helmetRight[] = {0.075,0,0};
class material
{
    ambient[]   = { 0.8, 0.8, 0.8, 1 };
    diffuse[]   = { 0.8, 0.8, 0.8, 1 };
    emissive[]  = { 20, 20, 20, 1 };
};
class Bones {
    class Null {
        type = "fixed";
        pos[] = {0, 0};
    };
    #include "pages\flt_bones.hpp"
    #include "pages\eng_bones.hpp"
    #include "pages\tsd_bones.hpp"
    #include "pages\ase_bones.hpp"
    #include "pages\fcr_bones.hpp"
    #include "pages\wpn_bones.hpp"
    #include "pages\abr_bones.hpp"
};
// HUD-Elements definitions
class Draw
{
#ifdef MPD_MASK_PASS
// The text's black boxes are only drawn while something is under the page to hide (fza_mpd_fnc_update)
class MaskGate {
    condition = C_COND(C_USER(MFD_IND_MASK));
#endif
    class Wpn {
        condition = C_COND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_WPN));
        #include "pages\wpn_draw.hpp"
    };
    class Menu {
        condition = C_COND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_MENU));
        #include "pages\menu_draw.hpp"
    };
    class FLT {
        condition = C_COND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_FLT));
        #include "pages\flt_draw.hpp"
    };
    class WCA {
        condition = C_COND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_WCA));
        #include "pages\wca_draw.hpp"
    };
    class ENG {
        condition = C_COND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_ENG));
        #include "pages\eng_draw.hpp"
    };
    class Fuel {
        condition = C_COND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_FUEL));
        #include "pages\fuel_draw.hpp"
    };
    // Its own class, before the TSD's: inside one of these Draw classes the MPD draws polygons before lines, so the black
    // backings behind the TSD's labels only hide lines from an earlier class
    class TsdFrame {
        condition = C_COND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_TSD));
        #include "pages\tsd\frame.hpp"
    };
    class TSD {
        condition = C_COND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_TSD));
        #include "pages\tsd_draw.hpp"
    };
    class DMS{
        condition = C_COND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_DMS));
        #include "pages\dms_draw.hpp"
    };
    class Minigames{
        condition = C_COND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_MINIGAMES));
        #include "pages\minigames_draw.hpp"
    };
    class DTU{
        condition = C_COND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_DTU));
        #include "pages\dtu_draw.hpp"
    };
    class FCR{
        condition = C_COND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_FCR));
        #include "pages\fcr_draw.hpp"
    };
    class FCRRMAP{
        condition = C_COND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_FCRRMAP));
        #include "pages\fcr\rmap.hpp"
    };
    class FCRTPM{
        condition = C_COND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_FCRTPM));
        #include "pages\fcr\tpm.hpp"
    };
    class ASE{
        condition = C_COND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_ASE));
        #include "pages\ase_draw.hpp"
    };
    class CODE{
        condition = C_COND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_CODE));
        #include "pages\code_draw.hpp"
    };
    class FREQ{
        condition = C_COND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_FREQ));
        #include "pages\freq_draw.hpp"
    };
    class CHAN{
        condition = C_COND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_CHAN));
        #include "pages\chan_draw.hpp"
    };
    class PERF{
        condition = C_COND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_PERF));
        #include "pages\perf_draw.hpp"
    };
    class ACUTIL{
        condition = C_COND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_ACUTIL));
        #include "pages\acutil_draw.hpp"
    };
    class ABR{
        condition = C_COND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_ABR));
        #include "pages\abr_draw.hpp"
    };
    class VER{
        condition = C_COND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_VER));
        #include "pages\ver_draw.hpp"
    };
    class COORD{
        condition = C_COND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_COORD));
        #include "pages\coord_draw.hpp"
    };
    class VID{
        condition = C_COND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_VID));
        #include "pages\vid_draw.hpp"
    };
    // After the pages, as a class of its own, so its black backing hides the page's lines under it: inside one of these
    // Draw classes the MPD draws polygons before lines. The ACQ button at R6, while the list is closed.
    class AcqSource {
        condition = C_COND(C_EQ(C_USER(MFD_IND_ACQ_OPEN), 0));
        class Flt {
            condition = C_COND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_FLT));
            MPD_ACQ_SRC(Acq, MFD_IND_FLT_ACQ_BOX, MFD_TEXT_IND_FLT_ACQ_SRC, "Flt_Acq")
        };
        class Eng {
            condition = C_COND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_ENG));
            MPD_ACQ_SRC(Acq, MFD_IND_ENG_ACQ_BOX, MFD_TEXT_IND_ENG_ACQ_SRC, "Eng_Acq")
        };
        class Wpn {
            condition = C_COND(C_AND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_WPN), C_NOT(C_EQ(C_MPD_USER(MFD_IND_WPN_SELECTED_WPN), 2))));
            MPD_ACQ_SRC(Acq, MFD_IND_WPN_ACQ_BOX, MFD_TEXT_IND_WPN_ACQ_SRC, "Wpn_Acq")
        };
        class Tsd {
            condition = C_COND(C_AND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_TSD), C_EQ(C_MPD_USER(MFD_IND_TSD_SUBPAGE), 0)));
            MPD_ACQ_SRC(Acq, MFD_IND_TSD_ACQ_BOX, MFD_TEXT_IND_TSD_ACQ_SRC, "Tsd_Acq")
        };
        class Fcr {
            condition = C_COND(C_OR(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_FCR), C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_FCRRMAP)));
            MPD_ACQ_SRC(Acq, MFD_IND_FCR_ACQ_BOX, MFD_TEXT_IND_FCR_ACQ_SRC, "Fcr_Acq")
        };
    };
    // Last, so it is drawn over the page: the ACQ list of the pages with an ACQ button
    class AcqMenu {
        condition = C_COND(C_AND(C_EQ(C_USER(MFD_IND_ACQ_OPEN), 1), C_OR(C_OR(C_OR(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_FLT), C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_ENG)), C_OR(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_WPN), C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_TSD))), C_OR(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_FCR), C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_FCRRMAP)))));
        #include "pages\acq_menu.hpp"
    };
#ifdef MPD_MASK_PASS
};
#endif
};
