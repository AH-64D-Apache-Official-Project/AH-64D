/* Constants: Text size constants
  MPD_TEXT_HEIGHT - Height of a single normal character
  MPD_TEXT_WIDTH - Width of a single normal character
  MPD_TEXT_WIDTH_VEC - Width to put into type="text" for a character with width MPD_TEXT_WIDTH
  MPD_TEXT_SMALL_PAD - Padding offset when using small text
  MPD_TEXT_SMALL_HEIGHT - Height of a single small character
  MPD_TEXT_SMALL_WIDTH - Width of a single small character
  MPD_TEXT_SMALL_WIDTH_VEC - Width to put into type="text" for a character with width MPD_TEXT_SMALL_WIDTH
*/
#define MPD_TEXT_HEIGHT 0.045
#define MPD_TEXT_WIDTH 0.0205
#define MPD_TEXT_WIDTH_VEC 0.045

#define MPD_TEXT_SMALL_PAD 0.008
#define MPD_TEXT_SMALL_HEIGHT 0.03
#define MPD_TEXT_SMALL_WIDTH 0.018
#define MPD_TEXT_SMALL_WIDTH_VEC 0.03

/* Constants: Misc size constants
  MPD_ARROW_PAD - Offset of an arrow above an MPD text character
  MPD_ARROW_LENGTH - The length of the solid triangle in an arrow
  MPD_ARROW_HEIGHT - The height of an MPD arrow
  MPD_BOX_PAD_X - How much a box needs to be padded in the x-direction on each side
  MPD_BOX_PAD_Y - How much a box needs to be padded in the y-direction on each side
*/
#define MPD_ARROW_PAD 0.007
#define MPD_ARROW_LENGTH 0.01
#define MPD_ARROW_HEIGHT 0.006
#define MPD_BOX_PAD_X 0.006
#define MPD_BOX_PAD_Y 0.000

/* Constants: MPD VAB positions
  MPD_POS_BUTTON_L_X - X coordinate of VABS L[1-6]
  MPD_POS_BUTTON_R_X - X coordinate of VABS R[1-6]
  MPD_POS_BUTTON_LR_1_Y - Y coordinate of VABS [LR]1
  MPD_POS_BUTTON_LR_2_Y - Y coordinate of VABS [LR]2
  MPD_POS_BUTTON_LR_3_Y - Y coordinate of VABS [LR]3
  MPD_POS_BUTTON_LR_4_Y - Y coordinate of VABS [LR]4
  MPD_POS_BUTTON_LR_5_Y - Y coordinate of VABS [LR]5
  MPD_POS_BUTTON_LR_6_Y - Y coordinate of VABS [LR]6

  MPD_POS_BUTTON_T_Y - Y coordinate of VABS T[1-6]
  MPD_POS_BUTTON_B_Y - Y coordinate of VABS B[1-6]
  MPD_POS_BUTTON_TB_1_X - Y coordinate of VABS [TB]1
  MPD_POS_BUTTON_TB_2_X - Y coordinate of VABS [TB]2
  MPD_POS_BUTTON_TB_3_X - Y coordinate of VABS [TB]3
  MPD_POS_BUTTON_TB_4_X - Y coordinate of VABS [TB]4
  MPD_POS_BUTTON_TB_5_X - Y coordinate of VABS [TB]5
  MPD_POS_BUTTON_TB_6_X - Y coordinate of VABS [TB]6
*/
#define MPD_POS_BUTTON_L_X 0.03
#define MPD_POS_BUTTON_R_X 0.97
#define MPD_POS_BUTTON_LR_1_Y 0.2
#define MPD_POS_BUTTON_LR_2_Y 0.315
#define MPD_POS_BUTTON_LR_3_Y 0.43
#define MPD_POS_BUTTON_LR_4_Y 0.545
#define MPD_POS_BUTTON_LR_5_Y 0.66
#define MPD_POS_BUTTON_LR_6_Y 0.775

#define MPD_POS_BUTTON_T_Y (0.01 + MPD_ARROW_PAD)
#define MPD_POS_BUTTON_B_Y (0.970-0.03)
#define MPD_POS_BUTTON_TB_1_X 0.21
#define MPD_POS_BUTTON_TB_2_X 0.33
#define MPD_POS_BUTTON_TB_3_X 0.45
#define MPD_POS_BUTTON_TB_4_X 0.57
#define MPD_POS_BUTTON_TB_5_X 0.69
#define MPD_POS_BUTTON_TB_6_X 0.81

// Group: Misc Macros

/* Macro: COMMA
    Macro that evaluates to a comma, to be used when using a comma directly breaks another macro
*/
#define COMMA ,
/* Macro: CONCAT_2
    Directly concatenate two values

Parameters:
    x,y - arguments to concatenate
*/
#define CONCAT_2(x,y) x##y
/* Macro: CONCAT_3
    Directly concatenate three values

Parameters:
    x,y,z - arguments to concatenate
*/
#define CONCAT_3(x,y,z) x##y##z
/* Macro: STRINGIFY
    Takes input and stringifies it:

    STRINGIFY(this is a test) => "this is a test"
*/
#define STRINGIFY(str) #str


