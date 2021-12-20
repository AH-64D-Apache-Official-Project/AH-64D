params["_heli", "_mpdIndex", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_mpd\headers\tsd.hpp"
#include "\fza_ah64_mpd\headers\points.hpp"
#include "\fza_ah64_dms\headers\constants.h"

private _phase = BOOLTONUM(_heli getVariable "fza_mpd_tsdMode" == "atk");

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_PHASE), _phase];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SUBPAGE), _state get "subPageVarPage" select 0];

//Show options

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_HSI),  BOOLTONUM(_heli getVariable "fza_mpd_tsdShowHsi" select _phase)];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_WIND), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowWind" select _phase)];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_ENDR), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowEndr" select _phase)];

if (_heli getVariable "fza_mpd_tsdMode" == "atk") then {
    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_WPT_DATA_CURRTE), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowAtkCurrRoute")];
} else {
    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_WPT_DATA_CURRTE), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowNavWptData")];
};
switch (_state get "subPageVarPage" select 0) do {
    case 1: { // Show
        _this call fza_mpd_fnc_tsdShowDraw;
    };
    case 2: {
        _this call fza_mpd_fnc_tsdWptDraw;
    }
};

private _pointsArray = [];

{
    {
        if (_x isEqualTo -1) then {continue;};
        _pointsArray pushBack [MPD_POSMODE_WORLD
            ,_x # POINT_GET_ARMA_POS
            ,_x # POINT_GET_ICON_TEX
            ,MPD_ICON_COLOR_GREEN
            ,MPD_ICON_TYPE_A
            ,_x # POINT_GET_FREE_TEXT
            , ""];
    } forEach (_heli getVariable _x);
} forEach (["fza_dms_waypointsHazards", "fza_dms_controlMeasures", "fza_dms_targetsThreats"]);

[_heli, _pointsArray, _mpdIndex, (0.125 * 5 /5000)] call fza_mpd_fnc_drawIcons;