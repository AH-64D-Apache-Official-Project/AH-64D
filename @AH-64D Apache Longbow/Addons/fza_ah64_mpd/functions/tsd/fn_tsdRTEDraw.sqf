params["_heli", "_mpdIndex", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _variant = _state get "subPageVarPage" select 1;

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_RTE_VARIANT), _variant];

switch (_variant) do {
    case 3;
    case 4: {
        private _curPoint = _heli getVariable "fza_dms_routeNext";
        _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_RTE_DIR_CURWPT),
            _curPoint call fza_dms_fnc_pointToString];
    };
};