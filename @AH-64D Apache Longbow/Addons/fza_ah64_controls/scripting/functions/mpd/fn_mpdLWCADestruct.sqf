#include "\fza_ah64_controls\headers\selections.h"
params ["_heli"];

_heli setobjecttexture [SEL_PL_MPD_BACK, ""];

for "_i" from 0 to 25 do {
	_heli setobjecttexture [SEL_PL_WCA_1 + _i, ""];
	_heli setobjecttexture [SEL_GL_WCA_1 + _i, ""];
}