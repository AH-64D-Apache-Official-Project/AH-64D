params["_heli", "_mpdIndex", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _Trajmenu = _state get "Trajmenu";
private _Traj = _heli getVariable "fza_ah64_hellfireTrajectory";
if (_Traj isEqualTo "DIR") then {_traj = 1;};
if (_Traj isEqualTo "LO") then {_traj = 2;};
if (_Traj isEqualTo "HI") then {_traj = 3;};

_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_WPN_MSL_Traj_Menu), _Trajmenu];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_WPN_MSL_Traj), _Traj];