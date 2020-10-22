params ["_heli"];
#include "\fza_ah64_controls\headers\selections.h"

_heli setobjecttexture [SEL_PL_MPD_BACK, ""];
_heli setobjecttexture [SEL_MPD_PL_FLT_BANK, ""];
_heli setobjecttexture [SEL_MPD_PL_FLT_HDG, ""];
_heli setobjecttexture [SEL_MPD_PL_FLT_HDG2, ""];
_heli setobjecttexture [SEL_MPD_PL_FLT_HOR, ""];
_heli setobjecttexture [SEL_MPD_PL_FLT_RALTB, ""];
_heli setobjecttexture [SEL_MPD_PL_FLT_RDR, ""];
_heli setobjecttexture [SEL_MPD_PL_FLT_SLIP, ""];
_heli setobjecttexture [SEL_MPD_PL_FLT_TTG4, ""];
_heli setobjecttexture [SEL_MPD_PL_FLT_TURN, ""];
_heli setobjecttexture [SEL_MPD_PL_FLT_VSI, ""];
_heli setobjecttexture [SEL_MPD_PL_FLT_W, ""];
_heli setobjecttexture [SEL_MPD_PL_FLT_WBEAR, ""];
_heli setobjecttexture [SEL_MPD_PL_FLT_DIRB, ""];

CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PL_FLT_BALT);
CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PL_FLT_RALT);
CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PL_FLT_SPD);
CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PL_FLT_GSPD);
CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PL_FLT_TRQ);
CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PL_FLT_WR);
CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PL_FLT_DIR);
CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PL_FLT_TTG);
CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PL_FLT_SPD);
CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PL_FLT_SPD);
CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PL_FLT_SPD);
CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PL_FLT_SPD);
CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PL_FLT_SPD);

_heli setobjecttexture [SEL_MPD_PL_FLT_HI, ""];
_heli setobjecttexture [SEL_MPD_PL_FLT_LO, ""];
_heli setobjecttexture [SEL_MPD_PL_FLT_N20C, ""];
_heli setobjecttexture [SEL_MPD_PL_FLT_P20C, ""];
_heli setobjecttexture [SEL_MPD_PL_FLT_VVI, ""];
_heli setobjecttexture [SEL_MPD_PL_FLT_WP, ""];