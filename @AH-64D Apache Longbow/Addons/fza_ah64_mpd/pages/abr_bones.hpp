#include "\fza_ah64_mpd\headers\mfdConstants.h"
class ABR_Paging {
    type = linear;
    MPD_NUM_USER(MFD_IND_ABR_PAGE)
    min=1;
    max=MFD_ABR_NUMPAGES;
    maxPos[]={0,0};
    minPos[]={-MFD_ABR_NUMPAGES + 1,0};
};