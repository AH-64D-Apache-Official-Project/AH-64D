#include "\fza_ah64_controls\headers\selections.h"
params ["_heli"];

CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PR_TSD_HDG);
CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PR_FCRAG_TNUM);

_heli setobjecttexture [SEL_MPD_PR_MPD_HAD_MSG1, ""];
_heli setobjecttexture [SEL_MPD_PR_FCRAG_WIPER, ""];
_heli setobjecttexture [SEL_MPD_PR_MPD_HAD_APOS, ""];
_heli setobjecttexture [SEL_MPD_PR_MPD_HAD_APOS2, ""];
_heli setobjecttexture [SEL_MPD_PR_FCRAA_WIPER, ""];
_heli setobjecttexture [SEL_PR_MPD_BACK, ""];

for "_i" from SEL_MPD_PL_OBJ1 to SEL_MPD_PL_OBJ32 do {
	_heli setObjectTexture [_i, ""];
}

for "_i" from SEL_MPD_GR_OBJ1 to SEL_MPD_GR_OBJ32 do {
	_heli setObjectTexture [_i, ""];
}