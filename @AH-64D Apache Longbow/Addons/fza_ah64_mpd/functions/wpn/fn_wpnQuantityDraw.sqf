params["_heli", "_mpdIndex", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _quantityMenu = _state get "popOutMenu";

[_heli, MFD_INDEX_OFFSET(MFD_IND_WPN_POPOUT_MENU), _quantityMenu] call fza_mpd_fnc_updateMfdValue;
[_heli, MFD_INDEX_OFFSET(MFD_IND_WPN_POPOUT), (_heli getVariable "fza_ah64_rocketsalvo")] call fza_mpd_fnc_updateMfdValue;