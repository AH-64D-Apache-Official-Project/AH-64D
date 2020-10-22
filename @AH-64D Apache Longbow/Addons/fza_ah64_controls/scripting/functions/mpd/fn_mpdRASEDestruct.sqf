#include "\fza_ah64_controls\headers\selections.h"
params ["_heli"];

_heli setobjecttexture [SEL_PR_MPD_BACK, ""];
_heli setobjecttexture [SEL_MPD_PR_ASE_AUTPG, ""];
_heli setobjecttexture [SEL_MPD_PR_ASE_CC1, ""];
_heli setobjecttexture [SEL_MPD_PR_ASE_CC2, ""];
_heli setobjecttexture [SEL_MPD_PR_ASE_CSEL, ""];
_heli setobjecttexture [SEL_MPD_PR_ASE_DIST1, ""];
_heli setobjecttexture [SEL_MPD_PR_ASE_DIST2, ""];
_heli setobjecttexture [SEL_MPD_PR_ASE_IJAUT, ""];
_heli setobjecttexture [SEL_MPD_PR_ASE_IJOFF, ""];
_heli setobjecttexture [SEL_MPD_PR_ASE_IJON, ""];
_heli setobjecttexture [SEL_MPD_PR_ASE_RJAUT, ""];
_heli setobjecttexture [SEL_MPD_PR_ASE_RJOFF, ""];
_heli setobjecttexture [SEL_MPD_PR_ASE_RJON, ""];
_heli setobjecttexture [SEL_MPD_PR_ASE_SALVO, ""];
_heli setobjecttexture [SEL_MPD_PR_ASE_CSEL, ""];

for "_i" from SEL_MPD_PL_OBJ1 to SEL_MPD_PL_OBJ32 do {
	_heli setObjectTexture [_i, ""];
};

for "_i" from SEL_MPD_GR_OBJ1 to SEL_MPD_GR_OBJ32 do {
	_heli setObjectTexture [_i, ""];
}