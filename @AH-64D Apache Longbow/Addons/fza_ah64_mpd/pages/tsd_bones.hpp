class Tsd_Ownship {
    type = fixed;
    pos[] = {0.5, 0.75};
};

class Tsd_DigitSize1 {
    type = linear;
    MPD_NUM_USER(MFD_IND_TSD_SCALE_BOXES)
    min = 0;
    max = 1;
    maxPos[] = {0, 0};
    minPos[] = {MPD_TEXT_WIDTH, 0};
};

class Tsd_DigitSize2 : Tsd_DigitSize1 {
    min = 1;
    max = 2;
};

class Tsd_DigitSize3 : Tsd_DigitSize1 {
    min = 2;
    max = 3;
};