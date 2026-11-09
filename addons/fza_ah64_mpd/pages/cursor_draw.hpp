// The MPD cursor (fza_mpd_fnc_cursorUpdate), on the MPD it is on, after the page so it is drawn over it. The labels of the
// VAB it is on are drawn bold by their own copies (headers\cursor_bold.hpp).
#define MPD_CURSOR_POINT(px,py) {"MPD_Cursor_X", {px, py}, 1, "MPD_Cursor_Y", 1}

// A ring with four diagonal spokes, centred on the cursor's position
class Cursor {
    condition = C_COND(C_AND(C_MORE(C_USER(MFD_IND_CURSOR_X), MPD_CURSOR_X_BASE - 0.5), C_LESS(C_USER(MFD_IND_CURSOR_X), MPD_CURSOR_X_BASE + 1.5)));
    color[] = MPD_COLOUR_GREEN;
    // The ring and spokes, except where the FCR zoom box or the panning arrows take their place. On a TSD point it can
    // choose, the TSD page draws the cursor under the point and its text (ui\tsd\tsd.js); on an FCR target, the ring
    // gives way to the target, drawn over a black circle (scope.js), and the spokes stay round it.
    class Normal {
        condition = C_COND(C_AND(C_NOT(C_AND(C_AND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_FCR), C_EQ(C_MPD_USER(MFD_IND_FCR_ZOOM), 1)), C_AND(C_MPD_USER(MFD_IND_FCR_CURSOR_AREA), C_LESS(C_MPD_USER(MFD_IND_CURSOR_VAB), 100.5)))), C_AND(C_NOT(C_AND(C_AND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_TSD), C_EQ(C_MPD_USER(MFD_IND_TSD_SUBPAGE), 5)), C_AND(C_MPD_USER(MFD_IND_TSD_CURSOR_MAP), C_LESS(C_MPD_USER(MFD_IND_CURSOR_VAB), 100.5)))), C_NOT(C_AND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_TSD), C_MPD_USER(MFD_IND_TSD_CURSOR_POINT))))));
        class RingGate {
            condition = C_COND(C_NOT(C_OR(C_AND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_TSD), C_MPD_USER(MFD_IND_TSD_CURSOR_POINT)), C_AND(C_OR(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_FCR), C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_FCRRMAP)), C_MPD_USER(MFD_IND_FCR_CURSOR_TARGET)))));
            class Ring {
                type = "line";
                width = MPD_CURSOR_BOLD_WIDTH;
                points[] = {
                    MPD_CURSOR_POINT(0, -0.019),
                    MPD_CURSOR_POINT(0.00492, -0.01835),
                    MPD_CURSOR_POINT(0.0095, -0.01645),
                    MPD_CURSOR_POINT(0.01344, -0.01344),
                    MPD_CURSOR_POINT(0.01645, -0.0095),
                    MPD_CURSOR_POINT(0.01835, -0.00492),
                    MPD_CURSOR_POINT(0.019, 0),
                    MPD_CURSOR_POINT(0.01835, 0.00492),
                    MPD_CURSOR_POINT(0.01645, 0.0095),
                    MPD_CURSOR_POINT(0.01344, 0.01344),
                    MPD_CURSOR_POINT(0.0095, 0.01645),
                    MPD_CURSOR_POINT(0.00492, 0.01835),
                    MPD_CURSOR_POINT(0, 0.019),
                    MPD_CURSOR_POINT(-0.00492, 0.01835),
                    MPD_CURSOR_POINT(-0.0095, 0.01645),
                    MPD_CURSOR_POINT(-0.01344, 0.01344),
                    MPD_CURSOR_POINT(-0.01645, 0.0095),
                    MPD_CURSOR_POINT(-0.01835, 0.00492),
                    MPD_CURSOR_POINT(-0.019, 0),
                    MPD_CURSOR_POINT(-0.01835, -0.00492),
                    MPD_CURSOR_POINT(-0.01645, -0.0095),
                    MPD_CURSOR_POINT(-0.01344, -0.01344),
                    MPD_CURSOR_POINT(-0.0095, -0.01645),
                    MPD_CURSOR_POINT(-0.00492, -0.01835),
                    MPD_CURSOR_POINT(0, -0.019)
                };
            };
        };
        class Spokes {
            type = "line";
            width = MPD_CURSOR_BOLD_WIDTH;
            points[] = {
                MPD_CURSOR_POINT(0.01237, -0.01237), MPD_CURSOR_POINT(0.03323, -0.03323),
                {},
                MPD_CURSOR_POINT(0.01237, 0.01237), MPD_CURSOR_POINT(0.03323, 0.03323),
                {},
                MPD_CURSOR_POINT(-0.01237, 0.01237), MPD_CURSOR_POINT(-0.03323, 0.03323),
                {},
                MPD_CURSOR_POINT(-0.01237, -0.01237), MPD_CURSOR_POINT(-0.03323, -0.03323)
            };
        };
    };
    // Central crosshairs, white, the spokes carried on inside the ring: where the cursor chooses symbols, over the map on
    // the TSD pages that take a point from it (fza_mpd_fnc_cursorPoint) and while CAQ chooses one, and over the FCR's
    // target area but while ZOOM chooses an area (fza_mpd_fnc_cursorInArea). Not while on a symbol, which is drawn there.
    class Crosshair {
        condition = C_COND(C_AND(C_OR(C_AND(C_AND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_TSD), C_MPD_USER(MFD_IND_TSD_CURSOR_MAP)), C_OR(C_OR(C_AND(C_MORE(C_MPD_USER(MFD_IND_TSD_SUBPAGE), 1.5), C_LESS(C_MPD_USER(MFD_IND_TSD_SUBPAGE), 4.5)), C_EQ(C_MPD_USER(MFD_IND_TSD_SUBPAGE), 6)), C_AND(C_EQ(C_MPD_USER(MFD_IND_TSD_SUBPAGE), 0), C_MPD_USER(MFD_IND_TSD_CAQ)))), C_AND(C_AND(C_OR(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_FCR), C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_FCRRMAP)), C_MPD_USER(MFD_IND_FCR_CURSOR_AREA)), C_NOT(C_EQ(C_MPD_USER(MFD_IND_FCR_ZOOM), 1)))), C_NOT(C_OR(C_AND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_TSD), C_MPD_USER(MFD_IND_TSD_CURSOR_POINT)), C_AND(C_OR(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_FCR), C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_FCRRMAP)), C_MPD_USER(MFD_IND_FCR_CURSOR_TARGET))))));
        color[] = MPD_COLOUR_WHITE;
        class Lines {
            type = "line";
            width = MPD_CURSOR_BOLD_WIDTH;
            points[] = {
                MPD_CURSOR_POINT(-0.01344, -0.01344), MPD_CURSOR_POINT(0.01344, 0.01344),
                {},
                MPD_CURSOR_POINT(0.01344, -0.01344), MPD_CURSOR_POINT(-0.01344, 0.01344)
            };
        };
    };
    // The PAN page, over the map: the panning arrows, in a footprint of the map as it would be, centred where the cursor is
    class PanFootprint {
        condition = C_COND(C_AND(C_AND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_TSD), C_EQ(C_MPD_USER(MFD_IND_TSD_SUBPAGE), 5)), C_AND(C_MPD_USER(MFD_IND_TSD_CURSOR_MAP), C_LESS(C_MPD_USER(MFD_IND_CURSOR_VAB), 100.5))));
        class Arrows {
            type = "line";
            width = MPD_CURSOR_BOLD_WIDTH;
            points[] = {
                MPD_CURSOR_POINT(-0.03, 0), MPD_CURSOR_POINT(0.03, 0), {},
                MPD_CURSOR_POINT(0, -0.03), MPD_CURSOR_POINT(0, 0.03)
            };
        };
        class Heads {
            type = "polygon";
            points[] = {
                {MPD_CURSOR_POINT(0, -0.036), MPD_CURSOR_POINT(0.009, -0.024), MPD_CURSOR_POINT(-0.009, -0.024)},
                {MPD_CURSOR_POINT(0, 0.036), MPD_CURSOR_POINT(-0.009, 0.024), MPD_CURSOR_POINT(0.009, 0.024)},
                {MPD_CURSOR_POINT(-0.036, 0), MPD_CURSOR_POINT(-0.024, -0.009), MPD_CURSOR_POINT(-0.024, 0.009)},
                {MPD_CURSOR_POINT(0.036, 0), MPD_CURSOR_POINT(0.024, 0.009), MPD_CURSOR_POINT(0.024, -0.009)}
            };
        };
        clipTL[] = {0, 0};
        clipBR[] = {1, 1};
        class Lines {
            type = "line";
            width = 3;
            points[] = {
                MPD_CURSOR_POINT(-0.5, -0.5), MPD_CURSOR_POINT(0.5, -0.5), MPD_CURSOR_POINT(0.5, 0.5), MPD_CURSOR_POINT(-0.5, 0.5), MPD_CURSOR_POINT(-0.5, -0.5)
            };
        };
    };
    // The FCR zoom box over the target area: the area ZOOM will show, sized by the scan size, white, with corner to corner
    // crosshairs
    class FcrZoom {
        condition = C_COND(C_AND(C_AND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_FCR), C_EQ(C_MPD_USER(MFD_IND_FCR_ZOOM), 1)), C_AND(C_MPD_USER(MFD_IND_FCR_CURSOR_AREA), C_LESS(C_MPD_USER(MFD_IND_CURSOR_VAB), 100.5))));
        color[] = MPD_COLOUR_WHITE;
        class Wide {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_SCAN_SIZE), 0));
            class Lines {
                type = "line";
                width = MPD_CURSOR_BOLD_WIDTH;
                points[] = {
                    MPD_CURSOR_POINT(-MPD_CURSOR_ZOOM_HALF_W, -MPD_CURSOR_ZOOM_HALF_W), MPD_CURSOR_POINT(MPD_CURSOR_ZOOM_HALF_W, -MPD_CURSOR_ZOOM_HALF_W), MPD_CURSOR_POINT(MPD_CURSOR_ZOOM_HALF_W, MPD_CURSOR_ZOOM_HALF_W), MPD_CURSOR_POINT(-MPD_CURSOR_ZOOM_HALF_W, MPD_CURSOR_ZOOM_HALF_W), MPD_CURSOR_POINT(-MPD_CURSOR_ZOOM_HALF_W, -MPD_CURSOR_ZOOM_HALF_W), {},
                    MPD_CURSOR_POINT(-MPD_CURSOR_ZOOM_HALF_W, -MPD_CURSOR_ZOOM_HALF_W), MPD_CURSOR_POINT(MPD_CURSOR_ZOOM_HALF_W, MPD_CURSOR_ZOOM_HALF_W), {},
                    MPD_CURSOR_POINT(MPD_CURSOR_ZOOM_HALF_W, -MPD_CURSOR_ZOOM_HALF_W), MPD_CURSOR_POINT(-MPD_CURSOR_ZOOM_HALF_W, MPD_CURSOR_ZOOM_HALF_W)
                };
            };
        };
        class Medium {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_SCAN_SIZE), 1));
            class Lines {
                type = "line";
                width = MPD_CURSOR_BOLD_WIDTH;
                points[] = {
                    MPD_CURSOR_POINT(-MPD_CURSOR_ZOOM_HALF_M, -MPD_CURSOR_ZOOM_HALF_M), MPD_CURSOR_POINT(MPD_CURSOR_ZOOM_HALF_M, -MPD_CURSOR_ZOOM_HALF_M), MPD_CURSOR_POINT(MPD_CURSOR_ZOOM_HALF_M, MPD_CURSOR_ZOOM_HALF_M), MPD_CURSOR_POINT(-MPD_CURSOR_ZOOM_HALF_M, MPD_CURSOR_ZOOM_HALF_M), MPD_CURSOR_POINT(-MPD_CURSOR_ZOOM_HALF_M, -MPD_CURSOR_ZOOM_HALF_M), {},
                    MPD_CURSOR_POINT(-MPD_CURSOR_ZOOM_HALF_M, -MPD_CURSOR_ZOOM_HALF_M), MPD_CURSOR_POINT(MPD_CURSOR_ZOOM_HALF_M, MPD_CURSOR_ZOOM_HALF_M), {},
                    MPD_CURSOR_POINT(MPD_CURSOR_ZOOM_HALF_M, -MPD_CURSOR_ZOOM_HALF_M), MPD_CURSOR_POINT(-MPD_CURSOR_ZOOM_HALF_M, MPD_CURSOR_ZOOM_HALF_M)
                };
            };
        };
        class Narrow {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_SCAN_SIZE), 2));
            class Lines {
                type = "line";
                width = MPD_CURSOR_BOLD_WIDTH;
                points[] = {
                    MPD_CURSOR_POINT(-MPD_CURSOR_ZOOM_HALF_N, -MPD_CURSOR_ZOOM_HALF_N), MPD_CURSOR_POINT(MPD_CURSOR_ZOOM_HALF_N, -MPD_CURSOR_ZOOM_HALF_N), MPD_CURSOR_POINT(MPD_CURSOR_ZOOM_HALF_N, MPD_CURSOR_ZOOM_HALF_N), MPD_CURSOR_POINT(-MPD_CURSOR_ZOOM_HALF_N, MPD_CURSOR_ZOOM_HALF_N), MPD_CURSOR_POINT(-MPD_CURSOR_ZOOM_HALF_N, -MPD_CURSOR_ZOOM_HALF_N), {},
                    MPD_CURSOR_POINT(-MPD_CURSOR_ZOOM_HALF_N, -MPD_CURSOR_ZOOM_HALF_N), MPD_CURSOR_POINT(MPD_CURSOR_ZOOM_HALF_N, MPD_CURSOR_ZOOM_HALF_N), {},
                    MPD_CURSOR_POINT(MPD_CURSOR_ZOOM_HALF_N, -MPD_CURSOR_ZOOM_HALF_N), MPD_CURSOR_POINT(-MPD_CURSOR_ZOOM_HALF_N, MPD_CURSOR_ZOOM_HALF_N)
                };
            };
        };
        class Zoom {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_SCAN_SIZE), 3));
            class Lines {
                type = "line";
                width = MPD_CURSOR_BOLD_WIDTH;
                points[] = {
                    MPD_CURSOR_POINT(-MPD_CURSOR_ZOOM_HALF_Z, -MPD_CURSOR_ZOOM_HALF_Z), MPD_CURSOR_POINT(MPD_CURSOR_ZOOM_HALF_Z, -MPD_CURSOR_ZOOM_HALF_Z), MPD_CURSOR_POINT(MPD_CURSOR_ZOOM_HALF_Z, MPD_CURSOR_ZOOM_HALF_Z), MPD_CURSOR_POINT(-MPD_CURSOR_ZOOM_HALF_Z, MPD_CURSOR_ZOOM_HALF_Z), MPD_CURSOR_POINT(-MPD_CURSOR_ZOOM_HALF_Z, -MPD_CURSOR_ZOOM_HALF_Z), {},
                    MPD_CURSOR_POINT(-MPD_CURSOR_ZOOM_HALF_Z, -MPD_CURSOR_ZOOM_HALF_Z), MPD_CURSOR_POINT(MPD_CURSOR_ZOOM_HALF_Z, MPD_CURSOR_ZOOM_HALF_Z), {},
                    MPD_CURSOR_POINT(MPD_CURSOR_ZOOM_HALF_Z, -MPD_CURSOR_ZOOM_HALF_Z), MPD_CURSOR_POINT(-MPD_CURSOR_ZOOM_HALF_Z, MPD_CURSOR_ZOOM_HALF_Z)
                };
            };
        };
    };
};
