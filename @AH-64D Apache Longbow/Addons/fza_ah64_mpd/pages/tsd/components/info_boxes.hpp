class InfoBoxes {
    class Occluders {
        color[] = {0,0,0,1};
        class Polygons {
            type = polygon;
            points[] = {
                MPD_POINTS_BOX_POLY(Null, 0.7, 0.8, 7*MPD_TEXT_WIDTH+0.005, MPD_TEXT_HEIGHT-0.01), //Wind info
                MPD_POINTS_BOX_POLY(Null, 0.7+MPD_TEXT_WIDTH, 0.73+0.005, 6*MPD_TEXT_WIDTH, MPD_TEXT_HEIGHT-0.01) //Endurance
            };
        };
    };

    class Boxes {
        type = line;
        width = 3;
        points[] = {
            MPD_POINTS_BOX(Null, 0.7, 0.8, 7*MPD_TEXT_WIDTH+0.005, MPD_TEXT_HEIGHT-0.01), {}, //Wind info
            MPD_POINTS_BOX(Null, 0.7+MPD_TEXT_WIDTH, 0.73+0.005, 6*MPD_TEXT_WIDTH, MPD_TEXT_HEIGHT-0.01) //Endurance
        };
    };

    // Wind info
    MPD_TEXT_R(WindInfo, 0.7, 0.8, MPD_TEXT_STATIC("120*/15"))

    // Endurance info
    MPD_TEXT_L(Endurance, 0.7+7*MPD_TEXT_WIDTH, 0.73, MPD_TEXT_STATIC("2:13"))
    MPD_TEXT_SMALL_R(EnduranceLabel, 0.7+MPD_TEXT_WIDTH, 0.73+MPD_TEXT_HEIGHT-MPD_TEXT_SMALL_HEIGHT, MPD_TEXT_STATIC("EN"))

    class NavOnlyInfo {
        condition = __EVAL(format["1 - user%1", MFD_IND_TSD_PHASE + MFD_OFFSET]);

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
        MPD_TEXT_R(WaypointNum, 0.15, 0.7, MPD_TEXT_STATIC("W02"))
        MPD_TEXT_R(WaypointGS, 0.15, 0.7+MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("100"))
        MPD_TEXT_L(WaypointDist, 0.4, 0.7, MPD_TEXT_STATIC("0.5KM"))
        MPD_TEXT_L(WaypointTime, 0.4, 0.7+MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("0:18"))
    };
};