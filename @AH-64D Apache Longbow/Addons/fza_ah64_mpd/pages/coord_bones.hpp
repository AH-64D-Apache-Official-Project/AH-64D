#include "\fza_ah64_mpd\headers\mfdConstants.h"
class COORD_Paging {
    type = linear;
    MPD_NUM_USER(MFD_IND_COORD_PAGE)
    min=1;
    max=MFD_COORD_NUMPAGES;
    maxPos[]={0,0};
    minPos[]={-MFD_COORD_NUMPAGES + 1,0};
};