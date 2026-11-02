// The bold copies of the labels in the MPD cursor's selection (headers\cursor.h). Only for the pages, in the main pass of
// mpd.hpp (MPD_CURSOR_PAGES and not MPD_MASK_PASS); empty elsewhere, as the pylon icons. Included again at each change. A
// copy is a class of its own, named Mpd_Bold_..., as fza_mpd_fnc_cursorLabels finds them so.
#undef MPD_BOLD_TEXT
#undef MPD_BOLD_ARROW
#undef MPD_BOLD_SCROLL_ARROW
#undef MPD_BOLD_PAGE_SCROLL
#undef MPD_BOLD_ROUTE_SCROLL
#define MPD_BOLD_TEXT(name, cond, startX, posY, widthVec, config)
#define MPD_BOLD_ARROW(name, cond, lineX, startY, numChars)
#define MPD_BOLD_PAGE_SCROLL
#define MPD_BOLD_ROUTE_SCROLL

#ifdef MPD_CURSOR_PAGES
#include "cursor_bold_pages.hpp"
#endif
