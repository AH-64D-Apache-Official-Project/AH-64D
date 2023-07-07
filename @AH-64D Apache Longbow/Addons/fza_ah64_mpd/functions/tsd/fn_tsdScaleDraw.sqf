params["_heli", "_mpdIndex", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_ROOT_SHOW_SCALE), BOOLTONUM(_heli getVariable "fza_ah64_showScale")];