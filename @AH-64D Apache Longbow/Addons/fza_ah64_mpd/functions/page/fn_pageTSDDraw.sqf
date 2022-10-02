params["_heli", "_mpdIndex", "_state", "_persistState"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_mpd\headers\tsd.hpp"
#include "\fza_ah64_dms\headers\constants.h"

private _phase = BOOLTONUM(_persistState get "mode" == "atk");

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_PHASE), _phase];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SUBPAGE), _state get "subPageVarPage" select 0];

//Show options
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SCALE_BOXES), _heli getVariable "fza_ah64_rangesetting"];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_HSI),  BOOLTONUM(_heli getVariable "fza_mpd_tsdShowHsi" select _phase)];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_WIND), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowWind" select _phase)];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_ENDR), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowEndr" select _phase)];

//ASE footprint
private _rlwrPwr = BOOLTONUM(_heli getVariable "fza_ah64_ase_rlwrPwr" == "off");
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_ASE_FOOTPRINT), _rlwrPwr];

//TSD Centering
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_TSD_CTR), _persistState get "ctr"];

//TSD phase
if (_persistState get "mode" == "atk") then {
    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_WPT_DATA_CURRTE), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowAtkCurrRoute")];
} else {
    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_WPT_DATA_CURRTE), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowNavWptData")];
};
switch (_state get "subPageVarPage" select 0) do {
    case 0: { //Root
        [_heli, true] call fza_mpd_fnc_tsdWaypointStatusText params ["_waypointId", "_groundspeed", "_waypointDist", "_waypointEta"];
        [_heli] call fza_mpd_fnc_fuelGetData params ["", "", "", "", "", "", "_enduranceNumber"];
        _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ROOT_WPDEST), _waypointId];
        _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ROOT_WPDIST), _waypointDist];
        _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ROOT_WPETA),  _waypointEta];
        _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ROOT_GROUNDSPEED), _groundSpeed];
        
        _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ROOT_ENDR), _enduranceNumber]
    };
    case 1: {   //SHOW
        _this call fza_mpd_fnc_tsdShowDraw;
    };
    case 2: {   //WPT
        _this call fza_mpd_fnc_tsdWptDraw;
    };
    case 3: {   //RTE
        _this call fza_mpd_fnc_tsdRteDraw;
    };
    case 4: {   //THRT
        _this call fza_mpd_fnc_tsdThrtDraw;
    };
};

private _pointsArray = [];
{
    {
        if (_x isEqualTo -1) then {continue;};
        _pointsArray pushBack (_x select [0,7]);
    } forEach (_heli getVariable _x);
} forEach (["fza_dms_waypointsHazards", "fza_dms_controlMeasures", "fza_dms_targetsThreats"]);



[_heli, _pointsArray, _mpdIndex, -1, [0.5, 0.75 - 0.25 * (_persistState get "ctr")]] call fza_mpd_fnc_drawIcons;