#define WPN_CHECKER(posX, posY) \
    {\
        {{posX - 0.01, posY - 0.01}, 1},\
        {{posX + 0.01, posY - 0.01}, 1},\
        {{posX + 0.01, posY + 0.01}, 1},\
        {{posX - 0.01, posY + 0.01}, 1},\
    }

#define WPN_CHECKERS \
    WPN_CHECKER(0.535, 0.093),\
    WPN_CHECKER(0.5, 0.093),\
    WPN_CHECKER(0.465, 0.093),\
    WPN_CHECKER(0.445, 0.117),\
    WPN_CHECKER(0.445, 0.143),\
    WPN_CHECKER(0.535, 0.167),\
    WPN_CHECKER(0.5, 0.167),\
    WPN_CHECKER(0.465, 0.167),\
    WPN_CHECKER(0.555, 0.117),\
    WPN_CHECKER(0.555, 0.143)

class ArmSafe {
    class Safe {
        condition = __EVAL(format["1-user%1", MFD_OFFSET+MFD_IND_WPN_MASTER_ARM]);
        MPD_TEXT_C(Safe, 0.5, 0.13-0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("SAFE"))
        //Safe Box
        class Static {
            type = line;
            width = 3;
            points[] = {
                MPD_POINTS_BOX_PAD(Null, 0.45, 0.1, 0.10, 0.06, 0.02)
            };
        };
    };
    class Safe_WAS {
        condition = __EVAL(format["(1-user%1) * user%2", MFD_OFFSET+MFD_IND_WPN_MASTER_ARM, MFD_OFFSET+MFD_IND_WPN_WAS]);
        class Polygons {
            type = polygon;
            points[] = {
                WPN_CHECKERS
            };
        };
    };
    class Arm {
        condition = __EVAL(format["user%1", MFD_OFFSET+MFD_IND_WPN_MASTER_ARM]);
        color[] = {1,1,0,1};
        class Polygons {
            type = polygon;
            points[] = {
                {
                    {{0.4300, 0.1000}, 1},  //upper left corner
                    {{0.4327, 0.0900}, 1},
                    {{0.4500, 0.1000}, 1},
                }, {
                    {{0.4327, 0.0900}, 1},
                    {{0.4400, 0.0827}, 1},
                    {{0.4500, 0.1000}, 1},
                }, {
                    {{0.4400, 0.0827}, 1},
                    {{0.4500, 0.0800}, 1},
                    {{0.4500, 0.1000}, 1},
                }, {
                    {{0.4500, 0.1000}, 1}, //top box
                    {{0.4500, 0.0800}, 1},
                    {{0.5500, 0.0800}, 1},
                    {{0.5500, 0.1000}, 1},
                }, {
                    {{0.5500, 0.0800}, 1}, //upper right corner
                    {{0.5600, 0.0827}, 1},
                    {{0.5500, 0.1000}, 1},
                }, {
                    {{0.5600, 0.0827}, 1},
                    {{0.5673, 0.0900}, 1},
                    {{0.5500, 0.1000}, 1},
                }, {
                    {{0.5673, 0.0900}, 1},
                    {{0.5700, 0.1000}, 1},
                    {{0.5500, 0.1000}, 1},
                }, {
                    {{0.5500, 0.1000}, 1}, //right box
                    {{0.5700, 0.1000}, 1},
                    {{0.5700, 0.1600}, 1},
                    {{0.5500, 0.1600}, 1},
                }, {
                    {{0.5500, 0.1800}, 1}, //bottom right corner
                    {{0.5600, 0.1773}, 1},
                    {{0.5500, 0.1600}, 1},
                }, {
                    {{0.5600, 0.1773}, 1},
                    {{0.5673, 0.1700}, 1},
                    {{0.5500, 0.1600}, 1},
                }, {
                    {{0.5673, 0.1700}, 1},
                    {{0.5700, 0.1600}, 1},
                    {{0.5500, 0.1600}, 1},
                },  {
                    {{0.4500, 0.1800}, 1}, //bottom box
                    {{0.5500, 0.1800}, 1},
                    {{0.5500, 0.1600}, 1},
                    {{0.4500, 0.1600}, 1},
                }, {
                    {{0.4500, 0.1800}, 1}, //bottom left corner
                    {{0.4400, 0.1773}, 1},
                    {{0.4500, 0.1600}, 1},
                }, {
                    {{0.4400, 0.1773}, 1},
                    {{0.4327, 0.1700}, 1},
                    {{0.4500, 0.1600}, 1},
                }, {
                    {{0.4327, 0.1700}, 1},
                    {{0.4300, 0.1600}, 1},
                    {{0.4500, 0.1600}, 1},
                }, {
                    {{0.4300, 0.1000}, 1}, //left box
                    {{0.4500, 0.1000}, 1},
                    {{0.4500, 0.1600}, 1},
                    {{0.4300, 0.1600}, 1},
                }, {
                    {{0.4300, 0.1000}, 1}, //center box
                    {{0.5500, 0.1000}, 1},
                    {{0.5500, 0.1600}, 1},
                    {{0.4300, 0.1600}, 1},
                }
            };
        }
        class Black {
            color[] = {0,0,0,1};
            MPD_TEXT_C(Arm, 0.5, 0.13-0.5*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("ARM"))
        }
    };
    class Arm_WAS {
        condition = __EVAL(format["user%1 * user%2", MFD_OFFSET+MFD_IND_WPN_MASTER_ARM, MFD_OFFSET+MFD_IND_WPN_WAS]);
        color[] = {0,0,0,1};
        class Polygons {
            type = polygon;
            points[] = {
                WPN_CHECKERS
            };
        };
    };
};