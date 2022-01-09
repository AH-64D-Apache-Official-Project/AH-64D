class InfoBoxes {

    class Wind {
        condition = C_COND(C_MPD_USER(MFD_IND_TSD_ROOT_SHOW_WIND));
        class Occluder {
            color[] = {0,0,0,1};
            class Polygons {
                type = polygon;
                points[] = {
                    MPD_POINTS_BOX_POLY(Null, 0.7, 0.8, 7*MPD_TEXT_WIDTH+0.005, MPD_TEXT_HEIGHT-0.01) //Wind info
                };
            };
        };
        class Box {
            type = line;
            width = 3;
            points[] = {
                MPD_POINTS_BOX(Null, 0.7, 0.8, 7*MPD_TEXT_WIDTH+0.005, MPD_TEXT_HEIGHT-0.01) //Wind info
            };
        };
        // Wind info
        MPD_TEXT_R(WindInfo, 0.7, 0.8, MPD_TEXT_STATIC("CALM"))
    };

    class Endurance {
        condition = C_COND(C_MPD_USER(MFD_IND_TSD_ROOT_SHOW_ENDR));
        class Occluder {
            color[] = {0,0,0,1};
            class Polygons {
                type = polygon;
                points[] = {
                    MPD_POINTS_BOX_POLY(Null, 0.7+MPD_TEXT_WIDTH, 0.73+0.005, 6*MPD_TEXT_WIDTH, MPD_TEXT_HEIGHT-0.01) //Endurance
                };
            };
        };
        class Box {
            type = line;
            width = 3;
            points[] = {
                MPD_POINTS_BOX(Null, 0.7+MPD_TEXT_WIDTH, 0.73+0.005, 6*MPD_TEXT_WIDTH, MPD_TEXT_HEIGHT-0.01) //Endurance
            };
        };

        // Endurance info
        MPD_TEXT_L(Endurance, 0.7+7*MPD_TEXT_WIDTH, 0.73, MPD_TEXT_USER(MFD_TEXT_IND_TSD_ROOT_ENDR))
        MPD_TEXT_SMALL_R(EnduranceLabel, 0.7+MPD_TEXT_WIDTH, 0.73+MPD_TEXT_HEIGHT-MPD_TEXT_SMALL_HEIGHT, MPD_TEXT_STATIC("EN"))
    };

    class WaypointData {
        condition = C_COND(C_AND(C_NOT(C_MPD_USER(MFD_IND_TSD_PHASE)), C_MPD_USER(MFD_IND_TSD_ROOT_SHOW_WPT_DATA_CURRTE)));

        class Occluders {
            color[] = {0,0,0,1};
            class Polygons {
                type = polygon;
                points[] = {
                    MPD_POINTS_BOX_POLY(Null, 0.15, 0.7, 0.25, 2*MPD_TEXT_HEIGHT) //Waypoint info
                };
            };
        };

        class Boxes {
            type = line;
            width = 3;
            points[] = {
                MPD_POINTS_BOX(Null, 0.15, 0.7, 0.25, 2*MPD_TEXT_HEIGHT) //Waypoint info
            };
        };

        //Waypoint info
        MPD_TEXT_R(WaypointNum, 0.15, 0.7, MPD_TEXT_USER(MFD_TEXT_IND_TSD_ROOT_WPDEST))
        MPD_TEXT_R(WaypointGS, 0.15, 0.7+MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_TSD_ROOT_GROUNDSPEED))
        MPD_TEXT_L(WaypointDist, 0.4, 0.7, MPD_TEXT_USER(MFD_TEXT_IND_TSD_ROOT_WPDIST))
        MPD_TEXT_L(WaypointTime, 0.4, 0.7+MPD_TEXT_HEIGHT, MPD_TEXT_USER(MFD_TEXT_IND_TSD_ROOT_WPETA))
    };
};