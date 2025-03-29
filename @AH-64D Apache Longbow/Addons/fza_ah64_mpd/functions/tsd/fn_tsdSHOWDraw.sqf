params["_heli", "_mpdIndex", "_state", "_persistState"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _phase = BOOLTONUM(_persistState get "mode" == "atk");

[_heli, MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_ENEMY_UNITS), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowEnemy" select _phase)] call fza_mpd_fnc_updateMfdValue;
[_heli, MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_FRIENDLY_UNITS), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowFriendly" select _phase)] call fza_mpd_fnc_updateMfdValue;
[_heli, MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_RLWR), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowRlwr" select _phase)] call fza_mpd_fnc_updateMfdValue;
[_heli, MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_PLAN_TGTS), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowPlanTgts" select _phase)] call fza_mpd_fnc_updateMfdValue;
[_heli, MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_CTRLM), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowCtrlMeasures" select _phase)] call fza_mpd_fnc_updateMfdValue;

[_heli, MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_SHOT), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowAtkShot")] call fza_mpd_fnc_updateMfdValue;
[_heli, MFD_INDEX_OFFSET(MFD_IND_TSD_SHOW_HAZ), BOOLTONUM(_heli getVariable "fza_mpd_tsdShowAtkHazard")] call fza_mpd_fnc_updateMfdValue;