#define POLAR(rad, dim) POLAR_OFFSET(0,0,rad,dim)

#define POLAR_OFFSET(x, y, rad, dim) {x + sin (rad) * (dim), y - (cos (rad)) * (dim)}

/* Constants: Source scales
  MPD_SCALE_METERS_FEET - Conversion from meters to feet
  MPD_SCALE_MPS_KNOTS - Conversion from meters per second to knots
  MPD_SCALE_METERS_PER_SECOND_FEET_PER_MINUTE - Conversions from meters per second to feet per minute
  MPD_SCALE_RADIANS_DEGREES - Conversion fom radians to degrees
  MPD_SCALE_METERS_KM - Conversion from meters to KM
*/
#define MPD_SCALE_METERS_FEET 3.28084
#define MPD_SCALE_MPS_KNOTS 1.94
#define MPD_SCALE_METERS_PER_SECOND_FEET_PER_MINUTE 196.85
#define MPD_SCALE_RADIANS_DEGREES 57.2958
#define MPD_SCALE_METERS_KM 0.001

// Group: Conditions

/* Macro: C_COND
    Wrapped around a condition built in these macros, for example:
    
    --- Code
    condition = C_COND(C_EQ(C_USER(MFD_IND_PAGE), MPD_PAGE_DMS));
    ---

Parameters:
    cond - the condition to evaluate
*/
#define C_COND(cond) __EVAL(cond)

/* Macro: C_USER
    Reads the value of a user value. Does not add MFD_OFFSET, and therefore can only be used for values like
    MFD_IND_PAGE

Parameters:
    num - the index of the value to read
*/
#define C_USER(num) format["user%1", num]

/* Macro: C_MPD_USER
    Reads the value of a user MFD value, valid for MPD values

Parameters:
    num - the index of the value to read
*/
#define C_MPD_USER(num) C_USER(MFD_OFFSET + num)

/* Macros: Comparisons
    C_EQ - Checks two values are equal
    C_LESS - Checks one value is less than another
    C_MORE - Checks one value is more than another
*/
#define C_EQ(argA,argB) format["(((%1)>((%2) - 1))*((%1)<((%2) + 1)))", argA, argB]
#define C_LESS(argA, argB) format["((%1)<(%2))", argA, argB]
#define C_MORE(argA, argB) format["((%1)>(%2))", argA, argB]

/* Macros: Logical operations
    C_AND - Checks two conditions are both true
    C_OR - Checks at least one of two conditions are true
    C_NOT - Inverts a single condition
*/
#define C_AND(argA,argB) format["((%1)*(%2))", argA, argB]
#define C_OR(argA,argB) format["((%1)+(%2))", argA, argB]
#define C_NOT(argX) format["(1-((%1) factor [0,1]))", argX]

// Group: Text Source Macros
#define MFD_USER_NUM(num) __EVAL(MFD_OFFSET + num)

/* Macro: MPD_TEXT_STATIC
    Sets static source in type="text"

Parameters:
    str - Static text to display. e.g: "test"
*/
#define MPD_TEXT_STATIC(str)  source = static; text = str; sourceScale = 1;

/* Macro: MPD_TEXT_USER_SCALE
    Sets user source in type="text", with a scaling factor

Parameters:
    num - MPD user string source
    scale - Scaling to apply to input.
*/
#define MPD_TEXT_USER_SCALE(num, scale) source = userText; sourceIndex = MFD_USER_NUM(num); sourceScale = 1;

/* Macro: MPD_TEXT_USER
    Version of <MPD_TEXT_USER_SCALE> with no scaling factor

Parameters:
    num: MPD user string source
*/
#define MPD_TEXT_USER(num) MPD_TEXT_USER_SCALE(num,1)

// Group: Float Source Macros

/* Macro: MPD_NUM_USER
    Sets float source to a numeric value

Parameters:
    num - MPD user float source
*/
#define MPD_NUM_USER(num) source = "user"; sourceIndex = MFD_USER_NUM(num);

// Group: Standard draws

