params ["_heli", "_mpdIndex", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_mpd\headers\tsd.hpp"
#include "\fza_ah64_dms\headers\constants.h"

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_DTU_SUBPAGE), _state get "subPage"];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_DTU_LOAD_STATUS), _state get "loadState"];

date params ["_year", "_month", "_day", "_hours", "_minutes"];
private _dtuDate = str _month + "/" + str _day + "/" + ((str _year) select [2,2]);
if (_heli animationPhase "msn_equip_british" == 1) then {
    _dtuDate = str _day + "/" + str _month + "/" + ((str _year) select [2,2]);
};
_heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_DTU_DATE), _dtuDate];