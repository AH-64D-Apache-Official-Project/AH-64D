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