/* Macro: MPD_POINTS_CURVED_CORNER
    Draws a 90 degree curved corner about a point
    
Parameters:
    bone - A bone to transform the corner by. "Null" if none.
    posX, posY - point to draw the corner about
    vecX, vecY - vector signifying the direction and size of the corner
*/
#define MPD_POINTS_CURVED_CORNER(bone, posX, posY, vecX, vecY) \
    {bone, {__EVAL((posX) + (vecX) * cos 0),  __EVAL((posY) + (vecY) * sin 0)}, 1}, \
    {bone, {__EVAL((posX) + (vecX) * cos 10), __EVAL((posY) + (vecY) * sin 10)}, 1}, \
    {bone, {__EVAL((posX) + (vecX) * cos 20), __EVAL((posY) + (vecY) * sin 20)}, 1}, \
    {bone, {__EVAL((posX) + (vecX) * cos 30), __EVAL((posY) + (vecY) * sin 30)}, 1}, \
    {bone, {__EVAL((posX) + (vecX) * cos 40), __EVAL((posY) + (vecY) * sin 40)}, 1}, \
    {bone, {__EVAL((posX) + (vecX) * cos 50), __EVAL((posY) + (vecY) * sin 50)}, 1}, \
    {bone, {__EVAL((posX) + (vecX) * cos 60), __EVAL((posY) + (vecY) * sin 60)}, 1}, \
    {bone, {__EVAL((posX) + (vecX) * cos 70), __EVAL((posY) + (vecY) * sin 70)}, 1}, \
    {bone, {__EVAL((posX) + (vecX) * cos 80), __EVAL((posY) + (vecY) * sin 80)}, 1}, \
    {bone, {__EVAL((posX) + (vecX) * cos 90), __EVAL((posY) + (vecY) * sin 90)}, 1}

#define CURVED_BOX_PAD 0.0075
/* Macro: MPD_POINTS_BOX_PAD
    Draws a box, with curved corners, with a given dimensions and padding (curved corner side).
    
    Please note the box dimensions described are internal from the corners, so the real size will have 2*pad added in
    each dimension. For a macro that counts the corners in the dimensions, use <MPD_POINTS_BOX_PAD_EXTERNAL>.
    
Parameters:
    bone - A bone to transform the box  by. "Null" if none.
    posX,posY - Top left corner of the box
    width,height - Box dimensions (internal)
    pad - size of the corners
*/
#define MPD_POINTS_BOX_PAD(bone, posX, posY, width, height, pad) \
    MPD_POINTS_CURVED_CORNER(bone, posX, posY, -pad, -pad), {}, \
    MPD_POINTS_CURVED_CORNER(bone, posX + width, posY, pad, -pad), {}, \
    MPD_POINTS_CURVED_CORNER(bone, posX, posY + height, -pad, pad), {}, \
    MPD_POINTS_CURVED_CORNER(bone, posX + width, posY + height, pad, pad), {}, \
    {bone, {posX - pad, posY}, 1}, {bone, {posX - pad, posY + height}, 1}, {}, \
    {bone, {posX + width + pad, posY}, 1}, {bone, {posX + width + pad, posY + height}, 1}, {}, \
    {bone, {posX, posY - pad}, 1}, {bone, {posX + width, posY - pad}, 1}, {}, \
    {bone, {posX, posY + height + pad}, 1}, {bone, {posX + width, posY + height + pad}, 1}

/* Macro: MPD_POINTS_BOX_PAD_EXTERNAL
    Same as <MPD_POINTS_BOX_PAD>, but with the dimensions being measured including the corners.

Parameters:
    bone - A bone to transform the box  by. "Null" if none.
    posX,posY - Top left corner of the box
    width,height - Box dimensions (internal)
    pad - size of the corners
*/
#define MPD_POINTS_BOX_PAD_EXTERNAL(bone, posX, posY, width, height, radius) MPD_POINTS_BOX_PAD(bone, (posX+radius), (posY+radius), (width-2*radius), (height-2*radius), radius)

/* Macro: MPD_POINTS_BOX
    Variant of <MPD_POINTS_BOX_PAD> that uses a standard padding amount. Dimensions specified are internal

Parameters:
    bone - A bone to transform the box  by. "Null" if none.
    posX,posY - Top left corner of the box
    width,height - Box dimensions (internal)
*/
#define MPD_POINTS_BOX(bone, posX, posY, width, height) MPD_POINTS_BOX_PAD(bone, posX, posY, width, height, CURVED_BOX_PAD)

/* Macro: MPD_POINTS_BOX_POLY
    Defines a polygon to be used in type="polygon" to occlude for a <MPD_POINTS_BOX>.

Parameters:
    bone - A bone to transform the box  by. "Null" if none.
    posX,posY - Top left corner of the box
    width,height - Box dimensions (internal)
*/
#define MPD_POINTS_BOX_POLY(bone, posX, posY, width, height) {\
    {Null, {posX-CURVED_BOX_PAD,posY-CURVED_BOX_PAD}, 1},\
    {Null, {posX+width+CURVED_BOX_PAD, posY-CURVED_BOX_PAD}, 1},\
    {Null, {posX+width+CURVED_BOX_PAD, posY+height+CURVED_BOX_PAD}, 1},\
    {Null, {posX-CURVED_BOX_PAD, posY+height+CURVED_BOX_PAD}, 1},\
}

