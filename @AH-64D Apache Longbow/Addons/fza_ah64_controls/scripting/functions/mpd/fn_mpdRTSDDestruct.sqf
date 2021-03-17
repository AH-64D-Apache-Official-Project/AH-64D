#include "\fza_ah64_controls\headers\selections.h"
params ["_heli"];

_heli setobjecttexture [SEL_MPD_PR_TSD_BASE, ""];
_heli setobjecttexture [SEL_PR_MPD_BACK, ""];
_heli setobjecttexture [SEL_MPD_PR_TSD_FILTER, ""];

_heli setobjecttexture [SEL_MPD_GR_TSD_MMAP, ""];
_heli setobjecttexture [SEL_MPD_PR_TSD_MMAP, ""];
_heli setobjecttexture [SEL_MPD_PR_TSD_IMAP, ""];

CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PR_TSD_HDG);
CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PR_TSD_DIST);
CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PR_TSD_Z);
CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PR_TSD_WTDIR);
CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PR_TSD_PFZS);
CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PR_TSD_WDIR);
CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PR_TSD_WV);
CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PR_TSD_WTDIR);
CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PR_TSD_WTDIR);

_heli setobjecttexture [SEL_MPD_PR_TSD_PHASE, ""];

for "_i" from SEL_MPD_PL_OBJ1 to SEL_MPD_PL_OBJ32 do {
	_heli setObjectTexture [_i, ""];
};

for "_i" from SEL_MPD_GR_OBJ1 to SEL_MPD_GR_OBJ32 do {
	_heli setObjectTexture [_i, ""];
};

if (player == driver _heli || player == gunner _heli) then {
	_seat = ["cpg", "plt"] select (player == driver _heli);
	_heli animateSource [_seat+"_mmap_tx", 0, true];
	_heli animateSource [_seat+"_mmap_ty", 0, true];
	_heli animateSource [_seat+"_mmap_r", 0, true];
	_heli animateSource [_seat+"_mmap_sc", 1 , true];
};