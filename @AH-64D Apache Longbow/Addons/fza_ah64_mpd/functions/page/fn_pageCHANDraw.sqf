#include "\fza_ah64_mpd\headers\chan.hpp"
#include "\fza_ah64_mpd\headers\mfdConstants.h"
params ["_heli", "_mpdIndex", "_state", "_persistState"];

private _codeToDisplay = (_heli getVariable "fza_ah64_laserChannelCodes") # ((_persistState get "missileChannel")-1);

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_CHAN_SELECTED), CODES find _codeToDisplay];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_CHAN), (_persistState get "missileChannel")-1];

[_heli, _mpdIndex] call fza_mpd_fnc_chanShowFrequencies;