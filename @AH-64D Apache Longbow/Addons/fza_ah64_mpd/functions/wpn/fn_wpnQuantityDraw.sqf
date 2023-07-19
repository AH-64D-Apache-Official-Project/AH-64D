params["_heli", "_mpdIndex", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _quantityMenu = _state get "popOutMenu";

_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_WPN_POPOUT_MENU), _quantityMenu];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_WPN_POPOUT), (_heli getVariable "fza_ah64_rocketsalvo")];