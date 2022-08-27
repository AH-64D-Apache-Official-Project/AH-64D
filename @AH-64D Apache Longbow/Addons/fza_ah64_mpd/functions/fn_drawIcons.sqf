/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_drawIcons

Description:
	Draws the points inputted on the right hand MPD, performing all necessary positioning

Parameters:
	_heli - The helicopter to draw this on (the player mmpdt be in it)
	_points - the points to draw on the screen. An array with arrays in it that fit the following schema
	    [_posMode, _pos, _tex, _color, _textMode, _text1, _text2]
		where:
		    _posMode is how to read the position, either MPD_POSMODE_WORLD or MPD_POSMODE_SCREEN
			_pos is 2d position of the point, in the aforementioned mode
			_tex is the texture to apply to the centre of the point
			_color is the color to apply (MPD_ICON_COLOR_GREEN .. MPD_ICON_COLOR_YELLOW)
			_textMode is the text mode (MPD_ICON_TYPE_A .. G)
			_text1 is the first part of text
			_text2 is the second part of text, where applicable
	_display - 1 if right, 0 if left
	_scale - (optional) Ratio to apply to scale from the world's size to the MPD size. Defaults to *fza_ah64_rangesetting x 0.75*
	_center - (optional) Where in the screen should be where the "helicopter" should be when converting from world. Defaults to [0.5, 0.25]

Returns:
	Nothing

Examples:

Author:
	mattysmith22
