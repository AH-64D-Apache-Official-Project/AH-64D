class StatusWindows {
    class Static {
        type = line;
        width = 3;
        points[] = {
            //Sight Box
            MPD_POINTS_BOX_PAD(Null, 0.27, 0.13, 0.09, 0.06, 0.02), {},
            //ACQ
            MPD_POINTS_BOX_PAD(Null, 0.64, 0.13, 0.09, 0.06, 0.02), {},
            //LST
            MPD_POINTS_BOX_PAD(Null, 0.27, 0.26, 0.07, 0.05, 0.02), {},
            //LRFD
            MPD_POINTS_BOX_PAD(Null, 0.66, 0.26, 0.07, 0.05, 0.02), {},
            //Chaff
            MPD_POINTS_BOX_PAD(Null, 0.46, 0.601, 0.08, 0.12, 0.02), {},
        };
    };

    MPD_TEXT_C(Sight_Label, 0.315, 0.12, MPD_TEXT_STATIC("SIGHT"))
    MPD_TEXT_C(Sight, 0.315, 0.12+MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_WPN_SIGHT))
    MPD_TEXT_C(ACQ_Label, 0.685, 0.12, MPD_TEXT_STATIC("ACQ"))
    MPD_TEXT_C(ACQ, 0.685, 0.12+MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_WPN_ACQ))

    MPD_TEXT_C(LST_Label, 0.305, 0.24, MPD_TEXT_STATIC("LST"))
    MPD_TEXT_C(LST, 0.305, 0.24+MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("B"))
    MPD_TEXT_C(LRFD_Label, 0.695, 0.24, MPD_TEXT_STATIC("LRFD"))
    MPD_TEXT_C(LRFD, 0.695, 0.24+MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("A"))

    MPD_TEXT_C(Chaff_Label, 0.5, 0.59, MPD_TEXT_STATIC("CHAFF"))
    MPD_TEXT_C(Chaff_Qty, 0.5, 0.59+MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_WPN_CHAFF_QTY))
    class ChaffArming {
        class Safe {
            condition =  __EVAL(format ["1 - user%1", MFD_OFFSET + MFD_IND_WPN_CHAFF_ARM]);
            MPD_TEXT_C(Chaff_Armed, 0.5, 0.60+2*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("SAFE"))
        };
        class Arm {
            condition = __EVAL(format ["user%1", MFD_OFFSET + MFD_IND_WPN_CHAFF_ARM]);
            class Yellow {
                color[] = {1,1,0,1};
                class Polygon {
                    type = polygon;
                    points[] = {
                        {
                            {{0.5-1.5*MPD_TEXT_WIDTH, 0.60+2*MPD_TEXT_HEIGHT}, 1},
                            {{0.5+1.5*MPD_TEXT_WIDTH, 0.60+2*MPD_TEXT_HEIGHT}, 1},
                            {{0.5+1.5*MPD_TEXT_WIDTH, 0.60+3*MPD_TEXT_HEIGHT}, 1},
                            {{0.5-1.5*MPD_TEXT_WIDTH, 0.60+3*MPD_TEXT_HEIGHT}, 1}
                        },
                    };
                };
            };
            class Black {
                color[] = {0,0,0,1};
                MPD_TEXT_C(Chaff_Armed, 0.5, 0.60+2*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("ARM"))
            };
        };
    };
};