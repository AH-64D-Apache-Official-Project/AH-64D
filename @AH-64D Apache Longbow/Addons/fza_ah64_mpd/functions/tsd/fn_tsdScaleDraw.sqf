params["_heli", "_mpdIndex", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

[_heli, MFD_INDEX_OFFSET(MFD_IND_TSD_OPEN_POPOUT), BOOLTONUM(_state get "showScale")] call fza_mpd_fnc_updateMfdValue;