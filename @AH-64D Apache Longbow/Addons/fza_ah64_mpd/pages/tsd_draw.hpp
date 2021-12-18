#include "tsd\common.hpp"

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

    class WptAdd {
        condition = __EVAL(format [STRINGIFY(EQ(user%1, 1)), MFD_OFFSET + MFD_IND_TSD_WPT_VARIANT]);
        #include "tsd\wpt\add.hpp"
    };
    
    class WptDel {
        condition = __EVAL(format [STRINGIFY(EQ(user%1, 2)), MFD_OFFSET + MFD_IND_TSD_WPT_VARIANT]);
        #include "tsd\wpt\del.hpp"
    };
};