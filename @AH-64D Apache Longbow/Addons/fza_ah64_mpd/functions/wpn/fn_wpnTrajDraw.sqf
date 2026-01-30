params["_heli", "_mpdIndex", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _popOutMenu = _state get "popOutMenu";
private _traj = _heli getVariable "fza_ah64_hellfireTrajectory";
if (_traj isEqualTo "DIR") then {_traj = 1;};
if (_traj isEqualTo "LO") then {_traj = 2;};
if (_traj isEqualTo "HI") then {_traj = 3;};

_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_WPN_POPOUT_MENU), _popOutMenu];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_WPN_POPOUT), _traj];