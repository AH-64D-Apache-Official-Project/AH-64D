// HDU monocle geometry in the 640x480 format units, lens centred on the format centre (the LOS).
// The glass in tools\ihadss\hdu_source_ca.paa is an ellipse: centre (856.9, 1006.6), semi axes 489.2 and 516.0 of
// 2048 px, the first axis rotated 60.4 deg clockwise from the x axis. 360 format units per 504 source px.
#define HDU_PX_TO_UNIT  (360 / 504)
#define HDU_IMAGE_SIZE  (2048 * HDU_PX_TO_UNIT)
#define HDU_IMAGE_X     (320 - 856.9 * HDU_PX_TO_UNIT)
#define HDU_IMAGE_Y     (240 - 1006.6 * HDU_PX_TO_UNIT)
// Heads up symbology is clipped to the glass ellipse inset 6 units; IH.HDU_CLIP in ihadss_common.js
#define HDU_CLIP_A      343
#define HDU_CLIP_B      362
// The HTML page extends this far past the format on every side; IH.MARGIN in ihadss_common.js
#define IHADSS_PAGE_MARGIN 100
// Heads up the heading tape moves up this far, and the top edge of the symbol area with it; IH.SPREAD.tape in ihadss_common.js
#define IHADSS_SPREAD_TAPE -60
// PNVS picture mask: the glass ellipse grown 14 px, so the strip steps fall under the rim
#define HDU_MASK_A      (503.2 * HDU_PX_TO_UNIT)
#define HDU_MASK_B      (530.0 * HDU_PX_TO_UNIT)
#define HDU_MASK_ROT    60.4
// Half height of the mask's bounding box
#define HDU_MASK_EXTENT_Y (sqrt (HDU_MASK_A ^ 2 * (sin HDU_MASK_ROT) ^ 2 + HDU_MASK_B ^ 2 * (cos HDU_MASK_ROT) ^ 2))
// Heads up symbology is also kept inside the HDU display field, from the format centre; IH.HDU_FIELD in ihadss_common.js
#define HDU_FIELD_LEFT   -358
#define HDU_FIELD_RIGHT  358
#define HDU_FIELD_TOP    -274
#define HDU_FIELD_BOTTOM 324
#define HDU_STRIP_PX    3
#define HDU_STRIPS_MAX  400
//FLIR Resolution
#define FLIR_WFOV_RES 720
#define FLIR_ZFOV_RES 360
