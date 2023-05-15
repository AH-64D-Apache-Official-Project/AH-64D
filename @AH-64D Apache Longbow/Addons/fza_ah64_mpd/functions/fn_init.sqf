#include "\fza_ah64_dms\headers\constants.h"
params ["_heli"];

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

_heli setVariable ["fza_mpd_mpdState", [["Off", 0, {}, createHashMap, createHashMap, {}, 0], ["Off", 0, {}, createHashMap, createHashMap, {}, 0]]];

_heli setObjectTexture ["plt_pl_mpd_back", "#(rgb,1024,1024,1)uiEx(display:RscFzaAH64MPD,uniqueName:left)"];
_heli setObjectTexture ["plt_pr_mpd_back", "#(rgb,1024,1024,1)uiEx(display:RscFzaAH64MPD,uniqueName:right)"];
_heli setObjectTexture ["cpg_cl_mpd_back", "#(rgb,1024,1024,1)uiEx(display:RscFzaAH64MPD,uniqueName:left)"];
_heli setObjectTexture ["cpg_cr_mpd_back", "#(rgb,1024,1024,1)uiEx(display:RscFzaAH64MPD,uniqueName:right)"];