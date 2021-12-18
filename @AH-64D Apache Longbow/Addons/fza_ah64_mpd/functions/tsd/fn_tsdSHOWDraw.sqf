params["_heli", "_mpdIndex", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _phase = BOOLTONUM(_heli getVariable "fza_mpd_tsdMode" == "atk");

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_ENEMY_UNITS), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowEnemy" select _phase)];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_FRIENDLY_UNITS), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowFriendly" select _phase)];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_RLWR), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowRlwr" select _phase)];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_PLAN_TGTS), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowPlanTgts" select _phase)];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_CTRLM), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowCtrlMeasures" select _phase)];

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_SHOT), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowAtkShot")];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_HAZ), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowAtkHazard")];