params["_heli", "_mpdIndex", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_WPT_VARIANT), _state get "subPageVarPage" select 1];
_heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_WPT_CURRENT_POINT),
    (_heli getVariable "fza_mpd_tsdWptCurrentSel") call fza_dms_fnc_pointToString];

private _variant = _state get "subPageVarPage" select 1;
switch (_variant) do {
    case 1: {
        _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_WPT_ADD_TYPE), _state get "wptAddType"];
    };
};
