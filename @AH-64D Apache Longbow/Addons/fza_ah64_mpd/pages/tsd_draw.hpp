class Root {
    condition = __EVAL(format [STRINGIFY(EQ(user%1, 0)), MFD_OFFSET + MFD_IND_TSD_SUBPAGE]);
    #include "tsd\root.hpp"
};

class Show {
    condition = __EVAL(format [STRINGIFY(EQ(user%1, 1)), MFD_OFFSET + MFD_IND_TSD_SUBPAGE]);
    #include "tsd\show.hpp"
};

class Wpt {
    condition = __EVAL(format [STRINGIFY(EQ(user%1, 2)), MFD_OFFSET + MFD_IND_TSD_SUBPAGE]);
    #include "tsd\wpt\common.hpp"

    class WptRoot {
        condition = __EVAL(format [STRINGIFY(EQ(user%1, 0)), MFD_OFFSET + MFD_IND_TSD_WPT_VARIANT]);
        #include "tsd\wpt\root.hpp"
    };
    //ADD sub page
    class WptAdd {
        condition = __EVAL(format [STRINGIFY(EQ(user%1, 1)), MFD_OFFSET + MFD_IND_TSD_WPT_VARIANT]);
        #include "tsd\wpt\add.hpp"
    };
    //DEL sub page
    class WptDelNoPointSel {
        condition = __EVAL(format [STRINGIFY(EQ(user%1, 2)), MFD_OFFSET + MFD_IND_TSD_WPT_VARIANT]);
        #include "tsd\wpt\delNoPointSel.hpp"
    };
    class WptDelPointSel {
        condition = __EVAL(format [STRINGIFY(EQ(user%1, 3)), MFD_OFFSET + MFD_IND_TSD_WPT_VARIANT]);
        #include "tsd\wpt\delPointSel.hpp"
    };
    //EDT sub page
    class WptEdtNoPointSel {
        condition = __EVAL(format [STRINGIFY(EQ(user%1, 4)), MFD_OFFSET + MFD_IND_TSD_WPT_VARIANT]);
        #include "tsd\wpt\edtNoPointSel.hpp"
    };
    class WptEdtPointSel {
        condition = __EVAL(format [STRINGIFY(EQ(user%1, 5)), MFD_OFFSET + MFD_IND_TSD_WPT_VARIANT]);
        #include "tsd\wpt\edtPointSel.hpp"
    };
    //STO sub page
    class WptSto {
        condition = __EVAL(format [STRINGIFY(EQ(user%1, 6)), MFD_OFFSET + MFD_IND_TSD_WPT_VARIANT]);
        #include "tsd\wpt\sto.hpp"
    };
    //XMIT sub page
    class WptXmit {
        condition = __EVAL(format [STRINGIFY(EQ(user%1, 7)), MFD_OFFSET + MFD_IND_TSD_WPT_VARIANT]);
        #include "tsd\wpt\xmit.hpp"
    };
};

class Rte {
    condition = __EVAL(format [STRINGIFY(EQ(user%1, 3)), MFD_OFFSET + MFD_IND_TSD_SUBPAGE]);
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
    condition = __EVAL(format [STRINGIFY(EQ(user%1, 4)), MFD_OFFSET + MFD_IND_TSD_SUBPAGE]);
    #include "tsd\thrt\common.hpp"

    class ThrtRoot {
        condition = __EVAL(format [STRINGIFY(EQ(user%1, 0)), MFD_OFFSET + MFD_IND_TSD_THRT_VARIANT]);
        #include "tsd\thrt\root.hpp"
    };
    //ADD sub page
    class ThrtAdd {
        condition = __EVAL(format [STRINGIFY(EQ(user%1, 1)), MFD_OFFSET + MFD_IND_TSD_THRT_VARIANT]);
        #include "tsd\thrt\add.hpp"
    };
    //DEL sub page
    class ThrtDelNoPointSel {
        condition = __EVAL(format [STRINGIFY(EQ(user%1, 2)), MFD_OFFSET + MFD_IND_TSD_THRT_VARIANT]);
        #include "tsd\thrt\delNoPointSel.hpp"
    };
    class ThrtDelPointSel {
        condition = __EVAL(format [STRINGIFY(EQ(user%1, 3)), MFD_OFFSET + MFD_IND_TSD_THRT_VARIANT]);
        #include "tsd\thrt\delPointSel.hpp"
    };
    //EDT sub page
    class ThrtEdtNoPointSel {
        condition = __EVAL(format [STRINGIFY(EQ(user%1, 4)), MFD_OFFSET + MFD_IND_TSD_THRT_VARIANT]);
        #include "tsd\thrt\edtNoPointSel.hpp"
    };
    class ThrtEdtPointSel {
        condition = __EVAL(format [STRINGIFY(EQ(user%1, 5)), MFD_OFFSET + MFD_IND_TSD_THRT_VARIANT]);
        #include "tsd\thrt\edtPointSel.hpp"
    };
    //STO sub page
    class ThrtSto {
        condition = __EVAL(format [STRINGIFY(EQ(user%1, 6)), MFD_OFFSET + MFD_IND_TSD_THRT_VARIANT]);
        #include "tsd\thrt\sto.hpp"
    };
    //XMIT sub page
    class ThrtXmit {
        condition = __EVAL(format [STRINGIFY(EQ(user%1, 7)), MFD_OFFSET + MFD_IND_TSD_THRT_VARIANT]);
        #include "tsd\thrt\xmit.hpp"
    };
};