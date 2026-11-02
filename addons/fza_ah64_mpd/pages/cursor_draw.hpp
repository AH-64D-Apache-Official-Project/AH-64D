// The MPD cursor (fza_mpd_fnc_cursorUpdate), on the MPD it is on, after the page so it is drawn over it. The labels of the
// VAB it is on are drawn bold by their own copies (headers\cursor_bold.hpp).
#define MPD_CURSOR_POINT(px,py) {"MPD_Cursor_X", {px, py}, 1, "MPD_Cursor_Y", 1}

// A ring with four diagonal spokes, centred on the cursor's position
class Cursor {
    condition = C_COND(C_AND(C_MORE(C_USER(MFD_IND_CURSOR_X), MPD_CURSOR_X_BASE - 0.5), C_LESS(C_USER(MFD_IND_CURSOR_X), MPD_CURSOR_X_BASE + 1.5)));
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
    // Central crosshairs, on the TSD pages that take a point from the map (fza_mpd_fnc_cursorPoint)
    class Crosshair {
        condition = C_COND(C_AND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_TSD), C_AND(C_MORE(C_MPD_USER(MFD_IND_TSD_SUBPAGE), 1.5), C_LESS(C_MPD_USER(MFD_IND_TSD_SUBPAGE), 4.5))));
        class Lines {
            type = "line";
            width = MPD_CURSOR_BOLD_WIDTH;
            points[] = {
                MPD_CURSOR_POINT(-0.009, 0), MPD_CURSOR_POINT(0.009, 0),
                {},
                MPD_CURSOR_POINT(0, -0.009), MPD_CURSOR_POINT(0, 0.009)
            };
        };
    };
};
