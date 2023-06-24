#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_mpdIndex"];

//Pitch
private _pitchOn = BOOLTONUM(_heli getVariable "fza_ah64_fmcPitchOn" == true);
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ACUTIL_PITCH), _pitchOn];
//Roll
private _rollOn  = BOOLTONUM(_heli getVariable "fza_ah64_fmcRollOn" == true);
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ACUTIL_ROLL), _rollOn];
//Yaw
private _yawOn   = BOOLTONUM(_heli getVariable "fza_ah64_fmcYawOn" == true);
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ACUTIL_YAW), _yawOn];
//Coll
private _collOn  = BOOLTONUM(_heli getVariable "fza_ah64_fmcCollOn" == true);
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ACUTIL_COLL), _collOn];
//Trim
private _trimOn  = BOOLTONUM(_heli getVariable "fza_ah64_fmcTrimOn" == true);
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ACUTIL_TRIM), _trimOn];