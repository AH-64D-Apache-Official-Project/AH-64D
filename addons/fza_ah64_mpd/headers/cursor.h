#ifndef FZA_AH64_MPD_CURSOR_H
#define FZA_AH64_MPD_CURSOR_H

// Screens a second: from the slowest to the fastest over the ramp time held, each scaled by the input
#define MPD_CURSOR_RATE_MIN 0.15
#define MPD_CURSOR_RATE_MAX 0.9
#define MPD_CURSOR_RAMP     0.6
#define MPD_CURSOR_DEADZONE 0.05

#define MPD_CURSOR_STOW_X    0.05
#define MPD_CURSOR_STOW_Y    0.95
#define MPD_CURSOR_STOW_TIME 180

// How far round its labels a VAB can be chosen, and how often it is looked for while the cursor is still
#define MPD_CURSOR_PICK_PAD   0.01
#define MPD_CURSOR_PICK_EVERY 0.15
// How far from a TSD point the cursor chooses it (fza_mpd_fnc_cursorPoint)
#define MPD_CURSOR_POINT_REACH 0.025
// How far from an FCR target symbol the cursor chooses it, the symbols being larger
#define MPD_CURSOR_TARGET_REACH 0.035
// The radius of the black circle a symbol the cursor would choose is drawn over, just past the cursor's ring
#define MPD_CURSOR_POINT_CIRCLE 0.022
// The size of the cursor's spokes as the TSD draws them under a point it would choose (tex\cursor\spokes_ca.paa)
#define MPD_CURSOR_SPOKES_SIZE 0.1
// FCR display zoom: the zoom box's area shown in a square of this half size about the MPD's centre. The box is sized by
// the scan size, wide to zoom: about 6:1 in wide, more for the smaller scans.
#define MPD_CURSOR_ZOOM_VIEW_HALF 0.36
#define MPD_CURSOR_ZOOM_HALF_W    0.06
#define MPD_CURSOR_ZOOM_HALF_M    0.045
#define MPD_CURSOR_ZOOM_HALF_N    0.035
#define MPD_CURSOR_ZOOM_HALF_Z    0.025

// A label is drawn again this far to its right, and an arrow this wide, to show them bold
#define MPD_CURSOR_BOLD       0.0025
#define MPD_CURSOR_BOLD_WIDTH 5

/* The VAB a label at startX, startY (the top of its text) belongs to, for fza_mpd_fnc_cursorLabels and for its bold copy:
    - L1-L6: text growing right from up to a character in from the left edge, whose top is in the button's band of rows
    - R1-R6: the same from the right edge, growing left
    - T1-T6: text starting at a button (MPD_CURSOR_COL_EDGE), or centred on one (MPD_CURSOR_COL_TOL), in the top row or
      the line below it
    - B1-B6: the same in the bottom row, or the line above it
    The copy is drawn while 100 + its VAB is in its MPD's MFD_IND_CURSOR_VAB, by the conditions below (%1 that user value,
    %2 startX, %3 startY, then 1 or 0 for whether it is at the side edge (%4), on the T row (%5) and on a B row (%6), worked
    out when the config loads, as the game can't multiply comparisons of two numbers); they start with startX, startY and
    the alignment (0 right, 1 centre, 2 left), for fza_mpd_fnc_cursorLabels. Their numbers are the ones here. */
#define MPD_CURSOR_L_MAX_X     0.064
#define MPD_CURSOR_R_MIN_X     0.936
#define MPD_CURSOR_ROWS_TOP    0.08
#define MPD_CURSOR_ROWS_BOTTOM 0.86
#define MPD_CURSOR_ROW_SPLIT   0.2575
#define MPD_CURSOR_ROW_PITCH   0.115
#define MPD_CURSOR_T_MAX_Y     0.0675
#define MPD_CURSOR_B_MIN_Y     0.936
#define MPD_CURSOR_B_MAX_Y     0.944
#define MPD_CURSOR_B2_MIN_Y    0.8925
#define MPD_CURSOR_B2_MAX_Y    0.9065
#define MPD_CURSOR_COL_PITCH   0.12
#define MPD_CURSOR_COL_TOL     0.045
#define MPD_CURSOR_COL_EDGE    0.005

#define MPD_CURSOR_BOLD_R "(0*(%2)*(%3)*0)+((%4)*((%1)>100.5)*((%1)<106.5)*((%3)>(0.1425+0.115*((%1)-101)-0.0625*((%1)<101.5)))*((%3)<(0.2575+0.115*((%1)-101)+0.0275*((%1)>105.5))))+((%5)*((%1)>112.5)*((%1)<118.5)*((%2)>(0.205+0.12*((%1)-113)))*((%2)<(0.215+0.12*((%1)-113))))+((%6)*((%1)>118.5)*((%1)<124.5)*((%2)>(0.205+0.12*((%1)-119)))*((%2)<(0.215+0.12*((%1)-119))))"
#define MPD_CURSOR_BOLD_C "(0*(%2)*(%3)*1)+((%5)*((%1)>112.5)*((%1)<118.5)*((%2)>(0.165+0.12*((%1)-113)))*((%2)<(0.255+0.12*((%1)-113))))+((%6)*((%1)>118.5)*((%1)<124.5)*((%2)>(0.165+0.12*((%1)-119)))*((%2)<(0.255+0.12*((%1)-119))))"
#define MPD_CURSOR_BOLD_L "(0*(%2)*(%3)*2)+((%4)*((%1)>106.5)*((%1)<112.5)*((%3)>(0.1425+0.115*((%1)-107)-0.0625*((%1)<107.5)))*((%3)<(0.2575+0.115*((%1)-107)+0.0275*((%1)>111.5))))+((%5)*((%1)>112.5)*((%1)<118.5)*((%2)>(0.205+0.12*((%1)-113)))*((%2)<(0.215+0.12*((%1)-113))))+((%6)*((%1)>118.5)*((%1)<124.5)*((%2)>(0.205+0.12*((%1)-119)))*((%2)<(0.215+0.12*((%1)-119))))"

#endif
