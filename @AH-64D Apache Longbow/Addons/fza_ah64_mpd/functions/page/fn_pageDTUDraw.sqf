params ["_heli", "_mpdIndex", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_mpd\headers\tsd.hpp"
#include "\fza_ah64_dms\headers\constants.h"

[_heli, MFD_INDEX_OFFSET(MFD_IND_DTU_SUBPAGE), _state get "subPage"] call fza_mpd_fnc_updateMfdValue;
[_heli, MFD_INDEX_OFFSET(MFD_IND_DTU_LOAD_STATUS), _state get "loadState"] call fza_mpd_fnc_updateMfdValue;

date params ["_year", "_month", "_day"];
private _dtuDate = ([([str _month, "00"] call fza_fnc_padString), ([str _day, "00"] call fza_fnc_padString),str (_year % 100)]) joinString "/";
[_heli, MFD_INDEX_OFFSET(MFD_TEXT_DTU_DATE), _dtuDate] call fza_mpd_fnc_updateMfdText;