/* Macro: MPD_CIRCLE
    Defines a polygon to be used in type="polygon" to occlude for a <MPD_POINTS_BOX>.

Parameters:
    bone - A bone to transform the box  by. "Null" if none.
    posX,posY - Top left corner of the box
    width,height - Box dimensions (internal)
*/
#define MPD_CIRCLE(name, bone, radius) class name##Circle { \
    type = polygon; \
    points[] = { \
        { \
            {bone, {__EVAL(radius * sin -30), __EVAL(radius * (0 - cos -30))}, 1}, \
            {bone, {__EVAL(radius * sin 0), __EVAL(radius * (0 - cos 0))}, 1}, \
            {bone, {__EVAL(radius * sin 30), __EVAL(radius * (0 - cos 30))}, 1}, \
            {bone, {__EVAL(radius * sin 60), __EVAL(radius * (0 - cos 60))}, 1} \
        }, \
        { \
            {bone, {__EVAL(radius * sin -60), __EVAL(radius * (0 - cos -60))}, 1}, \
            {bone, {__EVAL(radius * sin -30), __EVAL(radius * (0 - cos -30))}, 1}, \
            {bone, {__EVAL(radius * sin 60), __EVAL(radius * (0 - cos 60))}, 1}, \
            {bone, {__EVAL(radius * sin 90), __EVAL(radius * (0 - cos 90))}, 1} \
        }, \
        { \
            {bone, {__EVAL(radius * sin -90), __EVAL(radius * (0 - cos -90))}, 1}, \
            {bone, {__EVAL(radius * sin -60), __EVAL(radius * (0 - cos -60))}, 1}, \
            {bone, {__EVAL(radius * sin 90), __EVAL(radius * (0 - cos 90))}, 1}, \
            {bone, {__EVAL(radius * sin 120), __EVAL(radius * (0 - cos 120))}, 1} \
        }, \
        { \
            {bone, {__EVAL(radius * sin -120), __EVAL(radius * (0 - cos -120))}, 1}, \
            {bone, {__EVAL(radius * sin -90), __EVAL(radius * (0 - cos -90))}, 1}, \
            {bone, {__EVAL(radius * sin 120), __EVAL(radius * (0 - cos 120))}, 1}, \
            {bone, {__EVAL(radius * sin 150), __EVAL(radius * (0 - cos 150))}, 1} \
        }, \
        { \
            {bone, {__EVAL(radius * sin -120), __EVAL(radius * (0 - cos -120))}, 1}, \
            {bone, {__EVAL(radius * sin 150), __EVAL(radius * (0 - cos 150))}, 1}, \
            {bone, {__EVAL(radius * sin 180), __EVAL(radius * (0 - cos 180))}, 1}, \
            {bone, {__EVAL(radius * sin -150), __EVAL(radius * (0 - cos -150))}, 1} \
        } \
    }; \
};

// Group: Text & Text-related drawing

/* About: Coordinate Positioning

    Each of these macros has 3 variants, _L, _C and _R. This sets the coordinate used to draw from.

    - _L spefifies that the point is in the top right corner, and the macro should be drawn to the left
    - _C specifies that the point is in the top middle corner, and the macro should be drawn outwards
    - _R specifies that the point is in the top left corner, and the macro should be drawn to the right

    In situations where all 3 are a possibility, only one will be documented - MACRO_x

    --- Code
           \/     |     \/
     MACRO_L   MACRO_C   MACRO_R
    --- Code
*/

/* Macro: MPD_ARROW_x
    Draws an arrow over text with the coordinate specified.

Parameters:
    name - Unique name to use in the class definition. Can be the same as that in <MPD_TEXT_x> as they are
        deconflicted within the macros
    startX, startY - Position of the text the arrow should be over
    numChars - Number of characters in the text to draw an arrow over, defines the length of the arrow.
*/
#define MPD_ARROW_R(name, startX, startY, numChars) class Mpd_Arrow_##name##_Line { \
    type = line; \
    points[] = { \
        {{startX, startY - MPD_ARROW_PAD}, 1}, \
        {{startX + numChars * MPD_TEXT_WIDTH - 0.003 - MPD_ARROW_LENGTH, startY - MPD_ARROW_PAD}, 1}}; \
    width = 3; \
}; \
class Mpd_Arrow_##name##_Triangle { \
    type = polygon; \
    points[] = { \
        { \
            {{startX + numChars * MPD_TEXT_WIDTH - 0.001, startY - MPD_ARROW_PAD}, 1},\
            {{startX + numChars * MPD_TEXT_WIDTH - 0.003 - MPD_ARROW_LENGTH, startY - MPD_ARROW_PAD - MPD_ARROW_HEIGHT}, 1},\
            {{startX + numChars * MPD_TEXT_WIDTH - 0.003 - MPD_ARROW_LENGTH, startY - MPD_ARROW_PAD + MPD_ARROW_HEIGHT}, 1}}\
        };\
};

