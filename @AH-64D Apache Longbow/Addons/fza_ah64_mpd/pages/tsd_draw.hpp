class Root {
    condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_SUBPAGE), 0));
    #include "tsd\root.hpp"
};

class Show {
    condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_SUBPAGE), 1));
    #include "tsd\show.hpp"
};

class Wpt {
    condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_SUBPAGE), 2));
    #include "tsd\wpt\common.hpp"

    class WptRoot {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_WPT_VARIANT), 0));
        #include "tsd\wpt\root.hpp"
    };
    //ADD sub page
    class WptAdd {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_WPT_VARIANT), 1));
        #include "tsd\wpt\add.hpp"
    };
    //DEL sub page
    class WptDelNoPointSel {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_WPT_VARIANT), 2));
        #include "tsd\wpt\delNoPointSel.hpp"
    };
    class WptDelPointSel {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_WPT_VARIANT), 3));
        #include "tsd\wpt\delPointSel.hpp"
    };
    //EDT sub page
    class WptEdtNoPointSel {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_WPT_VARIANT), 4));
        #include "tsd\wpt\edtNoPointSel.hpp"
    };
    class WptEdtPointSel {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_WPT_VARIANT), 5));
        #include "tsd\wpt\edtPointSel.hpp"
    };
    //STO sub page
    class WptSto {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_WPT_VARIANT), 6));
        #include "tsd\wpt\sto.hpp"
    };
    //XMIT sub page
    class WptXmit {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_WPT_VARIANT), 7));
        #include "tsd\wpt\xmit.hpp"
    };
};

class Rte {
    condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_SUBPAGE), 3));
    #include "tsd\rte\root.hpp"
    //ADD sub page
    class Add {

    };
    //DEL sub page
    class Del {

    };
    //DIR sub page
    class Dir {

    };
        //RVW sub page
    class Rvw {

    };
        //RTM sub page
    class Rtm {

    };
};

class Thrt {
    condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_SUBPAGE), 4));
    #include "tsd\thrt\common.hpp"

    class ThrtRoot {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_THRT_VARIANT), 0));
        #include "tsd\thrt\root.hpp"
    };
    //ADD sub page
    class ThrtAdd {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_THRT_VARIANT), 1));
        #include "tsd\thrt\add.hpp"
    };
    //DEL sub page
    class ThrtDelNoPointSel {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_THRT_VARIANT), 2));
        #include "tsd\thrt\delNoPointSel.hpp"
    };
    class ThrtDelPointSel {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_THRT_VARIANT), 3));
        #include "tsd\thrt\delPointSel.hpp"
    };
    //EDT sub page
    class ThrtEdtNoPointSel {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_THRT_VARIANT), 4));
        #include "tsd\thrt\edtNoPointSel.hpp"
    };
    class ThrtEdtPointSel {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_THRT_VARIANT), 5));
        #include "tsd\thrt\edtPointSel.hpp"
    };
    //STO sub page
    class ThrtSto {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_THRT_VARIANT), 6));
        #include "tsd\thrt\sto.hpp"
    };
    //XMIT sub page
    class ThrtXmit {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_THRT_VARIANT), 7));
        #include "tsd\thrt\xmit.hpp"
    };
};