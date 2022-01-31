class fcr_draw {
    class occluders{

    };
    
    class lines_GTM {
        type = line;
        width = 3;
        points[] = {
            //Left side
            {{0.040, 0.410}, 1}, 
            {{0.465, 0.835}, 1}, {},
            //Right side
            {{0.960, 0.410}, 1}, 
            {{0.535, 0.835}, 1}, {},
            //8km line
            {{0.040, 0.410}, 1}, 
            {{0.088, 0.368}, 1},
            {{0.139, 0.330}, 1},
            {{0.194, 0.297}, 1},
            {{0.251, 0.269}, 1},
            {{0.311, 0.248}, 1},
            {{0.373, 0.232}, 1},
            {{0.436, 0.223}, 1},
            {{0.500, 0.220}, 1},
            {{0.564, 0.223}, 1},
            {{0.627, 0.232}, 1},
            {{0.689, 0.248}, 1},
            {{0.749, 0.269}, 1},
            {{0.806, 0.297}, 1},
            {{0.861, 0.330}, 1},
            {{0.912, 0.368}, 1},
            {{0.960, 0.410}, 1}, {},
            //7km tick marks
            {{0.098, 0.468}, 1},
            {{0.112, 0.454}, 1}, {},
            {{0.888, 0.454}, 1},
            {{0.902, 0.468}, 1}, {},
            //6km line
            {{0.155, 0.525}, 1}, 
            {{0.191, 0.493}, 1},
            {{0.229, 0.465}, 1},
            {{0.270, 0.440}, 1},
            {{0.313, 0.420}, 1},
            {{0.358, 0.403}, 1},
            {{0.405, 0.392}, 1},
            {{0.452, 0.385}, 1},
            {{0.500, 0.383}, 1},
            {{0.548, 0.385}, 1},
            {{0.595, 0.392}, 1},
            {{0.642, 0.403}, 1},
            {{0.687, 0.420}, 1},
            {{0.730, 0.440}, 1},
            {{0.771, 0.465}, 1},
            {{0.809, 0.493}, 1},
            {{0.845, 0.525}, 1}, {},
            //5km tick marks
            {{0.213, 0.583}, 1},
            {{0.228, 0.568}, 1}, {},
            {{0.772, 0.568}, 1},
            {{0.787, 0.583}, 1}, {},
            //4km line
            {{0.270, 0.640}, 1}, 
            {{0.294, 0.619}, 1},
            {{0.319, 0.600}, 1},
            {{0.347, 0.583}, 1},
            {{0.376, 0.570}, 1},
            {{0.406, 0.559}, 1},
            {{0.437, 0.551}, 1},
            {{0.468, 0.547}, 1},
            {{0.500, 0.545}, 1},
            {{0.532, 0.547}, 1},
            {{0.563, 0.551}, 1},
            {{0.594, 0.559}, 1},
            {{0.624, 0.570}, 1},
            {{0.653, 0.583}, 1},
            {{0.681, 0.600}, 1},
            {{0.706, 0.619}, 1},
            {{0.730, 0.640}, 1}, {},
            //3km tick marks
            {{0.328, 0.698}, 1},
            {{0.343, 0.683}, 1}, {},
            {{0.657, 0.683}, 1},
            {{0.672, 0.698}, 1}, {},
            //2km line
            {{0.385, 0.755}, 1}, 
            {{0.397, 0.744}, 1},
            {{0.410, 0.735}, 1},
            {{0.423, 0.727}, 1},
            {{0.438, 0.720}, 1},
            {{0.453, 0.714}, 1},
            {{0.468, 0.711}, 1},
            {{0.484, 0.708}, 1},
            {{0.500, 0.708}, 1},
            {{0.516, 0.708}, 1},
            {{0.532, 0.711}, 1},
            {{0.547, 0.714}, 1},
            {{0.562, 0.720}, 1},
            {{0.577, 0.727}, 1},
            {{0.590, 0.735}, 1},
            {{0.603, 0.744}, 1},
            {{0.615, 0.755}, 1}, {},
            //1km tick marks
            {{0.443, 0.813}, 1},
            {{0.459, 0.800}, 1}, {},
            {{0.541, 0.800}, 1},
            {{0.557, 0.813}, 1}, {},
            //Left 22.5 tick mark
            {{0.251, 0.269}, 1},
            {{0.257, 0.283}, 1}, {},
            //Left 15 tick mark
            {{0.332, 0.242}, 1},
            {{0.336, 0.257}, 1}, {},
            //Left 7.5 tick mark
            {{0.415, 0.226}, 1},
            {{0.417, 0.240}, 1}, {},
            //Center tick mark
            {{0.500, 0.220}, 1},
            {{0.500, 0.235}, 1}, {},
            //Right 7.5 tick mark
            {{0.585, 0.226}, 1},
            {{0.583, 0.240}, 1}, {},
            //Right 15 tick mark
            {{0.668, 0.242}, 1},
            {{0.664, 0.257}, 1}, {},
            //Right 22.5 tick mark
            {{0.749, 0.269}, 1},
            {{0.743, 0.283}, 1}, {},
        };
    };
    class lines_continuous {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_SCAN_TYPE), FCR_MODE_ON_CONTINUOUS));
        class nearBar {
            condition = C_COND(C_AND(C_LESS(0,C_MPD_USER(MFD_IND_FCR_ANIM)), C_LESS(C_MPD_USER(MFD_IND_FCR_ANIM), 1)));
            class line {
                type = line;
                width = 3;
                points[] = {
                    {"FCR_NearBar", {0, 0.05}, 1},
                    {"FCR_NearBar", {0, 0.325}, 1}
                };
            };
        };
        class farBar {
            condition = C_COND(C_AND(C_LESS(1,C_MPD_USER(MFD_IND_FCR_ANIM)), C_LESS(C_MPD_USER(MFD_IND_FCR_ANIM), 2)));
            class line {
                type = line;
                width = 3;
                points[] = {
                    {"FCR_FarBar", {0, 0.325}, 1},
                    {"FCR_FarBar", {0, 0.650}, 1}
                };
            };
        };
    };
    class lines_single : lines_continuous {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_SCAN_TYPE), FCR_MODE_ON_SINGLE));
        color[] = {1,1,1,1};
        class nearBar {
            condition = C_COND(C_AND(C_LESS(0,C_MPD_USER(MFD_IND_FCR_ANIM)), C_LESS(C_MPD_USER(MFD_IND_FCR_ANIM), 1)));
            class line {
                type = line;
                width = 3;
                points[] = {
                    {"FCR_NearBar", {0, 0.050}, 1},
                    {"FCR_NearBar", {0, 0.325}, 1}
                };
            };
        };
        class farBar {
            condition = C_COND(C_AND(C_LESS(1,C_MPD_USER(MFD_IND_FCR_ANIM)), C_LESS(C_MPD_USER(MFD_IND_FCR_ANIM), 2)));
            class line {
                type = line;
                width = 3;
                points[] = {
                    {"FCR_FarBar", {0, 0.325}, 1},
                    {"FCR_FarBar", {0, 0.650}, 1}
                };
            };
        };
    };
    //Wide = Near Bar, Far Bar, Near Bar, Far Bar starts left and moves right

    class polys_elev {
        class Polygon {
            type = polygon;
            points[] = {
                {
                    { {0.060, 0.860}, 1 },
                    { {0.072, 0.850}, 1 },
                    { {0.072, 0.870}, 1 },
                },
            };
        };
    };

    class lines_elev {
        type = line;
        width = 3;
        points[] = {
            //25 deg
            {{0.030, 0.800}, 1}, 
            {{0.060, 0.800}, 1}, {},
            //18.75 deg
            {{0.030, 0.815}, 1}, 
            {{0.050, 0.815}, 1}, {},
            //12.5 deg
            {{0.030, 0.830}, 1}, 
            {{0.050, 0.830}, 1}, {},
            //6.25 deg
            {{0.030, 0.845}, 1}, 
            {{0.050, 0.845}, 1}, {},
            //0 deg
            {{0.030, 0.860}, 1}, 
            {{0.050, 0.860}, 1}, {},
            //6.25 deg
            {{0.030, 0.875}, 1}, 
            {{0.060, 0.875}, 1}, {},
            //12.5 deg
            {{0.030, 0.890}, 1}, 
            {{0.050, 0.890}, 1}, {},
            //18.75 deg
            {{0.030, 0.905}, 1}, 
            {{0.050, 0.905}, 1}, {},
            //25 deg
            {{0.030, 0.920}, 1}, 
            {{0.060, 0.920}, 1}, {},
        };
    };

    class lines_HAD {
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
        type = line;
        width = 3;
        points[] = {
            //Top center index
            {{0.500, 0.894}, 1}, 
            {{0.500, 0.909}, 1}, {},
            //Bottom center index
            {{0.500, 0.984}, 1}, 
            {{0.500, 0.969}, 1}, {},
            //90 deg left top
            {{0.410, 0.894}, 1}, 
            {{0.410, 0.909}, 1}, {},
            //90 deg left bottom
            {{0.410, 0.984}, 1}, 
            {{0.410, 0.969}, 1}, {},
            //90 deg right top
            {{0.590, 0.894}, 1}, 
            {{0.590, 0.909}, 1}, {},
            //90 deg left bottom
            {{0.590, 0.984}, 1}, 
            {{0.590, 0.969}, 1}, {},
            //Left center index
            {{0.380, 0.917}, 1}, 
            {{0.395, 0.917}, 1}, {},
            //Right center index
            {{0.620, 0.917}, 1},
            {{0.605, 0.917}, 1}, {},
        };
    };

    class lines_HAD_PLTFormat {
        type = line;
        width = 3;
        points[] = {
            //Top center index
            {{0.500, 0.894}, 1}, 
            {{0.500, 0.909}, 1}, {},
            //Bottom center index
            {{0.500, 0.984}, 1}, 
            {{0.500, 0.969}, 1}, {},
            //Left center index
            {{0.380, 0.917}, 1}, 
            {{0.395, 0.917}, 1}, {},
            //Right center index
            {{0.620, 0.917}, 1},
            {{0.605, 0.917}, 1}, {},
        };
    };

    class lines_CurScanLine {
        //Needs bone
        type = line;
        width = 3;
        points[] = {
            {{0.450, 0.894}, 1}, 
            {{0.450, 0.984}, 1}, {},
        };
    };

    class lines_PrevScanLine {
        //Needs bone
        type = line;
        width = 3;
        points[] = {
            //1
            {{0.580, 0.894}, 1}, 
            {{0.580, 0.904}, 1}, {},
            //2
            {{0.580, 0.914}, 1}, 
            {{0.580, 0.924}, 1}, {},
            //3
            {{0.580, 0.934}, 1}, 
            {{0.580, 0.944}, 1}, {},
            //4
            {{0.580, 0.954}, 1}, 
            {{0.580, 0.964}, 1}, {},
            //5
            {{0.580, 0.974}, 1}, 
            {{0.580, 0.984}, 1}, {},
        };
    };

    class polys_CuedLOS {
        //Needs bone
        class Polygon {
            type = polygon;
            points[] = {
                {
                    { {0.495, 0.939}, 1 },
                    { {0.500, 0.934}, 1 },
                    { {0.505, 0.939}, 1 },
                    { {0.500, 0.944}, 1 }
                },
            };
        };
    };

    class lines_FOVBox {
        //Needs bone
        type = line;
        width = 3;
        points[] = {
            //Top
            {{0.480, 0.926}, 1}, 
            {{0.520, 0.926}, 1},
            //Right
            {{0.520, 0.926}, 1}, 
            {{0.520, 0.952}, 1},
            //Bottom
            {{0.520, 0.952}, 1}, 
            {{0.480, 0.952}, 1},
            //Left
            {{0.480, 0.952}, 1}, 
            {{0.480, 0.926}, 1}, {},
        };
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
    
    class vabs{
        //T1
        MPD_TEXT_C(C_SCP,  MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("C SCP"))
        //T6
        MPD_BOX_BAR_T(UTIL,    MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y)
        MPD_TEXT_C(UTIL,       MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("UTIL"))
        
        //R1
        MPD_TEXT_L(ZOOM_1,     MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y - 2.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("Z"))
        MPD_TEXT_L(ZOOM_2,     MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y - 1.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("O"))
        MPD_TEXT_L(ZOOM_3,     MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("O"))
        MPD_TEXT_L(ZOOM_4,     MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("M"))
        //R4
        MPD_TEXT_L(RFHO_1,     MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("RF"))
        MPD_TEXT_L(RFHO_2,     MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("HO"))
        //R6
        MPD_TEXT_L(ACQ_Label,  MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("ACQ"))
        MPD_BOX_L(ACQ,         MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y + 0.5 * MPD_TEXT_HEIGHT, 3)
        MPD_TEXT_L(ACQ,        MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("FXD"))

        //L1
        MPD_TEXT_R(NTS_1,      MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y - 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("N"))
        MPD_TEXT_R(NTS_2,      MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y,                        MPD_TEXT_STATIC("T"))
        MPD_TEXT_R(NTS_3,      MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("S"))
        //L4
        MPD_TEXT_R(TGT_1,      MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y - 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("T"))
        MPD_TEXT_R(TGT_2,      MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y,                        MPD_TEXT_STATIC("G"))
        MPD_TEXT_R(TGT_3,      MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y + 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("T"))
        //L5
        MPD_TEXT_R(ELEV_Label, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("ELEV"))
        MPD_BOX_R(ELEV,        MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y + 0.5 * MPD_TEXT_HEIGHT, 4)
        MPD_TEXT_R(ELEV,       MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("AUTO"))
    };

    class text {
        //Target count
        MPD_TEXT_L(COUNT, 0.95, 0.04, MPD_TEXT_USER(MFD_TEXT_IND_FCR_COUNT))

        //HAD left
        //Sight Select Status (6 chars)
        MPD_TEXT_R(SSS, 0.22 - (6*MPD_TEXT_WIDTH), 0.939 - MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_FCR_SSS))
        //Range and Range Source 5 chars
        MPD_TEXT_L(RRS, 0.22 + (6*MPD_TEXT_WIDTH), 0.939 - MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_FCR_RRS))
        //Sight Status (12 chars)
        MPD_TEXT_R(SS,  0.22 - (6*MPD_TEXT_WIDTH), 0.939,                   MPD_TEXT_USER(MFD_TEXT_IND_FCR_SS))

        //HAD right
        //Weapon Control 5 chars
        MPD_TEXT_R(WC,  0.78 - (6*MPD_TEXT_WIDTH), 0.939 - MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_FCR_WC))
        //Acquisition Select Status 4 chars
        MPD_TEXT_R(ACQ, 0.78 + MPD_TEXT_WIDTH,     0.939 - MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_FCR_ACQ))
        //Weapon Status 12 chars
        MPD_TEXT_R(WS,  0.78 - (6*MPD_TEXT_WIDTH), 0.939,                   MPD_TEXT_USER(MFD_TEXT_IND_FCR_WS))

        //Heading
        MPD_TEXT_C(Heading, 0.5, 0.11, source = heading; sourceScale = 1;)
    };
};