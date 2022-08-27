class Tsd_Ownship {
    type = fixed;
    pos[] = {0, 0.25};
};

class Tsd_Ownship_Offset {
    type = fixed;
    pos[] = {0.5, 0.5};
};

class Tsd_Hsi_360 {
    type = rotational;
    source = heading;
    min = 0;
    max = 360;
    sourceScale = 1;
    center[] = {0.5, 0.5};
    minAngle = 180;
    maxAngle = -180;
};

class Tsd_Hsi_Static_360 {
    type = rotational;
    source = heading;
    min = 0;
    max = 0;
    sourceScale = 1;
    center[] = {0.5, 0.5};
    minAngle = 360;
    maxAngle = 360;
};

#define TSD_HSI_HDG(hdg) class Tsd_Hsi_##hdg : Tsd_Hsi_360 { \
    minAngle = 180 + hdg; \
    maxAngle = -180 + hdg; \
};

#define TSD_HSI_STATIC(hdg) class Tsd_Hsi_Static_##hdg : Tsd_Hsi_Static_360 { \
    minAngle = hdg; \
    maxAngle = hdg; \
};

TSD_HSI_HDG(30)
TSD_HSI_HDG(60)
TSD_HSI_HDG(90)
TSD_HSI_HDG(120)
TSD_HSI_HDG(150)
TSD_HSI_HDG(180)
TSD_HSI_HDG(210)
TSD_HSI_HDG(240)
TSD_HSI_HDG(270)
TSD_HSI_HDG(300)
TSD_HSI_HDG(330)

TSD_HSI_STATIC(45)
TSD_HSI_STATIC(90)
TSD_HSI_STATIC(135)
TSD_HSI_STATIC(180)
TSD_HSI_STATIC(225)
TSD_HSI_STATIC(270)
TSD_HSI_STATIC(315)

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