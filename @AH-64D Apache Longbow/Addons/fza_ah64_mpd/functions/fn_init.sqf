#include "\fza_ah64_dms\headers\constants.h"
params ["_heli"];

if (!(_heli getVariable ["fza_mpd_aircraftInitialised", false]) && local _heli) then {
    _heli setVariable ["fza_mpd_page_plt", ["Off", "Off"], true];
    _heli setVariable ["fza_mpd_page_cpg", ["Off", "Off"], true];
};

_heli setVariable ["fza_mpd_tsdShowHsi", [false, false]];
_heli setVariable ["fza_mpd_tsdShowWind", [true, true]];
_heli setVariable ["fza_mpd_tsdShowEndr", [true, true]];
_heli setVariable ["fza_mpd_tsdShowNavWptData", true];
_heli setVariable ["fza_mpd_tsdShowAtkCurrRoute", false];
_heli setVariable ["fza_mpd_tsdShowEnemy", [false, false]];
_heli setVariable ["fza_mpd_tsdShowFriendly", [false, true]];
_heli setVariable ["fza_mpd_tsdShowRlwr", [true, true]];
_heli setVariable ["fza_mpd_tsdShowPlanTgts", [false, true]];
_heli setVariable ["fza_mpd_tsdShowCtrlMeasures", [true, true]];
_heli setVariable ["fza_mpd_tsdShowAtkShot", true];
_heli setVariable ["fza_mpd_tsdShowAtkHazard", true];

_heli setVariable ["fza_mpd_tsdWptCurrentSel", []];
_heli setVariable ["fza_mpd_tsdThrtCurrentSel", []];
_heli setVariable ["fza_mpd_tsdRteCurrentSel", []];
_heli setVariable ["fza_mpd_tsdRteCurrentRvw", -1];

_heli setVariable ["fza_ah64_routeSelected",          0, true];
_heli setVariable ["fza_ah64_routeData",[[],[],[],[],[],[],[],[],[],[]], true];
_heli setVariable ["fza_ah64_routeCurPoint", -1, true];
_heli setVariable ["fza_ah64_wptAprch", [-1,false], true];
_heli setVariable ["fza_ah64_wptpassed", false, true];

_heli setVariable ["fza_mpd_mpdState", [["Off", 0, {}, {}, createHashMap, createHashMap, {}, 0], ["Off", 0, {}, {}, createHashMap, createHashMap, {}, 0]]];

_heli setObjectTexture ["mpd_back", "#(rgb,2048,2048,1)uiEx(display:RscFzaAH64MPD)"];