---------------------------------------------------------------------------- */
params ["_heli", "_points", "_display", ["_scale", -1], ["_center", [0.5, 0.75]], ["_heading", direction (_this # 0)], ["_heliPos", getPosASL (_this # 0)]];
#include "\fza_ah64_controls\headers\selections.h"
#include "\fza_ah64_dms\headers\constants.h"

private _validChars = createHashmapFromArray [
	[[MPD_ICON_COLOR_CYAN, "0"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\0_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "1"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\1_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "2"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\2_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "3"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\3_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "4"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\4_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "5"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\5_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "6"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\6_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "7"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\7_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "8"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\8_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "9"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\9_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "A"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\A_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "B"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\B_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "C"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\C_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "D"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\D_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "E"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\E_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "F"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\F_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "G"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\G_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "H"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\H_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "I"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\I_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "J"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\J_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "K"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\K_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "L"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\L_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "M"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\M_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "N"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\N_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "O"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\O_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "P"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\P_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "Q"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\Q_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "R"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\R_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "S"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\S_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "T"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\T_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "U"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\U_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "V"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\V_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "W"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\W_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "X"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\X_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "Y"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\Y_ca.paa"],
	[[MPD_ICON_COLOR_CYAN, "Z"], "\fza_ah64_mpd\font\BMKApacheFontTextures\cyan\Z_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "0"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\0_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "1"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\1_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "2"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\2_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "3"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\3_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "4"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\4_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "5"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\5_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "6"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\6_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "7"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\7_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "8"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\8_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "9"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\9_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "A"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\A_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "B"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\B_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "C"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\C_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "D"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\D_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "E"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\E_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "F"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\F_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "G"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\G_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "H"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\H_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "I"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\I_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "J"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\J_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "K"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\K_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "L"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\L_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "M"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\M_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "N"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\N_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "O"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\O_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "P"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\P_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "Q"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\Q_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "R"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\R_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "S"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\S_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "T"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\T_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "U"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\U_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "V"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\V_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "W"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\W_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "X"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\X_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "Y"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\Y_ca.paa"],
	[[MPD_ICON_COLOR_GREEN, "Z"], "\fza_ah64_mpd\font\BMKApacheFontTextures\green\Z_ca.paa"],
	[[MPD_ICON_COLOR_RED, "0"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\0_ca.paa"],
	[[MPD_ICON_COLOR_RED, "1"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\1_ca.paa"],
	[[MPD_ICON_COLOR_RED, "2"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\2_ca.paa"],
	[[MPD_ICON_COLOR_RED, "3"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\3_ca.paa"],
	[[MPD_ICON_COLOR_RED, "4"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\4_ca.paa"],
	[[MPD_ICON_COLOR_RED, "5"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\5_ca.paa"],
	[[MPD_ICON_COLOR_RED, "6"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\6_ca.paa"],
	[[MPD_ICON_COLOR_RED, "7"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\7_ca.paa"],
	[[MPD_ICON_COLOR_RED, "8"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\8_ca.paa"],
	[[MPD_ICON_COLOR_RED, "9"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\9_ca.paa"],
	[[MPD_ICON_COLOR_RED, "A"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\A_ca.paa"],
	[[MPD_ICON_COLOR_RED, "B"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\B_ca.paa"],
	[[MPD_ICON_COLOR_RED, "C"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\C_ca.paa"],
	[[MPD_ICON_COLOR_RED, "D"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\D_ca.paa"],
	[[MPD_ICON_COLOR_RED, "E"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\E_ca.paa"],
	[[MPD_ICON_COLOR_RED, "F"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\F_ca.paa"],
	[[MPD_ICON_COLOR_RED, "G"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\G_ca.paa"],
	[[MPD_ICON_COLOR_RED, "H"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\H_ca.paa"],
	[[MPD_ICON_COLOR_RED, "I"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\I_ca.paa"],
	[[MPD_ICON_COLOR_RED, "J"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\J_ca.paa"],
	[[MPD_ICON_COLOR_RED, "K"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\K_ca.paa"],
	[[MPD_ICON_COLOR_RED, "L"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\L_ca.paa"],
	[[MPD_ICON_COLOR_RED, "M"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\M_ca.paa"],
	[[MPD_ICON_COLOR_RED, "N"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\N_ca.paa"],
	[[MPD_ICON_COLOR_RED, "O"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\O_ca.paa"],
	[[MPD_ICON_COLOR_RED, "P"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\P_ca.paa"],
	[[MPD_ICON_COLOR_RED, "Q"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\Q_ca.paa"],
	[[MPD_ICON_COLOR_RED, "R"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\R_ca.paa"],
	[[MPD_ICON_COLOR_RED, "S"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\S_ca.paa"],
	[[MPD_ICON_COLOR_RED, "T"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\T_ca.paa"],
	[[MPD_ICON_COLOR_RED, "U"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\U_ca.paa"],
	[[MPD_ICON_COLOR_RED, "V"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\V_ca.paa"],
	[[MPD_ICON_COLOR_RED, "W"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\W_ca.paa"],
	[[MPD_ICON_COLOR_RED, "X"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\X_ca.paa"],
	[[MPD_ICON_COLOR_RED, "Y"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\Y_ca.paa"],
	[[MPD_ICON_COLOR_RED, "Z"], "\fza_ah64_mpd\font\BMKApacheFontTextures\red\Z_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "0"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\0_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "1"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\1_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "2"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\2_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "3"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\3_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "4"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\4_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "5"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\5_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "6"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\6_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "7"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\7_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "8"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\8_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "9"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\9_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "A"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\A_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "B"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\B_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "C"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\C_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "D"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\D_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "E"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\E_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "F"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\F_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "G"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\G_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "H"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\H_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "I"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\I_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "J"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\J_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "K"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\K_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "L"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\L_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "M"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\M_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "N"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\N_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "O"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\O_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "P"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\P_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "Q"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\Q_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "R"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\R_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "S"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\S_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "T"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\T_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "U"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\U_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "V"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\V_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "W"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\W_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "X"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\X_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "Y"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\Y_ca.paa"],
	[[MPD_ICON_COLOR_WHITE, "Z"], "\fza_ah64_mpd\font\BMKApacheFontTextures\white\Z_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "0"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\0_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "1"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\1_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "2"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\2_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "3"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\3_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "4"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\4_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "5"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\5_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "6"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\6_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "7"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\7_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "8"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\8_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "9"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\9_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "A"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\A_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "B"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\B_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "C"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\C_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "D"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\D_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "E"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\E_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "F"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\F_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "G"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\G_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "H"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\H_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "I"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\I_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "J"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\J_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "K"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\K_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "L"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\L_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "M"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\M_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "N"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\N_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "O"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\O_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "P"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\P_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "Q"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\Q_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "R"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\R_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "S"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\S_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "T"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\T_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "U"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\U_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "V"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\V_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "W"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\W_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "X"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\X_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "Y"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\Y_ca.paa"],
	[[MPD_ICON_COLOR_YELLOW, "Z"], "\fza_ah64_mpd\font\BMKApacheFontTextures\yellow\Z_ca.paa"]
];

_scale = (0.125 * 5 / (_heli getVariable "fza_ah64_rangesetting"));

#define MPD_X_MIN 0.1
#define MPD_X_MAX 0.9
#define MPD_Y_MIN 0.1
#define MPD_Y_MAX 0.9

private _pointsWithPos = _points apply {
	private _pos = _x # 1;
	private _theta = [_heli, _heliPos # 0, _heliPos # 1,  _pos # 0, _pos # 1, _heading] call fza_fnc_relativeDirection;
	if (_x # 0) then {
		private _targxpos = _center # 0 + (sin _theta) * ((_heliPos distance2D _pos) * _scale);
		private _targypos = _center # 1 - (cos _theta) * ((_heliPos distance2D _pos) * _scale);
		_pos = [_targxpos, _targypos];
	};

	[_pos, _x];
};

private _filter = {
	(_x # 0) params ["_tx", "_ty"];
	(MPD_X_MIN < _tx && _tx < MPD_X_MAX && MPD_Y_MIN < _ty && _ty < MPD_Y_MAX);
};

_pointsWithPos = [_pointsWithPos, [_heli], {_center distance2D _x # 0}, "ASCEND", _filter] call BIS_fnc_sortBy;

#define SETTEXTURE(_ind, _tex) _heli setObjectTexture [_ind, _tex]
#define SETICONTEXTURE(_ind, _tex) SETTEXTURE(_ind + _offset, _tex)

private _prefix = [["pl", "pr"] select _display, ["cl", "cr"] select _display] select (gunner _heli == player);

private _writeText = {
	params ["_heli", "_offset", "_inds", "_text", "_color", "_rightJmpdtified"];
	private _textLen = count _text;
	if (_rightJmpdtified) then {
		_text = reverse _text;
		reverse _inds;
	};
	{
		if (_forEachIndex >= _textLen) then {
			SETICONTEXTURE(_x, "");
			continue;
		};
		private _char = _text select [_forEachIndex,1];
		private _tex = _validChars getOrDefault [[_color, _char], ""];
		SETICONTEXTURE(_x, _tex);
	} forEach _inds;
};

private _displayOffset = [0, 512] select _display;

for "_i" from 0 to 31 do {
	private _offset = (_i * 16) + _displayOffset;
	if (_i >= count _pointsWithPos) then {
		//Wipe all textures
		SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT01, "");
		SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT02, "");
		SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT03, "");
		SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT04, "");
		SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT05, "");
		SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT06, "");
		SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT07, "");
		SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT08, "");
		SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT09, "");
		SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT10, "");
		SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT11, "");
		SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT12, "");
		SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT13, "");
		SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT14, "");
		SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT15, "");
		SETICONTEXTURE(SEL_MPD_OBJ1_ICON, "");
		continue;
	};
	private _pos = _pointsWithPos # _i # 0;
	_pointsWithPos # _i # 1 params ["","", "_tex", "_color", "_textMode", "_text1", "_text2"];
	// Set point texture
	SETICONTEXTURE(SEL_MPD_OBJ1_ICON, _tex);

	// Set point position
	_heli animate [format ["%1_mpdObj%2%3_x", _prefix, ["", "0"] select (_i < 8), _i + 1], _pos # 0];
	_heli animate [format ["%1_mpdObj%2%3_y", _prefix, ["", "0"] select (_i < 8), _i + 1], _pos # 1];

	switch (_textMode) do {
		case MPD_ICON_TYPE_A : {
			//[_heli, _offset, _inds, _text1, _rightJmpdtified] call _writeText;
			[_heli, _offset, [SEL_MPD_OBJ1_DIGIT01, SEL_MPD_OBJ1_DIGIT02, SEL_MPD_OBJ1_DIGIT03], _text1, _color, true] call _writeText;
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT04, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT05, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT06, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT07, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT08, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT09, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT10, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT11, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT12, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT13, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT14, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT15, "");
		};
		case MPD_ICON_TYPE_B : {
			[_heli, _offset, [SEL_MPD_OBJ1_DIGIT09, SEL_MPD_OBJ1_DIGIT10, SEL_MPD_OBJ1_DIGIT11], _text1, _color, false] call _writeText;
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT01, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT02, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT03, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT04, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT05, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT06, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT07, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT08, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT12, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT13, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT14, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT15, "");
		};
		case MPD_ICON_TYPE_C : {
			[_heli, _offset, [SEL_MPD_OBJ1_DIGIT14, SEL_MPD_OBJ1_DIGIT15], _text1, _color, false] call _writeText;
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT01, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT02, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT03, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT04, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT05, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT06, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT07, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT08, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT09, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT10, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT11, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT12, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT13, "");
		};
		case MPD_ICON_TYPE_D : {
			[_heli, _offset, [SEL_MPD_OBJ1_DIGIT01, SEL_MPD_OBJ1_DIGIT02, SEL_MPD_OBJ1_DIGIT03], _text1, _color, true] call _writeText;
			[_heli, _offset, [SEL_MPD_OBJ1_DIGIT04, SEL_MPD_OBJ1_DIGIT05, SEL_MPD_OBJ1_DIGIT06], _text2, _color, false] call _writeText;
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT07, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT08, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT09, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT10, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT11, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT12, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT13, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT14, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT15, "");
		};
		case MPD_ICON_TYPE_E : {
			[_heli, _offset, [SEL_MPD_OBJ1_DIGIT04, SEL_MPD_OBJ1_DIGIT05, SEL_MPD_OBJ1_DIGIT06], _text1, _color, false] call _writeText;
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT01, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT02, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT03, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT07, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT08, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT09, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT10, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT11, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT12, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT13, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT14, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT15, "");
		};
		case MPD_ICON_TYPE_F : {
			[_heli, _offset, [SEL_MPD_OBJ1_DIGIT12, SEL_MPD_OBJ1_DIGIT13], _text1, _color, false] call _writeText;
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT01, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT02, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT03, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT04, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT05, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT06, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT09, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT07, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT08, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT10, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT11, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT14, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT15, "");
		};
		case MPD_ICON_TYPE_G : {
			[_heli, _offset, [SEL_MPD_OBJ1_DIGIT07, SEL_MPD_OBJ1_DIGIT08], _text1, _color, false] call _writeText;
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT01, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT02, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT03, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT04, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT05, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT06, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT09, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT10, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT11, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT12, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT13, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT14, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT15, "");
		};
		case MPD_ICON_TYPE_H : {
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT01, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT02, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT03, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT04, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT05, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT06, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT07, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT08, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT09, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT10, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT11, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT12, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT13, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT14, "");
			SETICONTEXTURE(SEL_MPD_OBJ1_DIGIT15, "");
		};
		default {
			["Invalid text type %1", _textMode] call BIS_fnc_error;
		};
	};
};