/* Macro: MPD_BOX_x
    Draws an box around text with the coordinate specified.

Parameters:
    name - Unique name to use in the class definition. Can be the same as that in <MPD_TEXT_x> as they are
        deconflicted within the macros
    startX, startY - Position of the text the box should be drawn around
    numChars - Number of characters in the text to draw a box around, defines the size of the box
*/
#define MPD_BOX_R(name, startX, startY, numChars) class Mpd_Box_##name##_Line { \
    type = line; \
    width = 2; \
    points[] = { \
        {{startX - MPD_BOX_PAD_X,                             startY - MPD_BOX_PAD_Y}, 1}, \
        {{startX + MPD_BOX_PAD_X + numChars * MPD_TEXT_WIDTH, startY - MPD_BOX_PAD_Y}, 1}, \
        {{startX + MPD_BOX_PAD_X + numChars * MPD_TEXT_WIDTH, startY + MPD_TEXT_HEIGHT + MPD_BOX_PAD_Y}, 1}, \
        {{startX - MPD_BOX_PAD_X,                             startY + MPD_TEXT_HEIGHT + MPD_BOX_PAD_Y}, 1}, \
        {{startX - MPD_BOX_PAD_X,                             startY - MPD_BOX_PAD_Y}, 1}}; \
};

#define MPD_BOX_V(name, startX, startY, numChars) class Mpd_Box_##name##_Line { \
    type = line; \
    width = 2; \
    points[] = { \
        {{startX - MPD_BOX_PAD_X,                  (startY) - 0.85*MPD_TEXT_HEIGHT + MPD_BOX_PAD_Y}, 1}, \
        {{startX + MPD_BOX_PAD_X + MPD_TEXT_WIDTH, (startY) - 0.85*MPD_TEXT_HEIGHT + MPD_BOX_PAD_Y}, 1}, \
        {{startX + MPD_BOX_PAD_X + MPD_TEXT_WIDTH, (startY) + 0.60*numChars * MPD_TEXT_HEIGHT + MPD_BOX_PAD_Y}, 1}, \
        {{startX - MPD_BOX_PAD_X,                  (startY) + 0.60*numChars * MPD_TEXT_HEIGHT + MPD_BOX_PAD_Y}, 1}, \
        {{startX - MPD_BOX_PAD_X,                  (startY) - 0.85*MPD_TEXT_HEIGHT + MPD_BOX_PAD_Y}, 1}}; \
};

/* Macro: MPD_BOX_TALL_x
    Draws an box around text with the coordinate specified. The box is taller than that drawn with <MPD_BOX_x>
    and can fit an arrow within.

Parameters:
    name - Unique name to use in the class definition. Can be the same as that in <MPD_TEXT_x> as they are
        deconflicted within the macros
    startX, startY - Position of the text the box should be drawn around
    numChars - Number of characters in the text to draw a box around, defines the size of the box
*/
#define MPD_BOX_TALL_R(name, startX, startY, numChars) class Mpd_Box_##name##_Line { \
    type = line; \
    width = 2; \
    points[] = { \
        {{startX - MPD_BOX_PAD_X, startY - 0.005 - MPD_BOX_PAD_Y - MPD_ARROW_HEIGHT - MPD_ARROW_PAD}, 1}, \
        {{startX + MPD_BOX_PAD_X + numChars * MPD_TEXT_WIDTH, startY - 0.005 - MPD_BOX_PAD_Y - MPD_ARROW_HEIGHT - MPD_ARROW_PAD}, 1}, \
        {{startX + MPD_BOX_PAD_X + numChars * MPD_TEXT_WIDTH, startY + MPD_TEXT_HEIGHT + MPD_BOX_PAD_Y}, 1}, \
        {{startX - MPD_BOX_PAD_X, startY + MPD_TEXT_HEIGHT + MPD_BOX_PAD_Y}, 1}, \
        {{startX - MPD_BOX_PAD_X, startY - 0.005 - MPD_BOX_PAD_Y - MPD_ARROW_HEIGHT - MPD_ARROW_PAD}, 1}}; \
};

#define MPD_TEXT(name, bone, startX, startY, config) class Mpd_Text_##name { \
    type = text; \
    scale = 1; \
    pos[] = {bone, {startX, startY}, 1}; \
    right[] = {bone, {startX+MPD_TEXT_WIDTH_VEC, startY}, 1}; \
    down[] = {bone, {startX, startY+(MPD_TEXT_HEIGHT)}, 1}; \
    config \
};

#define MPD_TEXT_SMALL(name, startX, startY, config) class Mpd_Text_##name { \
    type = text; \
    scale = 1; \
    pos[] = {{startX, startY}, 1}; \
    right[] = {{startX+MPD_TEXT_SMALL_WIDTH_VEC, startY}, 1}; \
    down[] = {{startX, startY+(MPD_TEXT_SMALL_HEIGHT)}, 1}; \
    config \
};

