class Tsd_Ownship {
    type = fixed;
    pos[] = {0.5, 0.75};
};

class Tsd_DigitSize1 {
    type = linear;
    MPD_NUM_USER(MFD_IND_TSD_SCALE_BOXES)
    min = 9000;
    max = 10000;
    maxPos[] = {0, 0};
    minPos[] = {MPD_TEXT_WIDTH, 0};
};

class Tsd_DigitSize2 : Tsd_DigitSize1 {
    min = 24000;
    max = 25000;
};

class Tsd_DigitSize3 : Tsd_DigitSize1 {
    min = 49000;
    max = 50000;
};