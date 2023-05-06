class Root {
    condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_DTU_SUBPAGE), 0));
    #include "dtu\root.hpp"
};

class LoadStatus {
    condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_DTU_SUBPAGE), 1));
    #include "dtu\loadStatus.hpp"
};