/* Macro: MPD_BOX_BONE_x
    Draws text in the given direction, with the text content defined by config. Text is transformed by the given bone.

Parameters:
    name - Unique name to use in the class definition. Can be the same as that in the ancillary text draw definitions
        as they are deconflicted within the macros
    bone - The bone the text should be transformed by. Use "Null" when not required
    startX, startY - Position of the text
    config - Configuration describing the content, like <MPD_TEXT_STATIC>, <MPD_TEXT_USER> and <MPD_TEXT_USER_SCALE>
*/
#define MPD_TEXT_BONE_R(name, bone, startX, startY, config) MPD_TEXT(name, bone, startX, startY, align = right; config)
#define MPD_TEXT_BONE_C(name, bone, startX, startY, config) MPD_TEXT(name, bone, startX, startY, align = center; config)
#define MPD_TEXT_BONE_L(name, bone, startX, startY, config) MPD_TEXT(name, bone, startX, startY, align = left; config)

/* Macro: MPD_TEXT_SMALL_x
    Draws small text, with the text content defined by config.

Parameters:
    name - Unique name to use in the class definition. Can be the same as that in the ancillary text draw definitions
        as they are deconflicted within the macros
    startX, startY - Position of the text
    config - Configuration describing the content, like <MPD_TEXT_STATIC>, <MPD_TEXT_USER> and <MPD_TEXT_USER_SCALE>
*/
#define MPD_TEXT_SMALL_R(name, startX, startY, config) MPD_TEXT_SMALL(name, startX, startY, align = right; config)
#define MPD_TEXT_SMALL_C(name, startX, startY, config) MPD_TEXT_SMALL(name, startX, startY, align = center; config)
#define MPD_TEXT_SMALL_L(name, startX, startY, config) MPD_TEXT_SMALL(name, startX, startY, align = left; config)

/* Macro: MPD_TEXT_x
    Draws text, with the text content defined by config.

Parameters:
    name - Unique name to use in the class definition. Can be the same as that in the ancillary text draw definitions
        as they are deconflicted within the macros
    startX, startY - Position of the text
    config - Configuration describing the content, like <MPD_TEXT_STATIC>, <MPD_TEXT_USER> and <MPD_TEXT_USER_SCALE>
*/
#define MPD_TEXT_R(name, startX, startY, config) MPD_TEXT(name, Null, startX, startY, align = right; config)
#define MPD_TEXT_C(name, startX, startY, config) MPD_TEXT(name, Null, startX, startY, align = center; config)
#define MPD_TEXT_L(name, startX, startY, config) MPD_TEXT(name, Null, startX, startY, align = left; config)

#define MPD_ARROW_C(name, startX, startY, numChars) MPD_ARROW_R(name, (startX - numChars / 2 * MPD_TEXT_WIDTH), startY, numChars)
#define MPD_ARROW_L(name, startX, startY, numChars) MPD_ARROW_R(name, (startX - numChars * MPD_TEXT_WIDTH), startY, numChars)

#define MPD_BOX_C(name, startX, startY, numChars) MPD_BOX_R(name, (startX - numChars / 2 * MPD_TEXT_WIDTH), startY, numChars)
#define MPD_BOX_L(name, startX, startY, numChars) MPD_BOX_R(name, (startX - numChars * MPD_TEXT_WIDTH), startY, numChars)

#define MPD_BOX_TALL_C(name, startX, startY, numChars) MPD_BOX_TALL_R(name, (startX - numChars / 2 * MPD_TEXT_WIDTH), startY, numChars)
#define MPD_BOX_TALL_L(name, startX, startY, numChars) MPD_BOX_TALL_R(name, (startX - numChars * MPD_TEXT_WIDTH), startY, numChars)

/* Macro: MPD_TEXT_OCCLUDER_x
    type="polygon" polygon that is the same size as text. Used to occlude items behind text

Parameters:
    name - Unique name to use in the class definition. Can be the same as that in the ancillary text draw definitions
        as they are deconflicted within the macros
    bone - The bone the text should be transformed by. Use "Null" when not required.
    startX, startY - Position of the text that this should oclcude for.
    numChars - Number of characters in the text to occlude for, sets size.
*/
#define MPD_TEXT_OCCLUDER_R(bone,startX,startY,numChars) { \
    {bone, {(startX), (startY)}, 1},\
    {bone, {(startX) + (numChars) * MPD_TEXT_WIDTH, (startY)}, 1},\
    {bone, {(startX) + (numChars) * MPD_TEXT_WIDTH, (startY)+MPD_TEXT_HEIGHT}, 1},\
    {bone, {(startX), (startY)+MPD_TEXT_HEIGHT}, 1}\
}

#define MPD_TEXT_OCCLUDER_C(bone,startX,startY,numChars) MPD_TEXT_OCCLUDER_R(bone,((startX)-(numChars)/2*MPD_TEXT_WIDTH),startY,numChars)
#define MPD_TEXT_OCCLUDER_L(bone,startX,startY,numChars) MPD_TEXT_OCCLUDER_R(bone,((startX)-(numChars)*MPD_TEXT_WIDTH),startY,numChars)

