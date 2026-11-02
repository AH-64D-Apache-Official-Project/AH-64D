// The bold copies for the pages, in the main pass of mpd.hpp (headers\cursor_bold.hpp). A file of its own, as the game
// cannot skip a conditional inside another one.
#ifndef MPD_MASK_PASS
#undef MPD_BOLD_TEXT
#undef MPD_BOLD_ARROW
#undef MPD_BOLD_PAGE_SCROLL
#undef MPD_BOLD_ROUTE_SCROLL
#define MPD_BOLD_TEXT(name, cond, startX, posY, widthVec, config) class Mpd_Bold_##name { \
    condition = cond; \
    class Text { \
        type = "text"; \
        scale = 1; \
        pos[] = {{(startX) + MPD_CURSOR_BOLD, posY}, 1}; \
        right[] = {{(startX) + MPD_CURSOR_BOLD + (widthVec), posY}, 1}; \
        down[] = {{(startX) + MPD_CURSOR_BOLD, (posY) + MPD_TEXT_HEIGHT_VEC}, 1}; \
        config \
    }; \
};
#define MPD_BOLD_ARROW(name, cond, lineX, startY, numChars) class Mpd_Bold_Arrow_##name { \
    condition = cond; \
    class Line { \
        type = "line"; \
        width = MPD_CURSOR_BOLD_WIDTH; \
        points[] = { \
            {{lineX, (startY) - MPD_ARROW_PAD}, 1}, \
            {{(lineX) + (numChars) * MPD_TEXT_WIDTH - 0.003 - MPD_ARROW_LENGTH, (startY) - MPD_ARROW_PAD}, 1}}; \
    }; \
};
// The page scroll arrows under B2 and B3 (VER, ABR, COORD), and the route scroll arrows by R1 and R6 (TSD RTE): the arrow
// from its tip along (ax, ay), its sides along (px, py)
#define MPD_BOLD_SCROLL_ARROW(name, cond, tipX, tipY, ax, ay, px, py) class Mpd_Bold_##name { \
    condition = cond; \
    class Line { \
        type = "line"; \
        width = MPD_CURSOR_BOLD_WIDTH; \
        points[] = { \
            {{tipX, tipY}, 1}, \
            {{(tipX) + 0.024 * (ax) - 0.015 * (px), (tipY) + 0.024 * (ay) - 0.015 * (py)}, 1}, \
            {{(tipX) + 0.030 * (ax) - 0.015 * (px), (tipY) + 0.030 * (ay) - 0.015 * (py)}, 1}, \
            {{(tipX) + 0.030 * (ax) - 0.007 * (px), (tipY) + 0.030 * (ay) - 0.007 * (py)}, 1}, \
            {{(tipX) + 0.048 * (ax) - 0.007 * (px), (tipY) + 0.048 * (ay) - 0.007 * (py)}, 1}, \
            {{(tipX) + 0.048 * (ax) + 0.009 * (px), (tipY) + 0.048 * (ay) + 0.009 * (py)}, 1}, \
            {{(tipX) + 0.030 * (ax) + 0.009 * (px), (tipY) + 0.030 * (ay) + 0.009 * (py)}, 1}, \
            {{(tipX) + 0.030 * (ax) + 0.017 * (px), (tipY) + 0.030 * (ay) + 0.017 * (py)}, 1}, \
            {{(tipX) + 0.024 * (ax) + 0.017 * (px), (tipY) + 0.024 * (ay) + 0.017 * (py)}, 1}, \
            {{tipX, tipY}, 1} \
        }; \
    }; \
};
#define MPD_BOLD_PAGE_SCROLL \
    MPD_BOLD_SCROLL_ARROW(PageBack, MPD_BOLD_COND_C(MPD_POS_BUTTON_TB_2_X, MPD_POS_BUTTON_B_Y), 0.278, 0.966, 1, 0, 0, 1) \
    MPD_BOLD_SCROLL_ARROW(PageNext, MPD_BOLD_COND_C(MPD_POS_BUTTON_TB_3_X, MPD_POS_BUTTON_B_Y), 0.502, 0.966, -1, 0, 0, 1)
#define MPD_BOLD_ROUTE_SCROLL \
    MPD_BOLD_SCROLL_ARROW(RouteUp, MPD_BOLD_COND_L(MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_1_Y), 0.966, 0.178, 0, 1, 1, 0) \
    MPD_BOLD_SCROLL_ARROW(RouteDown, MPD_BOLD_COND_L(MPD_POS_BUTTON_R_X, MPD_POS_BUTTON_LR_6_Y), 0.966, 0.822, 0, -1, 1, 0)
#endif
