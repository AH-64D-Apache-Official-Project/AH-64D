params["_heli", "_mpdIndex", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_RTE_VARIANT), _state get "subPageVarPage" select 1];