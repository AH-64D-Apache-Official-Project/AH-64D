#ifdef FZA_HEADING_TAPE_FIXED
class HeadingTape {
    //Source info
    source = heading;
    sourceScale = 1;

    //Tape setup
    type = scale;
    horizontal = 1;
    neverEatSeaWeed = 1;
    step = 10;
    stepSize = __EVAL(0.4/18-0.001);
    lineXLeft = 0.15;
    lineYRight = 0.165;
    lineXLeftMajor = 0.15;
    lineYRightMajor = 0.18;
    top = 0.25;
    bottom = 0.75;
    center = 0.5;
    majorLineEach = 3;
    numberEach = 3;
    width = 3;

    //Text config
    align = center;
    scale = 1;
    pos[] = {0.25, 0.15-MPD_TEXT_HEIGHT};
    right[] = {0.25 + MPD_TEXT_WIDTH_VEC, 0.15-MPD_TEXT_HEIGHT};
    down[] = {0.25, 0.15};
};
#else
class HeadingTape {
    #define MINOR_LINE(id, bearing) class id { \
        condition = C_COND(C_AND(C_LESS(bearing-103,"heading"), C_LESS("heading",bearing+103))); \
        class Line { \
            type = line; \
            width = 3; \
            points[] = \
                { {FCR_HeadingTape, {(bearing)*0.4/180+0.1,0.005 }, 1} \
                , {FCR_HeadingTape, {(bearing)*0.4/180+0.1,0.020}, 1} \
                }; \
        }; \
    };
    #define MAJOR_LINE(id, bearing, txt) class id { \
        condition = C_COND(C_AND(C_LESS(bearing-103,"heading"), C_LESS("heading",bearing+103))); \
        class Line { \
            type = line; \
            width = 3; \
            points[] = \
                { {FCR_HeadingTape, {(bearing)*0.4/180+0.1,0}, 1} \
                , {FCR_HeadingTape, {(bearing)*0.4/180+0.1,0.025}, 1} \
                }; \
        }; \
        MPD_TEXT_BONE_C(Text, FCR_HeadingTape, (bearing)*0.4/180+0.1, -MPD_TEXT_HEIGHT, MPD_TEXT_STATIC(txt)) \
    };

    MAJOR_LINE(N180, -180, "S")
    MINOR_LINE(N170, -170)
    MINOR_LINE(N160, -160)
    MAJOR_LINE(N150, -150, "21")
    MINOR_LINE(N140, -140)
    MINOR_LINE(N130, -130)
    MAJOR_LINE(N120, -120, "24")
    MINOR_LINE(N110, -110)
    MINOR_LINE(N100, -100)

    MAJOR_LINE(N90, -90, "W")
    MINOR_LINE(N80, -80)
    MINOR_LINE(N70, -70)
    MAJOR_LINE(N60, -60, "30")
    MINOR_LINE(N50, -50)
    MINOR_LINE(N40, -40)
    MAJOR_LINE(N30, -30, "33")
    MINOR_LINE(N20, -20)
    MINOR_LINE(N10, -10)

    MAJOR_LINE(P0, 0, "N")

    MINOR_LINE(P10, 10)
    MINOR_LINE(P20, 20)
    MAJOR_LINE(P30, 30, "3")
    MINOR_LINE(P40, 40)
    MINOR_LINE(P50, 50)
    MAJOR_LINE(P60, 60, "6")
    MINOR_LINE(P70, 70)
    MINOR_LINE(P80, 80)
    MAJOR_LINE(P90, 90, "E")

    MINOR_LINE(P100, 100)
    MINOR_LINE(P110, 110)
    MAJOR_LINE(P120, 120, "12")
    MINOR_LINE(P130, 130)
    MINOR_LINE(P140, 140)
    MAJOR_LINE(P150, 150, "15")
    MINOR_LINE(P160, 160)
    MINOR_LINE(P170, 170)
    MAJOR_LINE(P180, 180, "S")

    MINOR_LINE(P190, 190)
    MINOR_LINE(P200, 200)
    MAJOR_LINE(P210, 210, "21")
    MINOR_LINE(P220, 220)
    MINOR_LINE(P230, 230)
    MAJOR_LINE(P240, 240, "24")
    MINOR_LINE(P250, 250)
    MINOR_LINE(P260, 260)
    MAJOR_LINE(P270, 270, "W")

    MINOR_LINE(P280, 280)
    MINOR_LINE(P290, 290)
    MAJOR_LINE(P300, 300, "30")
    MINOR_LINE(P310, 310)
    MINOR_LINE(P320, 320)
    MAJOR_LINE(P330, 330, "33")
    MINOR_LINE(P340, 340)
    MINOR_LINE(P350, 350)
    MAJOR_LINE(P360, 360, "N")

    MINOR_LINE(P370, 370)
    MINOR_LINE(P380, 380)
    MAJOR_LINE(P390, 390, "3")
    MINOR_LINE(P400, 400)
    MINOR_LINE(P410, 410)
    MAJOR_LINE(P420, 420, "6")
    MINOR_LINE(P430, 430)
    MINOR_LINE(P440, 440)
    MAJOR_LINE(P450, 450, "E")

    MINOR_LINE(P460, 460)
    MINOR_LINE(P470, 470)
    MAJOR_LINE(P480, 480, "12")
    MINOR_LINE(P490, 490)
    MINOR_LINE(P500, 500)
    MAJOR_LINE(P510, 510, "15")
    MINOR_LINE(P520, 520)
    MINOR_LINE(P530, 530)
    MAJOR_LINE(P540, 540, "S")
};
#endif