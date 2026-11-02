// The cursor's user values (MFD_IND_CURSOR_X, MFD_IND_CURSOR_Y) as an offset from the top left. A linear bone is at
// maxPos at its min value.
class MPD_Cursor_X {
    type = "linear";
    source = "user";
    sourceIndex = MFD_IND_CURSOR_X;
    min = __EVAL(MPD_CURSOR_X_BASE);
    max = __EVAL(MPD_CURSOR_X_BASE + 1);
    minPos[] = {1, 0};
    maxPos[] = {0, 0};
};

class MPD_Cursor_Y {
    type = "linear";
    source = "user";
    sourceIndex = MFD_IND_CURSOR_Y;
    min = 0;
    max = 1;
    minPos[] = {0, 1};
    maxPos[] = {0, 0};
};
