// TGT's store status window on the right (fza_mpd_fnc_fcrTgtDraw): the target file address the next target is stored at,
// boxed, and under it the ones stored since TGT was selected
#define FCR_TGT_LIST_TOP 0.29
#define FCR_TGT_LIST_PITCH 0.04
// The name is given whole: the game does not paste ## into an argument passed on to another macro
#define FCR_TGT_LINE(name, index) MPD_TEXT_BONE_L(name, "Null", MPD_POS_BUTTON_R_X, FCR_TGT_LIST_TOP + 0.005 + index * FCR_TGT_LIST_PITCH, MPD_TEXT_USER(MFD_TEXT_IND_FCR_TGT_LIST_1 + index))

class TgtStoreBoxes {
    type = "line";
    width = 3;
    points[] = {
        MPD_POINTS_BOX("Null", MPD_POS_BUTTON_R_X - 3 * MPD_TEXT_WIDTH, 0.215, 3 * MPD_TEXT_WIDTH, MPD_TEXT_HEIGHT), {},
        MPD_POINTS_BOX("Null", MPD_POS_BUTTON_R_X - 3 * MPD_TEXT_WIDTH, FCR_TGT_LIST_TOP, 3 * MPD_TEXT_WIDTH, MFD_FCR_TGT_LIST_LINES * FCR_TGT_LIST_PITCH + 0.01)
    };
};
MPD_TEXT_BONE_L(TgtNext, "Null", MPD_POS_BUTTON_R_X, 0.215, MPD_TEXT_USER(MFD_TEXT_IND_FCR_TGT_NEXT))
FCR_TGT_LINE(TgtList_0, 0)
FCR_TGT_LINE(TgtList_1, 1)
FCR_TGT_LINE(TgtList_2, 2)
FCR_TGT_LINE(TgtList_3, 3)
FCR_TGT_LINE(TgtList_4, 4)
FCR_TGT_LINE(TgtList_5, 5)
FCR_TGT_LINE(TgtList_6, 6)
FCR_TGT_LINE(TgtList_7, 7)
FCR_TGT_LINE(TgtList_8, 8)
FCR_TGT_LINE(TgtList_9, 9)
FCR_TGT_LINE(TgtList_10, 10)
FCR_TGT_LINE(TgtList_11, 11)

#undef FCR_TGT_LINE
#undef FCR_TGT_LIST_PITCH
#undef FCR_TGT_LIST_TOP
