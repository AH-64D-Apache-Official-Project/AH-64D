// TGT's store status window on the right (fza_mpd_fnc_fcrTgtDraw), from just under the target count box to just above the
// right HAD box: the target file
// address the next target is stored at, boxed, and under it the ones stored since TGT was selected. A Draw class of its
// own after the pages (mpd.hpp), so its black backing hides the format's lines under it
#define FCR_TGT_BOX_X (MPD_POS_BUTTON_R_X - 3 * MPD_TEXT_WIDTH - 0.005)
#define FCR_TGT_BOX_W (3 * MPD_TEXT_WIDTH + 0.01)
#define FCR_TGT_NEXT_TOP 0.11
#define FCR_TGT_LIST_TOP 0.185
#define FCR_TGT_LIST_PITCH 0.0394
// The name is given whole: the game does not paste ## into an argument passed on to another macro
#define FCR_TGT_LINE(name, index) MPD_TEXT_BONE_L(name, "Null", MPD_POS_BUTTON_R_X, FCR_TGT_LIST_TOP + 0.005 + index * FCR_TGT_LIST_PITCH, MPD_TEXT_USER(MFD_TEXT_IND_FCR_TGT_LIST_1 + index))

// Black under both boxes and the gap between them
class TgtStoreBacking {
    color[] = {0, 0, 0, 1};
    class Box {
        type = "polygon";
        points[] = {
            MPD_POINTS_BOX_POLY("Null", FCR_TGT_BOX_X, FCR_TGT_NEXT_TOP, FCR_TGT_BOX_W, FCR_TGT_LIST_TOP + MFD_FCR_TGT_LIST_LINES * FCR_TGT_LIST_PITCH + 0.01 - FCR_TGT_NEXT_TOP)
        };
    };
};
class TgtStoreBoxes {
    type = "line";
    width = 3;
    points[] = {
        MPD_POINTS_BOX("Null", FCR_TGT_BOX_X, FCR_TGT_NEXT_TOP, FCR_TGT_BOX_W, MPD_TEXT_HEIGHT), {},
        MPD_POINTS_BOX("Null", FCR_TGT_BOX_X, FCR_TGT_LIST_TOP, FCR_TGT_BOX_W, MFD_FCR_TGT_LIST_LINES * FCR_TGT_LIST_PITCH + 0.01)
    };
};
MPD_TEXT_BONE_L(TgtNext, "Null", MPD_POS_BUTTON_R_X, FCR_TGT_NEXT_TOP, MPD_TEXT_USER(MFD_TEXT_IND_FCR_TGT_NEXT))
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
FCR_TGT_LINE(TgtList_12, 12)
FCR_TGT_LINE(TgtList_13, 13)
FCR_TGT_LINE(TgtList_14, 14)
FCR_TGT_LINE(TgtList_15, 15)
FCR_TGT_LINE(TgtList_16, 16)

#undef FCR_TGT_LINE
#undef FCR_TGT_LIST_PITCH
#undef FCR_TGT_LIST_TOP
#undef FCR_TGT_NEXT_TOP
#undef FCR_TGT_BOX_W
#undef FCR_TGT_BOX_X