/* Macros: Barriers
    MPD_BOX_BAR_B - Draws barrier for text at VAB B[1-6]
    MPD_BOX_BAR_T - Draws barrier for text at VAB T[1-6]
    MPD_BOX_BAR_L - Draws barrier for text at VAB L[1-6]
    MPD_BOX_BAR_R - Draws barrier for text at VAB R[1-6]

Parameters:
    name - Unique name to use in the class definition. Can be the same as that in the ancillary text draw definitions
        as they are deconflicted within the macros
    startX, startY - Position of the text that this should oclcude for.
*/
#define MPD_BOX_BAR_B(name, startX, startY) class Mpd_Box_##name##_Barrier { \
    color[] = {0.05,0.25,0,0.5};\
    class Polygons {\
        type = polygon;\
        points[] = {\
            {\
                { {startX-1.5*MPD_TEXT_WIDTH - MPD_BOX_PAD_X, startY + MPD_TEXT_HEIGHT}, 1 },\
                { {startX+1.5*MPD_TEXT_WIDTH + MPD_BOX_PAD_X, startY + MPD_TEXT_HEIGHT}, 1 },\
                { {startX+1.5*MPD_TEXT_WIDTH + MPD_BOX_PAD_X, startY + 1.2*MPD_TEXT_HEIGHT}, 1 },\
                { {startX-1.5*MPD_TEXT_WIDTH - MPD_BOX_PAD_X, startY + 1.2*MPD_TEXT_HEIGHT}, 1 },\
            },\
        };\
    };\
};

#define MPD_BOX_BAR_T(name, startX, startY) class Mpd_Box_##name##_Barrier { \
    color[] = {0.05,0.25,0,0.5};\
    class Polygons {\
        type = polygon;\
        points[] = {\
            {\
                { {startX-1.5*MPD_TEXT_WIDTH - MPD_BOX_PAD_X, startY}, 1 },\
                { {startX+1.5*MPD_TEXT_WIDTH + MPD_BOX_PAD_X, startY}, 1 },\
                { {startX+1.5*MPD_TEXT_WIDTH + MPD_BOX_PAD_X, startY - 0.2*MPD_TEXT_HEIGHT}, 1 },\
                { {startX-1.5*MPD_TEXT_WIDTH - MPD_BOX_PAD_X, startY - 0.2*MPD_TEXT_HEIGHT}, 1 },\
            },\
        };\
    };\
};

#define MPD_BOX_BAR_L(name, startX, startY) class Mpd_Box_##name##_Barrier { \
    color[] = {0.05,0.25,0,0.5};\
    class Polygons {\
        type = polygon;\
        points[] = {\
            {\
                { {startX + 0.4*MPD_TEXT_HEIGHT, startY - 0.25*MPD_TEXT_HEIGHT}, 1 },\
                { {startX + 0.4*MPD_TEXT_HEIGHT, startY + 1.25*MPD_TEXT_HEIGHT}, 1 },\
                { {startX + 0.2*MPD_TEXT_HEIGHT, startY + 1.25*MPD_TEXT_HEIGHT}, 1 },\
                { {startX + 0.2*MPD_TEXT_HEIGHT, startY - 0.25*MPD_TEXT_HEIGHT}, 1 },\
            }\
        };\
    };\
};

#define MPD_BOX_BAR_R(name, startX, startY) class Mpd_Box_##name##_Barrier { \
    color[] = {0.05,0.25,0,0.5};\
    class Polygons {\
        type = polygon;\
        points[] = {\
            {\
                { {startX - 0.4*MPD_TEXT_HEIGHT, startY - 0.25*MPD_TEXT_HEIGHT}, 1 },\
                { {startX - 0.4*MPD_TEXT_HEIGHT, startY + 1.25*MPD_TEXT_HEIGHT}, 1 },\
                { {startX - 0.2*MPD_TEXT_HEIGHT, startY + 1.25*MPD_TEXT_HEIGHT}, 1 },\
                { {startX - 0.2*MPD_TEXT_HEIGHT, startY - 0.25*MPD_TEXT_HEIGHT}, 1 },\
            }\
        };\
    };\
};

/* Macros: Inverse Box
    MPD_BOX_INV_C
    MPD_BOX_INV_R
    MPD_BOX_INV_L

Parameters:
    name -
    startX -
    startY -

*/
#define MPD_BOX_INV_C(name, startX, startY, numChars) class Mpd_Box_##name##_Barrier { \
    color[] = {0.2, 1, 0, 1};\
    class Polygons {\
        type = polygon;\
        points[] = {\
            {\
                { {startX-numChars / 2 * MPD_TEXT_WIDTH, startY - MPD_BOX_PAD_Y}, 1 },\
                { {startX+numChars / 2 * MPD_TEXT_WIDTH, startY - MPD_BOX_PAD_Y}, 1 },\
                { {startX+numChars / 2 * MPD_TEXT_WIDTH, startY + MPD_TEXT_HEIGHT + MPD_BOX_PAD_Y}, 1 },\
                { {startX-numChars / 2 * MPD_TEXT_WIDTH, startY + MPD_TEXT_HEIGHT + MPD_BOX_PAD_Y}, 1 },\
            },\
        };\
    };\
};

