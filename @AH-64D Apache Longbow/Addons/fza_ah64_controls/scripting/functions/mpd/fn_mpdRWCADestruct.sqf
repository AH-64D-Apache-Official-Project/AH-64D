#include "\fza_ah64_controls\headers\selections.h"
params ["_heli"];

_heli setobjecttexture [SEL_PR_MPD_BACK, ""];

for "_i" from 0 to 25 do {
	_heli setobjecttexture [SEL_PR_WCA_1 + _i, ""];
	_heli setobjecttexture [SEL_GR_WCA_1 + _i, ""];
}