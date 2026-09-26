#include "\fza_ah64_mpd\headers\mfdConstants.h"
params ["_heli", "_mpdIndex"];

// Gates the L5 "DOOM" button in minigames_draw.hpp - never changes mid-session, but only relevant while this page is open.
private _doomAvailable = BOOLTONUM(isClass (configFile >> "CfgPatches" >> "fza_ah64_doom"));
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_MINIGAMES_DOOM_AVAILABLE), _doomAvailable];