/* Macros: ASE Object
    ASE_OBJ - Draws an ASE object on the ASE page

Parameters:
    name - Unique name to use in the class definition. Can be the same as that in the ancillary text draw definitions
        as they are deconflicted within the macros
    modeSource - Defines the mode of the detected emitter
*/
#define ASE_OBJ(name, modeSource)\
class aseObj_##name {\
    color[] = {1,1,0,1};\
    class lines_aseObj##name##Null {\
        condition = C_COND(C_EQ(C_MPD_USER(modeSource), -1));\
    };\
    class lines_aseObj##name##Search {\
        condition = C_COND(C_EQ(C_MPD_USER(modeSource), ASE_SRH));\
        class searchIcon {\
            type = line;\
            width = 3;\
            points[] = {\
                {ase_obj_##name##_iconRotCorr, { 0.000, 0.001}, 1, ase_obj_iconTranslate, 1, ase_obj_##name, 1},\
                {ase_obj_##name##_iconRotCorr, { 0.015, 0.031}, 1, ase_obj_iconTranslate, 1, ase_obj_##name, 1},\
                {ase_obj_##name##_iconRotCorr, {-0.015, 0.031}, 1, ase_obj_iconTranslate, 1, ase_obj_##name, 1},\
                {ase_obj_##name##_iconRotCorr, { 0.000, 0.001}, 1, ase_obj_iconTranslate, 1, ase_obj_##name, 1} \
            };\
        };\
        class searchText {\
            type        ="text";\
            source      ="static";\
            text        ="S A";\
            scale       =1;\
            sourceScale =1;\
            align       = "center";\
            pos[]       = {ase_obj_##name##_iconRotCorr, { 0.000,        -0.040       }, 1, ase_obj_iconTranslate, 1, ase_obj_##name, 1};\
            right[]     = {ase_obj_##name##_iconRotCorr, { 0.000 + 0.04, -0.040       }, 1, ase_obj_iconTranslate, 1, ase_obj_##name, 1};\
            down[]      = {ase_obj_##name##_iconRotCorr, { 0.000,        -0.040 + 0.04}, 1, ase_obj_iconTranslate, 1, ase_obj_##name, 1};\
        };\
    };\
    class lines_aseObj##name##Acq : lines_aseObj##name##Search {\
        condition = C_COND(C_EQ(C_MPD_USER(modeSource), ASE_ACQ));\
        class searchIcon: searchIcon {};\
        class searchText: searchText {};\
        class acqBox {\
            type = line;\
            width = 3;\
            points[] = {\
                {ase_obj_##name##_iconRotCorr, {-0.04, 0.04}, 1, ase_obj_iconTranslate, 1, ase_obj_##name, 1},\
                {ase_obj_##name##_iconRotCorr, { 0.04, 0.04}, 1, ase_obj_iconTranslate, 1, ase_obj_##name, 1},\
                {ase_obj_##name##_iconRotCorr, { 0.04,-0.04}, 1, ase_obj_iconTranslate, 1, ase_obj_##name, 1},\
                {ase_obj_##name##_iconRotCorr, {-0.04,-0.04}, 1, ase_obj_iconTranslate, 1, ase_obj_##name, 1},\
                {ase_obj_##name##_iconRotCorr, {-0.04, 0.04}, 1, ase_obj_iconTranslate, 1, ase_obj_##name, 1},\
            };\
        };\
    };\
    class lines_ASEObj##name##Track : lines_aseObj##name##Acq {\
        condition = C_COND(C_EQ(C_MPD_USER(modeSource), ASE_TRK));\
        blinkingPattern[] = {0.25,0.25};\
        blinkingStartsOn = 1;\
        class searchIcon: searchIcon {};\
        class searchText: searchText {};\
        class acqBox: acqBox{};\
        class trackLine {\
            type     = line;\
            width    = 3;\
            points[] = {\
                {ase_obj_##name, { 0.000, 0.018}, 1},\
                {ase_obj_##name, { 0.000, 0.036}, 1}, {},\
                {ase_obj_##name, { 0.000, 0.054}, 1},\
                {ase_obj_##name, { 0.000, 0.071}, 1}, {},\
                {ase_obj_##name, { 0.000, 0.089}, 1},\
                {ase_obj_##name, { 0.000, 0.107}, 1}, {},\
                {ase_obj_##name, { 0.000, 0.125}, 1},\
                {ase_obj_##name, { 0.000, 0.143}, 1}, {},\
                {ase_obj_##name, { 0.000, 0.161}, 1},\
                {ase_obj_##name, { 0.000, 0.179}, 1}, {},\
                {ase_obj_##name, { 0.000, 0.196}, 1},\
                {ase_obj_##name, { 0.000, 0.214}, 1}, {},\
                {ase_obj_##name, { 0.000, 0.232}, 1},\
                {ase_obj_##name, { 0.000, 0.250}, 1}, {},\
            };\
        };\
    };\
};