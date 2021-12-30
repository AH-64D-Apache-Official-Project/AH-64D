class fcr_draw {
    class occluders{

    };
    
    class lines_GTM {
        type = line;
        width = 3;
        points[] = {
            //Left side
            {{0.04, 0.41}, 1}, 
            {{0.48, 0.85}, 1}, {},
            //Right side
            {{0.96, 0.41}, 1}, 
            {{0.52, 0.85}, 1}, {},
            //8km line
            {{0.04, 0.410}, 1}, 
            {{0.09, 0.368}, 1},
            {{0.14, 0.330}, 1},
            {{0.19, 0.297}, 1},
            {{0.25, 0.269}, 1},
            {{0.31, 0.248}, 1},
            {{0.37, 0.232}, 1},
            {{0.44, 0.223}, 1},
            {{0.50, 0.220}, 1},
            {{0.56, 0.223}, 1},
            {{0.63, 0.232}, 1},
            {{0.69, 0.248}, 1},
            {{0.75, 0.269}, 1},
            {{0.81, 0.297}, 1},
            {{0.86, 0.330}, 1},
            {{0.91, 0.368}, 1},
            {{0.96, 0.410}, 1}, {},
            //7km tick marks
            {{0.098, 0.468}, 1},
            {{0.112, 0.454}, 1}, {},
            {{0.888, 0.454}, 1},
            {{0.902, 0.468}, 1}, {},
            //6km line
            {{0.16, 0.525}, 1}, 
            {{0.19, 0.493}, 1},
            {{0.23, 0.465}, 1},
            {{0.27, 0.440}, 1},
            {{0.31, 0.420}, 1},
            {{0.36, 0.403}, 1},
            {{0.40, 0.392}, 1},
            {{0.45, 0.385}, 1},
            {{0.50, 0.383}, 1},
            {{0.55, 0.385}, 1},
            {{0.60, 0.392}, 1},
            {{0.64, 0.403}, 1},
            {{0.69, 0.420}, 1},
            {{0.73, 0.440}, 1},
            {{0.77, 0.465}, 1},
            {{0.81, 0.493}, 1},
            {{0.84, 0.525}, 1}, {},
            //5km tick marks
            {{0.213, 0.583}, 1},
            {{0.228, 0.568}, 1}, {},
            {{0.772, 0.568}, 1},
            {{0.787, 0.583}, 1}, {},
            //4km line
            {{0.27, 0.640}, 1}, 
            {{0.29, 0.619}, 1},
            {{0.32, 0.600}, 1},
            {{0.35, 0.583}, 1},
            {{0.38, 0.570}, 1},
            {{0.41, 0.559}, 1},
            {{0.44, 0.551}, 1},
            {{0.47, 0.547}, 1},
            {{0.50, 0.545}, 1},
            {{0.53, 0.547}, 1},
            {{0.56, 0.551}, 1},
            {{0.59, 0.559}, 1},
            {{0.62, 0.570}, 1},
            {{0.65, 0.583}, 1},
            {{0.68, 0.600}, 1},
            {{0.71, 0.619}, 1},
            {{0.73, 0.640}, 1}, {},
            //3km tick marks
            {{0.328, 0.698}, 1},
            {{0.343, 0.683}, 1}, {},
            {{0.657, 0.683}, 1},
            {{0.672, 0.698}, 1}, {},
            //2km line
            {{0.39, 0.755}, 1}, 
            {{0.40, 0.744}, 1},
            {{0.41, 0.735}, 1},
            {{0.42, 0.727}, 1},
            {{0.44, 0.720}, 1},
            {{0.45, 0.714}, 1},
            {{0.47, 0.711}, 1},
            {{0.48, 0.708}, 1},
            {{0.50, 0.708}, 1},
            {{0.52, 0.708}, 1},
            {{0.53, 0.711}, 1},
            {{0.55, 0.714}, 1},
            {{0.56, 0.720}, 1},
            {{0.58, 0.727}, 1},
            {{0.59, 0.735}, 1},
            {{0.60, 0.744}, 1},
            {{0.61, 0.755}, 1}, {},
            //1km tick marks
            {{0.443, 0.813}, 1},
            {{0.459, 0.800}, 1}, {},
            {{0.541, 0.800}, 1},
            {{0.557, 0.813}, 1}, {},
        };
    };

    class lines {
        type = line;
        width = 3;
        points[] = {
            //Top
            {{0.38, 0.894}, 1}, 
            {{0.62, 0.894}, 1},
            //Right
            {{0.62, 0.894}, 1}, 
            {{0.62, 0.984}, 1},
            //Bottom
            {{0.62, 0.984}, 1}, 
            {{0.38, 0.984}, 1},
            //Left
            {{0.38, 0.984}, 1}, 
            {{0.38, 0.894}, 1}, {},
            //Left HAD box
            MPD_POINTS_BOX(Null, 0.22-(6*MPD_TEXT_WIDTH), 0.939 - MPD_TEXT_HEIGHT, 12*MPD_TEXT_WIDTH, 2*MPD_TEXT_HEIGHT), {},
            //Right HAD box
            MPD_POINTS_BOX(Null, 0.78-(6*MPD_TEXT_WIDTH), 0.939 - MPD_TEXT_HEIGHT, 12*MPD_TEXT_WIDTH, 2*MPD_TEXT_HEIGHT), {},
            //Target count box
            MPD_POINTS_BOX(Null, 0.95-(4*MPD_TEXT_WIDTH), 0.04, 4*MPD_TEXT_WIDTH, 0.9*MPD_TEXT_HEIGHT), {},
        };
    };

    class lines_HAD_CPGFormat {

    };

    class lines_HAD_PLTFormat {

    };

    class lines_FOVBox {

    };

    
    ///////////////// Heading Tape ///////////////
    /*
    class headingTape {
        //Source info
        source = heading;
        sourceScale = 1;

        //Tape setup
        type = scale;
        horizontal = 1;
        neverEatSeaWeed = 1;
        step = 10;
        stepSize = __EVAL(0.5/18-0.001);
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
    };*/
    MPD_TEXT_C(Heading, 0.5, 0.11, source = heading; sourceScale = 1;)
    
    class vabs{
        //T1
        MPD_TEXT_C(C_SCP,  MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("C SCP"))
        //T6
        MPD_BOX_BAR_T(UTIL, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y)
        MPD_TEXT_C(UTIL,    MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("UTIL"))
        
        //R1
        MPD_TEXT_L(ZOOM_1, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y - 2.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("Z"))
        MPD_TEXT_L(ZOOM_2, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y - 1.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("O"))
        MPD_TEXT_L(ZOOM_3, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("O"))
        MPD_TEXT_L(ZOOM_4, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("M"))
        //R4
        MPD_TEXT_L(RFHO_1,      MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("RF"))
        MPD_TEXT_L(RFHO_2,      MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("HO"))
        //R6
        MPD_TEXT_L(ACQ_Label, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("ACQ"))
        MPD_BOX_L(ACQ,        MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y + 0.5 * MPD_TEXT_HEIGHT, 3)
        MPD_TEXT_L(ACQ,       MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("FXD"))

        //L1
        MPD_TEXT_R(NTS_1,       MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y - 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("N"))
        MPD_TEXT_R(NTS_2,       MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y,                        MPD_TEXT_STATIC("T"))
        MPD_TEXT_R(NTS_3,       MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("S"))
        //L4
        MPD_TEXT_R(TGT_1,       MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y - 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("T"))
        MPD_TEXT_R(TGT_2,       MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y,                        MPD_TEXT_STATIC("G"))
        MPD_TEXT_R(TGT_3,       MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y + 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("T"))
        //L5
        MPD_TEXT_R(ELEV_Label, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("ELEV"))
        MPD_BOX_R(ELEV,        MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y + 0.5 * MPD_TEXT_HEIGHT, 4)
        MPD_TEXT_R(ELEV,       MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("AUTO"))
    };

    class text {
        //Target count
        MPD_TEXT_L(COUNT, 0.95, 0.04, MPD_TEXT_STATIC("XXXX"))

        //HAD left
        //Sight Select Status 6 chars
        //Sight Status 12 chars
        //Range and Range Source 5 chars

        //HAD right
        //Weapon Control 5 chars
        //Acquisition Select Status 4 chars
        //Weapon Status 12 chars
    };
};