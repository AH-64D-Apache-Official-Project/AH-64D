class ase_draw {
    class lines {
        type = line;
        width = 3;
        points[] = {
            //ASE footprint circle
            {{0.175, 0.500}, 1},
            {{0.178, 0.458}, 1},
            {{0.186, 0.416}, 1},
            {{0.200, 0.376}, 1},
            {{0.219, 0.338}, 1},
            {{0.242, 0.302}, 1},
            {{0.270, 0.270}, 1},
            {{0.302, 0.242}, 1},
            {{0.338, 0.219}, 1},
            {{0.376, 0.200}, 1},
            {{0.416, 0.186}, 1},
            {{0.458, 0.178}, 1},
            {{0.500, 0.175}, 1},
            {{0.542, 0.178}, 1},
            {{0.584, 0.186}, 1},
            {{0.624, 0.200}, 1},
            {{0.663, 0.219}, 1},
            {{0.698, 0.242}, 1},
            {{0.730, 0.270}, 1},
            {{0.758, 0.302}, 1},
            {{0.781, 0.338}, 1},
            {{0.800, 0.376}, 1},
            {{0.814, 0.416}, 1},
            {{0.822, 0.458}, 1},
            {{0.825, 0.500}, 1},
            {{0.822, 0.542}, 1},
            {{0.814, 0.584}, 1},
            {{0.800, 0.624}, 1},
            {{0.781, 0.663}, 1},
            {{0.758, 0.698}, 1},
            {{0.730, 0.730}, 1},
            {{0.698, 0.758}, 1},
            {{0.663, 0.781}, 1},
            {{0.624, 0.800}, 1},
            {{0.584, 0.814}, 1},
            {{0.542, 0.822}, 1},
            {{0.500, 0.825}, 1},
            {{0.458, 0.822}, 1},
            {{0.416, 0.814}, 1},
            {{0.376, 0.800}, 1},
            {{0.338, 0.781}, 1},
            {{0.302, 0.758}, 1},
            {{0.270, 0.730}, 1},
            {{0.242, 0.698}, 1},
            {{0.219, 0.663}, 1},
            {{0.200, 0.624}, 1},
            {{0.186, 0.584}, 1},
            {{0.178, 0.542}, 1}, 
            {{0.175, 0.500}, 1}, {},
            //Autopage top
            {{0.002, 0.380}, 1}, 
            {{0.080, 0.380}, 1}, {},
            //Autopage right
            {{0.080, 0.380}, 1}, 
            {{0.080, 0.870}, 1}, {},
            //Autopage bottom
            {{0.080, 0.870}, 1}, 
            {{0.002, 0.870}, 1}, {},
            //RJAM left
            {{0.545, 0.998}, 1}, 
            {{0.545, 0.920}, 1}, {},
            //RJAM top
            {{0.545, 0.920}, 1}, 
            {{0.890, 0.920}, 1}, {},
            //RJAM right
            {{0.890, 0.920}, 1}, 
            {{0.890, 0.998}, 1}, {},
            //Heading box top
            MPD_POINTS_BOX(Null, 0.5-(1.5*MPD_TEXT_WIDTH), MPD_POS_BUTTON_T_Y+0.005, 3*MPD_TEXT_WIDTH, MPD_TEXT_HEIGHT-0.01), {},
            //Heading box bottom
            MPD_POINTS_BOX(Null, 0.5-(1.5*MPD_TEXT_WIDTH), MPD_POS_BUTTON_B_Y+0.005, 3*MPD_TEXT_WIDTH, MPD_TEXT_HEIGHT-0.01), {},
            //Chaff box
            MPD_POINTS_BOX(Null, MPD_POS_BUTTON_TB_1_X-(2.5*MPD_TEXT_WIDTH), MPD_POS_BUTTON_B_Y-(3*MPD_TEXT_HEIGHT), 5*MPD_TEXT_WIDTH, MPD_TEXT_HEIGHT*2), {},
        };
    };

    class occluders {
        color[] = {0,0,0,1};
        class Polygons {
            type = polygon;
            points[] = {
                { //Autopage occluder
                    {{0.075,                0.600-3.5*MPD_TEXT_HEIGHT}, 1},
                    {{0.080+MPD_TEXT_WIDTH, 0.600-3.5*MPD_TEXT_HEIGHT}, 1},
                    {{0.080+MPD_TEXT_WIDTH, 0.600+4.5*MPD_TEXT_HEIGHT}, 1},
                    {{0.075,                0.600+4.5*MPD_TEXT_HEIGHT}, 1}
                },
                { //RJAM occluder
                    {{0.718-2.1*MPD_TEXT_WIDTH, 0.925}, 1},
                    {{0.718-2.1*MPD_TEXT_WIDTH, 0.920-MPD_TEXT_HEIGHT}, 1},
                    {{0.718+2.1*MPD_TEXT_WIDTH, 0.920-MPD_TEXT_HEIGHT}, 1},
                    {{0.718+2.1*MPD_TEXT_WIDTH, 0.925}, 1}
                },
            };
        };
    };

    #define IRJamX MPD_POS_BUTTON_R_X - 0.1*MPD_TEXT_WIDTH
    #define IRJamY MPD_POS_BUTTON_LR_1_Y - 0.05*MPD_TEXT_HEIGHT
    class lines_IRJamOnOff {
        type = line;
        width = 3;
        points[] = {
            //Power Indicator
            {{IRJamX - 0.010, IRJamY + 0.000}, 1},
            {{IRJamX - 0.007, IRJamY - 0.007}, 1},
            {{IRJamX - 0.000, IRJamY - 0.010}, 1},
            {{IRJamX + 0.007, IRJamY - 0.007}, 1},
            {{IRJamX + 0.010, IRJamY + 0.000}, 1},
            {{IRJamX + 0.007, IRJamY + 0.007}, 1},
            {{IRJamX + 0.000, IRJamY + 0.010}, 1},
            {{IRJamX - 0.007, IRJamY + 0.007}, 1}, 
            {{IRJamX - 0.010, IRJamY + 0.000}, 1},
        };
    };
    class polys_IRJamOnOff {
        class Polygons {
            type = polygon;
            points[] = {
                { //Top left
                    {{IRJamX - 0.010, IRJamY + 0.000}, 1},
                    {{IRJamX - 0.007, IRJamY - 0.007}, 1},
                    {{IRJamX - 0.000, IRJamY - 0.010}, 1},
                    {{IRJamX, IRJamY}, 1}
                },
                { //Top right
                    {{IRJamX - 0.000, IRJamY - 0.010}, 1},
                    {{IRJamX + 0.007, IRJamY - 0.007}, 1},
                    {{IRJamX + 0.010, IRJamY + 0.000}, 1},
                    {{IRJamX, IRJamY}, 1}
                },
                { //Bottom right
                    {{IRJamX + 0.010, IRJamY + 0.000}, 1},
                    {{IRJamX + 0.007, IRJamY + 0.007}, 1}, 
                    {{IRJamX + 0.000, IRJamY + 0.010}, 1},
                    {{IRJamX, IRJamY}, 1}
                },
                { //Bottom left
                    {{IRJamX + 0.000, IRJamY + 0.010}, 1},
                    {{IRJamX - 0.007, IRJamY + 0.007}, 1}, 
                    {{IRJamX - 0.010, IRJamY + 0.000}, 1},
                    {{IRJamX, IRJamY}, 1}
                }
            };
        };
    };
    class lines_IRJam {
        type = line;
        width = 3;
        points[] = {
            MPD_POINTS_BOX(Null, MPD_POS_BUTTON_R_X-(4*MPD_TEXT_WIDTH), MPD_POS_BUTTON_LR_1_Y + 0.6*MPD_TEXT_HEIGHT, 4*MPD_TEXT_WIDTH, MPD_TEXT_HEIGHT-0.015),
        };
    };

    #define RLWRX MPD_POS_BUTTON_R_X - 0.1*MPD_TEXT_WIDTH
    #define RLWRY MPD_POS_BUTTON_LR_6_Y - 0.05*MPD_TEXT_HEIGHT
    class lines_RLWROnOff {
        type = line;
        width = 3;
        points[] = {
            //Power Indicator
            {{RLWRX - 0.010, RLWRY + 0.000}, 1},
            {{RLWRX - 0.007, RLWRY - 0.007}, 1},
            {{RLWRX - 0.000, RLWRY - 0.010}, 1},
            {{RLWRX + 0.007, RLWRY - 0.007}, 1},
            {{RLWRX + 0.010, RLWRY + 0.000}, 1},
            {{RLWRX + 0.007, RLWRY + 0.007}, 1},
            {{RLWRX + 0.000, RLWRY + 0.010}, 1},
            {{RLWRX - 0.007, RLWRY + 0.007}, 1}, 
            {{RLWRX - 0.010, RLWRY + 0.000}, 1},
        };
    };
    class polys_RLWROnOff {
        class Polygons {
            type = polygon;
            points[] = {
                { //Top left
                    {{RLWRX - 0.010, RLWRY + 0.000}, 1},
                    {{RLWRX - 0.007, RLWRY - 0.007}, 1},
                    {{RLWRX - 0.000, RLWRY - 0.010}, 1},
                    {{RLWRX, RLWRY}, 1}
                },
                { //Top right
                    {{RLWRX - 0.000, RLWRY - 0.010}, 1},
                    {{RLWRX + 0.007, RLWRY - 0.007}, 1},
                    {{RLWRX + 0.010, RLWRY + 0.000}, 1},
                    {{RLWRX, RLWRY}, 1}
                },
                { //Bottom right
                    {{RLWRX + 0.010, RLWRY + 0.000}, 1},
                    {{RLWRX + 0.007, RLWRY + 0.007}, 1}, 
                    {{RLWRX + 0.000, RLWRY + 0.010}, 1},
                    {{RLWRX, RLWRY}, 1}
                },
                { //Bottom left
                    {{RLWRX + 0.000, RLWRY + 0.010}, 1},
                    {{RLWRX - 0.007, RLWRY + 0.007}, 1}, 
                    {{RLWRX - 0.010, RLWRY + 0.000}, 1},
                    {{RLWRX, RLWRY}, 1}
                }
            };
        };
    };
    class lines_RLWR {
        type = line;
        width = 3;
        points[] = {
            //RLWR box
            MPD_POINTS_BOX(Null, MPD_POS_BUTTON_R_X-(2*MPD_TEXT_WIDTH), MPD_POS_BUTTON_LR_6_Y + 0.6*MPD_TEXT_HEIGHT, 2*MPD_TEXT_WIDTH, MPD_TEXT_HEIGHT-0.015),
        };
    };
    /*
    #define ASE_OBJ_01_ANGLE 0
    class lines_ASEObj01Track {
        color[] = {1,1,0,1};
        class Lines {
            type = line;
            width    = 3;
            points[] = {
                //ASE Object 0
                //--Dash 1
                {"ase_ownship", { __EVAL(-0.021 * cos ASE_OBJ_01_ANGLE), __EVAL(-0.021 * sin ASE_OBJ_01_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.043 * cos ASE_OBJ_01_ANGLE), __EVAL(-0.043 * sin ASE_OBJ_01_ANGLE)}, 1}, {},
                //--Dash 2
                {"ase_ownship", { __EVAL(-0.064 * cos ASE_OBJ_01_ANGLE), __EVAL(-0.064 * sin ASE_OBJ_01_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.086 * cos ASE_OBJ_01_ANGLE), __EVAL(-0.086 * sin ASE_OBJ_01_ANGLE)}, 1}, {},
                //--Dash 3
                {"ase_ownship", { __EVAL(-0.107 * cos ASE_OBJ_01_ANGLE), __EVAL(-0.107 * sin ASE_OBJ_01_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.129 * cos ASE_OBJ_01_ANGLE), __EVAL(-0.129 * sin ASE_OBJ_01_ANGLE)}, 1}, {},
                //--Dash 4
                {"ase_ownship", { __EVAL(-0.150 * cos ASE_OBJ_01_ANGLE), __EVAL(-0.150 * sin ASE_OBJ_01_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.171 * cos ASE_OBJ_01_ANGLE), __EVAL(-0.171 * sin ASE_OBJ_01_ANGLE)}, 1}, {},
                //--Dash 5
                {"ase_ownship", { __EVAL(-0.193 * cos ASE_OBJ_01_ANGLE), __EVAL(-0.193 * sin ASE_OBJ_01_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.214 * cos ASE_OBJ_01_ANGLE), __EVAL(-0.214 * sin ASE_OBJ_01_ANGLE)}, 1}, {},
                //--Dash 6
                {"ase_ownship", { __EVAL(-0.236 * cos ASE_OBJ_01_ANGLE), __EVAL(-0.236 * sin ASE_OBJ_01_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.257 * cos ASE_OBJ_01_ANGLE), __EVAL(-0.257 * sin ASE_OBJ_01_ANGLE)}, 1}, {},
            };
        };
    };
   #define ASE_OBJ_02_ANGLE 51
    class lines_ASEObj02Track {
        color[] = {1,1,0,1};
        class Lines {
            type = line;
            width    = 3;
            points[] = {
                //ASE Object 0
                //--Dash 1
                {"ase_ownship", { __EVAL(-0.021 * cos ASE_OBJ_02_ANGLE), __EVAL(-0.021 * sin ASE_OBJ_02_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.043 * cos ASE_OBJ_02_ANGLE), __EVAL(-0.043 * sin ASE_OBJ_02_ANGLE)}, 1}, {},
                //--Dash 2
                {"ase_ownship", { __EVAL(-0.064 * cos ASE_OBJ_02_ANGLE), __EVAL(-0.064 * sin ASE_OBJ_02_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.086 * cos ASE_OBJ_02_ANGLE), __EVAL(-0.086 * sin ASE_OBJ_02_ANGLE)}, 1}, {},
                //--Dash 3
                {"ase_ownship", { __EVAL(-0.107 * cos ASE_OBJ_02_ANGLE), __EVAL(-0.107 * sin ASE_OBJ_02_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.129 * cos ASE_OBJ_02_ANGLE), __EVAL(-0.129 * sin ASE_OBJ_02_ANGLE)}, 1}, {},
                //--Dash 4
                {"ase_ownship", { __EVAL(-0.150 * cos ASE_OBJ_02_ANGLE), __EVAL(-0.150 * sin ASE_OBJ_02_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.171 * cos ASE_OBJ_02_ANGLE), __EVAL(-0.171 * sin ASE_OBJ_02_ANGLE)}, 1}, {},
                //--Dash 5
                {"ase_ownship", { __EVAL(-0.193 * cos ASE_OBJ_02_ANGLE), __EVAL(-0.193 * sin ASE_OBJ_02_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.214 * cos ASE_OBJ_02_ANGLE), __EVAL(-0.214 * sin ASE_OBJ_02_ANGLE)}, 1}, {},
                //--Dash 6
                {"ase_ownship", { __EVAL(-0.236 * cos ASE_OBJ_02_ANGLE), __EVAL(-0.236 * sin ASE_OBJ_02_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.257 * cos ASE_OBJ_02_ANGLE), __EVAL(-0.257 * sin ASE_OBJ_02_ANGLE)}, 1}, {},
            };
        };
    };
    #define ASE_OBJ_03_ANGLE 103
    class lines_ASEObj03Track {
        color[] = {1,1,0,1};
        class Lines {
            type = line;
            width    = 3;
            points[] = {
                //ASE Object 0
                //--Dash 1
                {"ase_ownship", { __EVAL(-0.021 * cos ASE_OBJ_03_ANGLE), __EVAL(-0.021 * sin ASE_OBJ_03_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.043 * cos ASE_OBJ_03_ANGLE), __EVAL(-0.043 * sin ASE_OBJ_03_ANGLE)}, 1}, {},
                //--Dash 2
                {"ase_ownship", { __EVAL(-0.064 * cos ASE_OBJ_03_ANGLE), __EVAL(-0.064 * sin ASE_OBJ_03_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.086 * cos ASE_OBJ_03_ANGLE), __EVAL(-0.086 * sin ASE_OBJ_03_ANGLE)}, 1}, {},
                //--Dash 3
                {"ase_ownship", { __EVAL(-0.107 * cos ASE_OBJ_03_ANGLE), __EVAL(-0.107 * sin ASE_OBJ_03_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.129 * cos ASE_OBJ_03_ANGLE), __EVAL(-0.129 * sin ASE_OBJ_03_ANGLE)}, 1}, {},
                //--Dash 4
                {"ase_ownship", { __EVAL(-0.150 * cos ASE_OBJ_03_ANGLE), __EVAL(-0.150 * sin ASE_OBJ_03_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.171 * cos ASE_OBJ_03_ANGLE), __EVAL(-0.171 * sin ASE_OBJ_03_ANGLE)}, 1}, {},
                //--Dash 5
                {"ase_ownship", { __EVAL(-0.193 * cos ASE_OBJ_03_ANGLE), __EVAL(-0.193 * sin ASE_OBJ_03_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.214 * cos ASE_OBJ_03_ANGLE), __EVAL(-0.214 * sin ASE_OBJ_03_ANGLE)}, 1}, {},
                //--Dash 6
                {"ase_ownship", { __EVAL(-0.236 * cos ASE_OBJ_03_ANGLE), __EVAL(-0.236 * sin ASE_OBJ_03_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.257 * cos ASE_OBJ_03_ANGLE), __EVAL(-0.257 * sin ASE_OBJ_03_ANGLE)}, 1}, {},
            };
        };
    };
    #define ASE_OBJ_04_ANGLE 154
    class lines_ASEObj04Track {
        color[] = {1,1,0,1};
        class Lines {
            type = line;
            width    = 3;
            points[] = {
                //ASE Object 0
                //--Dash 1
                {"ase_ownship", { __EVAL(-0.021 * cos ASE_OBJ_04_ANGLE), __EVAL(-0.021 * sin ASE_OBJ_04_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.043 * cos ASE_OBJ_04_ANGLE), __EVAL(-0.043 * sin ASE_OBJ_04_ANGLE)}, 1}, {},
                //--Dash 2
                {"ase_ownship", { __EVAL(-0.064 * cos ASE_OBJ_04_ANGLE), __EVAL(-0.064 * sin ASE_OBJ_04_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.086 * cos ASE_OBJ_04_ANGLE), __EVAL(-0.086 * sin ASE_OBJ_04_ANGLE)}, 1}, {},
                //--Dash 3
                {"ase_ownship", { __EVAL(-0.107 * cos ASE_OBJ_04_ANGLE), __EVAL(-0.107 * sin ASE_OBJ_04_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.129 * cos ASE_OBJ_04_ANGLE), __EVAL(-0.129 * sin ASE_OBJ_04_ANGLE)}, 1}, {},
                //--Dash 4
                {"ase_ownship", { __EVAL(-0.150 * cos ASE_OBJ_04_ANGLE), __EVAL(-0.150 * sin ASE_OBJ_04_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.171 * cos ASE_OBJ_04_ANGLE), __EVAL(-0.171 * sin ASE_OBJ_04_ANGLE)}, 1}, {},
                //--Dash 5
                {"ase_ownship", { __EVAL(-0.193 * cos ASE_OBJ_04_ANGLE), __EVAL(-0.193 * sin ASE_OBJ_04_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.214 * cos ASE_OBJ_04_ANGLE), __EVAL(-0.214 * sin ASE_OBJ_04_ANGLE)}, 1}, {},
                //--Dash 6
                {"ase_ownship", { __EVAL(-0.236 * cos ASE_OBJ_04_ANGLE), __EVAL(-0.236 * sin ASE_OBJ_04_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.257 * cos ASE_OBJ_04_ANGLE), __EVAL(-0.257 * sin ASE_OBJ_04_ANGLE)}, 1}, {},
            };
        };
    };
    #define ASE_OBJ_05_ANGLE 206
    class lines_ASEObj05Track {
        color[] = {1,1,0,1};
        class Lines {
            type = line;
            width    = 3;
            points[] = {
                //ASE Object 0
                //--Dash 1
                {"ase_ownship", { __EVAL(-0.021 * cos ASE_OBJ_05_ANGLE), __EVAL(-0.021 * sin ASE_OBJ_05_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.043 * cos ASE_OBJ_05_ANGLE), __EVAL(-0.043 * sin ASE_OBJ_05_ANGLE)}, 1}, {},
                //--Dash 2
                {"ase_ownship", { __EVAL(-0.064 * cos ASE_OBJ_05_ANGLE), __EVAL(-0.064 * sin ASE_OBJ_05_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.086 * cos ASE_OBJ_05_ANGLE), __EVAL(-0.086 * sin ASE_OBJ_05_ANGLE)}, 1}, {},
                //--Dash 3
                {"ase_ownship", { __EVAL(-0.107 * cos ASE_OBJ_05_ANGLE), __EVAL(-0.107 * sin ASE_OBJ_05_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.129 * cos ASE_OBJ_05_ANGLE), __EVAL(-0.129 * sin ASE_OBJ_05_ANGLE)}, 1}, {},
                //--Dash 4
                {"ase_ownship", { __EVAL(-0.150 * cos ASE_OBJ_05_ANGLE), __EVAL(-0.150 * sin ASE_OBJ_05_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.171 * cos ASE_OBJ_05_ANGLE), __EVAL(-0.171 * sin ASE_OBJ_05_ANGLE)}, 1}, {},
                //--Dash 5
                {"ase_ownship", { __EVAL(-0.193 * cos ASE_OBJ_05_ANGLE), __EVAL(-0.193 * sin ASE_OBJ_05_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.214 * cos ASE_OBJ_05_ANGLE), __EVAL(-0.214 * sin ASE_OBJ_05_ANGLE)}, 1}, {},
                //--Dash 6
                {"ase_ownship", { __EVAL(-0.236 * cos ASE_OBJ_05_ANGLE), __EVAL(-0.236 * sin ASE_OBJ_05_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.257 * cos ASE_OBJ_05_ANGLE), __EVAL(-0.257 * sin ASE_OBJ_05_ANGLE)}, 1}, {},
            };
        };
    };
       #define ASE_OBJ_06_ANGLE 257
    class lines_ASEObj06Track {
        color[] = {1,1,0,1};
        class Lines {
            type = line;
            width    = 3;
            points[] = {
                //ASE Object 0
                //--Dash 1
                {"ase_ownship", { __EVAL(-0.021 * cos ASE_OBJ_06_ANGLE), __EVAL(-0.021 * sin ASE_OBJ_06_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.043 * cos ASE_OBJ_06_ANGLE), __EVAL(-0.043 * sin ASE_OBJ_06_ANGLE)}, 1}, {},
                //--Dash 2
                {"ase_ownship", { __EVAL(-0.064 * cos ASE_OBJ_06_ANGLE), __EVAL(-0.064 * sin ASE_OBJ_06_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.086 * cos ASE_OBJ_06_ANGLE), __EVAL(-0.086 * sin ASE_OBJ_06_ANGLE)}, 1}, {},
                //--Dash 3
                {"ase_ownship", { __EVAL(-0.107 * cos ASE_OBJ_06_ANGLE), __EVAL(-0.107 * sin ASE_OBJ_06_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.129 * cos ASE_OBJ_06_ANGLE), __EVAL(-0.129 * sin ASE_OBJ_06_ANGLE)}, 1}, {},
                //--Dash 4
                {"ase_ownship", { __EVAL(-0.150 * cos ASE_OBJ_06_ANGLE), __EVAL(-0.150 * sin ASE_OBJ_06_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.171 * cos ASE_OBJ_06_ANGLE), __EVAL(-0.171 * sin ASE_OBJ_06_ANGLE)}, 1}, {},
                //--Dash 5
                {"ase_ownship", { __EVAL(-0.193 * cos ASE_OBJ_06_ANGLE), __EVAL(-0.193 * sin ASE_OBJ_06_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.214 * cos ASE_OBJ_06_ANGLE), __EVAL(-0.214 * sin ASE_OBJ_06_ANGLE)}, 1}, {},
                //--Dash 6
                {"ase_ownship", { __EVAL(-0.236 * cos ASE_OBJ_06_ANGLE), __EVAL(-0.236 * sin ASE_OBJ_06_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.257 * cos ASE_OBJ_06_ANGLE), __EVAL(-0.257 * sin ASE_OBJ_06_ANGLE)}, 1}, {},
            };
        };
    };
    #define ASE_OBJ_07_ANGLE 309
    class lines_ASEObj07Track {
        color[] = {1,1,0,1};
        class Lines {
            type = line;
            width    = 3;
            points[] = {
                //ASE Object 0
                //--Dash 1
                {"ase_ownship", { __EVAL(-0.021 * cos ASE_OBJ_07_ANGLE), __EVAL(-0.021 * sin ASE_OBJ_07_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.043 * cos ASE_OBJ_07_ANGLE), __EVAL(-0.043 * sin ASE_OBJ_07_ANGLE)}, 1}, {},
                //--Dash 2
                {"ase_ownship", { __EVAL(-0.064 * cos ASE_OBJ_07_ANGLE), __EVAL(-0.064 * sin ASE_OBJ_07_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.086 * cos ASE_OBJ_07_ANGLE), __EVAL(-0.086 * sin ASE_OBJ_07_ANGLE)}, 1}, {},
                //--Dash 3
                {"ase_ownship", { __EVAL(-0.107 * cos ASE_OBJ_07_ANGLE), __EVAL(-0.107 * sin ASE_OBJ_07_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.129 * cos ASE_OBJ_07_ANGLE), __EVAL(-0.129 * sin ASE_OBJ_07_ANGLE)}, 1}, {},
                //--Dash 4
                {"ase_ownship", { __EVAL(-0.150 * cos ASE_OBJ_07_ANGLE), __EVAL(-0.150 * sin ASE_OBJ_07_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.171 * cos ASE_OBJ_07_ANGLE), __EVAL(-0.171 * sin ASE_OBJ_07_ANGLE)}, 1}, {},
                //--Dash 5
                {"ase_ownship", { __EVAL(-0.193 * cos ASE_OBJ_07_ANGLE), __EVAL(-0.193 * sin ASE_OBJ_07_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.214 * cos ASE_OBJ_07_ANGLE), __EVAL(-0.214 * sin ASE_OBJ_07_ANGLE)}, 1}, {},
                //--Dash 6
                {"ase_ownship", { __EVAL(-0.236 * cos ASE_OBJ_07_ANGLE), __EVAL(-0.236 * sin ASE_OBJ_07_ANGLE)}, 1},
                {"ase_ownship", { __EVAL(-0.257 * cos ASE_OBJ_07_ANGLE), __EVAL(-0.257 * sin ASE_OBJ_07_ANGLE)}, 1}, {},
            };
        };
    };*/

    class ase_threats_gnd {
        type            = sensor;
        pos[]           = {{0.175, 0.175}, 1};  //top left of circle
        down[]          = {{0.825, 0.825}, 1};  //bottom right of circle
        showTargetTypes = 2+8+16+32+64+128+1024;
        /***
        1 - Sensor sectors,
        2 - Threats,
        4 - Marked tgt symbol,
        8 - Own detection,
        16 - Remote detection,
        32 - Active detection,
        64 - Passive detection,
        128 - Ground tgts,
        256 - Air tgts,
        512 - Men,
        1024 - Special (laser, NV)
        ***/
        width             = 3;    //When 1 is included in showTargetTypes, controls thickness of radar circle
        sensorLineType    = 0;    //Same as lineType
        sensorLineWidth   = 3;    //0 sets the default launch cone indicator to invisible
        range             = 5000;
        
        /*class MissileThreat { <-- No MWS so a whole lotta nope here.
            color[] = {1,1,0,1};
            class TargetLines {
                type = line;
                width = 3;
                points[] = {
                    {{-0.04,  0.04}, 1},
                    {{ 0.04,  0.04}, 1},
                    {{ 0.04, -0.04}, 1},
                    {{-0.04, -0.04}, 1},
                    {{-0.04,  0.04}, 1},
                };
            };
        };*/
        class rwr { //Radar is emitting
            color[] = {1,1,0,1};
            class TargetLines {
                type = line;
                width = 3;
                points[] = {
                    //ADU symbol
                    {{ 0.000,-0.005}, 1},
                    {{ 0.015, 0.025}, 1},
                    {{-0.015, 0.025}, 1},
                    {{ 0.000,-0.005}, 1}
                };
            };
            class Text {
                type        ="text";
                source      ="static";
                text        ="S A";
                scale       =1;
                sourceScale =1;
                align       = "center";
                pos[]       = {{ 0.000,        -0.040    }, 1};
                right[]     = {{ 0.000 + 0.04, -0.040    }, 1};
                down[]      = {{ 0.000,        -0.040 + 0.04}, 1};
            }; 
        };
        class markingThreat: rwr {   //Radar tracking (acquisition)
            color[] = {1,1,0,1};
            class TargetLines : TargetLines {
                points[] = {
                    //ADU symbol
                    {{ 0.000,-0.005}, 1},
                    {{ 0.015, 0.025}, 1},
                    {{-0.015, 0.025}, 1},
                    {{ 0.000,-0.005}, 1}, {},
                    //Acquistion/Tracking Box
                    {{-0.04,  0.04}, 1},
                    {{ 0.04,  0.04}, 1},
                    {{ 0.04, -0.04}, 1},
                    {{-0.04, -0.04}, 1},
                    {{-0.04,  0.04}, 1},
                };
            };
          class Text {
                type        ="text";
                source      ="static";
                text        ="S A";
                scale       =1;
                sourceScale =1;
                align       = "center";
                pos[]       = {{ 0.000,        -0.040    }, 1};
                right[]     = {{ 0.000 + 0.04, -0.040    }, 1};
                down[]      = {{ 0.000,        -0.040 + 0.04}, 1};
            }; 
        };
        class lockingThreat: rwr {   //Radar is locked on (track/launch)
            color[] = {1,1,0,1};
            class TargetLines : TargetLines {
                points[] = {
                    //ADU symbol
                    {{ 0.000,-0.005}, 1},
                    {{ 0.015, 0.025}, 1},
                    {{-0.015, 0.025}, 1},
                    {{ 0.000,-0.005}, 1}, {},
                    //Acquistion/Tracking Box
                    {{-0.04,  0.04}, 1},
                    {{ 0.04,  0.04}, 1},
                    {{ 0.04, -0.04}, 1},
                    {{-0.04, -0.04}, 1},
                    {{-0.04,  0.04}, 1},
                };
            };
            class Text {
                type        ="text";
                source      ="static";
                text        ="S A";
                scale       =1;
                sourceScale =1;
                align       = "center";
                pos[]       = {{ 0.000,        -0.040    }, 1};
                right[]     = {{ 0.000 + 0.04, -0.040    }, 1};
                down[]      = {{ 0.000,        -0.040 + 0.04}, 1};
            };  
        };
    };

    //Ownship Icon
    class lines_ownshipIcon {
        color[] = {0,1,1,1};
        class Lines {
            type = line;
            width = 3;
            points[] = {
                //Ownship rotor
                {"ase_ownship", { 0.020,  0.000}, 1},
                {"ase_ownship", { 0.014, -0.014}, 1},
                {"ase_ownship", { 0.000, -0.020}, 1},
                {"ase_ownship", {-0.014, -0.014}, 1},
                {"ase_ownship", {-0.020,  0.000}, 1},
                {"ase_ownship", {-0.014,  0.014}, 1},
                {"ase_ownship", { 0.000,  0.020}, 1},
                {"ase_ownship", { 0.014,  0.014}, 1},
                {"ase_ownship", { 0.020,  0.000}, 1},
                {},
                //Tail boom line
                {"ase_ownship", { 0.000, 0.020}, 1},
                {"ase_ownship", { 0.000, 0.040}, 1},
                {},
                //Tail rotor axle line
                {"ase_ownship", { 0.000, 0.040}, 1},
                {"ase_ownship", {-0.0125, 0.040}, 1},
                {},
                //Tail rotor line
                {"ase_ownship", {-0.0125, 0.030}, 1},
                {"ase_ownship", {-0.0125, 0.05}, 1},
                {},
                //Ownship center dot
                {"ase_ownship", { 0.000,  0.0025}, 1},
                {"ase_ownship", { 0.000, -0.0025}, 1},
            };
        };
    };

    class polys {

    };

    class vabs {
        //T1
        MPD_TEXT_C(CHAFF_1,   MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("CHAFF"))
        MPD_BOX_C(CHAFF_2,    MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y + MPD_TEXT_HEIGHT, 4)
        //T2
        MPD_BOX_TALL_C(ASE, MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_T_Y, 3)
        MPD_ARROW_C(ASE,    MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_T_Y, 3)
        MPD_TEXT_C(ASE,     MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("ASE"))
        //T6
        MPD_BOX_BAR_T(UTIL, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y)
        //MPD_ARROW_C(UTIL, MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, 4)
        MPD_TEXT_C(UTIL,    MPD_POS_BUTTON_TB_6_X, MPD_POS_BUTTON_T_Y, MPD_TEXT_STATIC("UTIL"))
        
        //R1
        MPD_TEXT_L(IRJAM_1, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("IRJAM "))
        //R4
        MPD_BOX_BAR_L(CTR, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y)
        MPD_TEXT_L(CTR,    MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_4_Y, MPD_TEXT_STATIC("CAQ"))
        //R6
        MPD_TEXT_L(RLWR_1, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("RLWR "))
        //MPD_BOX_L(PGM,   MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y + 0.5*MPD_TEXT_HEIGHT, 2)
        MPD_TEXT_L(RLWR_2, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("7"))

        //B1 or M
        MPD_TEXT_C(TSD,  MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("TSD"))
        //B4
        MPD_TEXT_C(OFF,  MPD_POS_BUTTON_TB_4_X+0.025, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("OFF"))
        //B5
        MPD_TEXT_C(STBY, MPD_POS_BUTTON_TB_5_X+0.0125, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("STBY"))
        //B6
        MPD_TEXT_C(OPER, MPD_POS_BUTTON_TB_6_X+0.0125, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("OPER"))

        //L1
        MPD_TEXT_R(MODE,  MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y - 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("CHAFF MODE"))
        MPD_BOX_R(PGM,    MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, 7)
        MPD_TEXT_R(PGM,   MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("PROGRAM"))
        //L3
        MPD_TEXT_R(SRH_1, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y - 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("S"))
        MPD_TEXT_R(SRH_2, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y,                        MPD_TEXT_STATIC("R"))
        MPD_TEXT_R(SRH_3, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y + 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("H"))
        //L4
        MPD_TEXT_R(ACQ_1, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y - 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("A"))
        MPD_TEXT_R(ACQ_2, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y,                        MPD_TEXT_STATIC("C"))
        MPD_TEXT_R(ACQ_3, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y + 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("Q"))
        //L5
        MPD_TEXT_R(TRK_1, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y - 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("T"))
        MPD_TEXT_R(TRK_2, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y,                        MPD_TEXT_STATIC("R"))
        MPD_TEXT_R(TRK_3, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y + 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("K"))
        //L6
        MPD_TEXT_R(OFF_1, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y - 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("O"))
        MPD_TEXT_R(OFF_2, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y,                        MPD_TEXT_STATIC("F"))
        MPD_TEXT_R(OFF_3, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y + 0.75*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("F"))
    };

    class text_ChaffSafe {
        MPD_TEXT_C(CHAFF_2,   MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y + MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("SAFE"))
    };
    class text_ChaffArm {
        //MPD_TEXT_C(CHAFF_2,   MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_T_Y + MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("ARM"))
    };

    class textBox_RJAMOff {
         MPD_BOX_C(OFF,  MPD_POS_BUTTON_TB_4_X+0.025, MPD_POS_BUTTON_B_Y, 3)
    };
    class textBox_RJAMStby {
        MPD_BOX_C(STBY,  MPD_POS_BUTTON_TB_5_X+0.0125, MPD_POS_BUTTON_B_Y, 4)
    };
    class textBox_RJAMOper {
        MPD_BOX_C(OPER,  MPD_POS_BUTTON_TB_6_X+0.0125, MPD_POS_BUTTON_B_Y, 4)
    };

    class text_IRJamWarm {
        //R1
        //MPD_TEXT_L(IRJAM_2, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("WARM"))
    };
    class text_IRJamOper {
        //R1
        MPD_TEXT_L(IRJAM_2, MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y + 0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("OPER"))
    };

    class textBox_AutopageSrh {
        MPD_BOX_V(SRH, MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_3_Y, 3)
    };
    class textBox_AutopageAcq {
        MPD_BOX_V(ACQ,  MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_4_Y, 3)
    };
    class textBox_AutopageTrk {
        MPD_BOX_V(TRK,  MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_5_Y, 3)
    };
    class textBox_AutopageOff {
        MPD_BOX_V(OFF,  MPD_POS_BUTTON_L_X, MPD_POS_BUTTON_LR_6_Y, 3)
    };

    class text {
        //Autopage text
        MPD_TEXT_R(AUTOPAGE_01, 0.08, 0.600-3.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("A"))
        MPD_TEXT_R(AUTOPAGE_02, 0.08, 0.600-2.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("U"))
        MPD_TEXT_R(AUTOPAGE_03, 0.08, 0.600-1.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("T"))
        MPD_TEXT_R(AUTOPAGE_04, 0.08, 0.600-0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("O")) //Mid
        MPD_TEXT_R(AUTOPAGE_05, 0.08, 0.600+0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("P")) //Mid
        MPD_TEXT_R(AUTOPAGE_06, 0.08, 0.600+1.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("A"))
        MPD_TEXT_R(AUTOPAGE_07, 0.08, 0.600+2.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("G"))
        MPD_TEXT_R(AUTOPAGE_08, 0.08, 0.600+3.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("E"))

        //RJAM text
        MPD_TEXT_C(RJAM_01,  0.718 - 1.5*MPD_TEXT_WIDTH, 0.93 - MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("R"))
        MPD_TEXT_C(RJAM_02,  0.718 - 0.5*MPD_TEXT_WIDTH, 0.93 - MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("J"))
        MPD_TEXT_C(RJAM_03,  0.718 + 0.5*MPD_TEXT_WIDTH, 0.93 - MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("A"))
        MPD_TEXT_C(RJAM_04,  0.718 + 1.5*MPD_TEXT_WIDTH, 0.93 - MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("M"))

        //Chaff count box
        MPD_TEXT_C(CHAFF_COUNT_1,  MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_B_Y - 3*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("CHAFF"))
        MPD_TEXT_C(CHAFF_COUNT_2,  MPD_POS_BUTTON_TB_1_X, MPD_POS_BUTTON_B_Y - 2*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("30"))

        // Hdg info
        MPD_TEXT_C(HeadingHigh, 0.5, MPD_POS_BUTTON_T_Y, source = heading; sourceScale = 1;)
        MPD_TEXT_C(HeadingLow,  0.5, MPD_POS_BUTTON_B_Y, MPD_TEXT_STATIC("360"))
    };
};