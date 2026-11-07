#include "\fza_ah64_dms\headers\constants.h"
// Cursor entries for one zone on ZN: the TRP centre, a box's two corners, or four
params ["_persistState"];

if (_persistState getOrDefault ["znType", ZONE_KIND_PF] == ZONE_KIND_PF && {_persistState getOrDefault ["znOpt", 0] == 2}) exitWith {1};
[4, 2] select (_persistState getOrDefault ["znDraw", 0] == 0)
