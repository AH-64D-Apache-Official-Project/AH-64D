class fcr_draw {
    //R1
    MPD_TEXT_L(ZOOM_1,     MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y - 2.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("Z"))
    MPD_TEXT_L(ZOOM_2,     MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y - 1.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("O"))
    MPD_TEXT_L(ZOOM_3,     MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y - 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("O"))
    MPD_TEXT_L(ZOOM_4,     MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 0.5 * MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("M"))
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
            condition = C_COND(C_AND(C_LESS(0,C_MPD_USER(MFD_IND_FCR_ANIM)), C_LESS(C_MPD_USER(MFD_IND_FCR_ANIM), 2)));
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
            condition = C_COND(C_AND(C_LESS(2,C_MPD_USER(MFD_IND_FCR_ANIM)), C_LESS(C_MPD_USER(MFD_IND_FCR_ANIM), 4)));
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
            condition = C_COND(C_AND(C_LESS(0,C_MPD_USER(MFD_IND_FCR_ANIM)), C_LESS(C_MPD_USER(MFD_IND_FCR_ANIM), 2)));
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
            condition = C_COND(C_AND(C_LESS(2,C_MPD_USER(MFD_IND_FCR_ANIM)), C_LESS(C_MPD_USER(MFD_IND_FCR_ANIM), 4)));
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
};