// Text constants
#define MPD_TEXT_HEIGHT 0.045
#define MPD_TEXT_WIDTH 0.0205
#define MPD_TEXT_WIDTH_VEC 0.045

#define MPD_TEXT_SMALL_PAD 0.008
#define MPD_TEXT_SMALL_HEIGHT 0.03
#define MPD_TEXT_SMALL_WIDTH 0.018
#define MPD_TEXT_SMALL_WIDTH_VEC 0.03

// Drawing constants - used by macros below
#define MPD_ARROW_PAD 0.007
#define MPD_ARROW_LENGTH 0.01
#define MPD_ARROW_HEIGHT 0.006
#define MPD_BOX_PAD_X 0.006
#define MPD_BOX_PAD_Y 0.000

// Common MPD position coordinates - edges of MPDs next to buttons
#define MPD_POS_BUTTON_L_X 0.015
#define MPD_POS_BUTTON_R_X 0.985
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

#define COMMA ,
#define CONCAT_2(x,y) x##y
#define CONCAT_3(x,y,z) x##y##z

// Source scales
#define MPD_SCALE_METERS_FEET 3.28084
#define MPD_SCALE_MPS_KNOTS 1.94
#define MPD_SCALE_METERS_PER_SECOND_FEET_PER_MINUTE 196.85
#define MPD_SCALE_RADIANS_DEGREES 57.2958
#define MPD_SCALE_METERS_KM 0.001

#define EQ(A,B) (((A)>((B) - 1))*((A)<((B) + 1)))
#define USER_NUM(num) user##num

#define MFD_USER_NUM(num) __EVAL(MFD_OFFSET + num)
#define MPD_TEXT_STATIC(str)  source = static; text = str; sourceScale = 1;
#define MPD_TEXT_USER(num) source = userText; sourceIndex = MFD_USER_NUM(num);
#define MPD_NUM_USER(num) source = "user"; sourceIndex = MFD_USER_NUM(num);
#define MPD_COND_USER(num) __EVAL("user" + str (MFD_OFFSET + num))
#define STRINGIFY(str) #str

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
#define MPD_POINTS_BOX_PAD(bone, posX, posY, width, height, pad) \
    MPD_POINTS_CURVED_CORNER(bone, posX, posY, -pad, -pad), {}, \
    MPD_POINTS_CURVED_CORNER(bone, posX + width, posY, pad, -pad), {}, \
    MPD_POINTS_CURVED_CORNER(bone, posX, posY + height, -pad, pad), {}, \
    MPD_POINTS_CURVED_CORNER(bone, posX + width, posY + height, pad, pad), {}, \
    {bone, {posX - pad, posY}, 1}, {bone, {posX - pad, posY + height}, 1}, {}, \
    {bone, {posX + width + pad, posY}, 1}, {bone, {posX + width + pad, posY + height}, 1}, {}, \
    {bone, {posX, posY - pad}, 1}, {bone, {posX + width, posY - pad}, 1}, {}, \
    {bone, {posX, posY + height + pad}, 1}, {bone, {posX + width, posY + height + pad}, 1}

#define MPD_POINTS_BOX_PAD_EXTERNAL(bone, posX, posY, width, height, radius) MPD_POINTS_BOX_PAD(bone, (posX+radius), (posY+radius), (width-2*radius), (height-2*radius), radius)

#define MPD_POINTS_BOX(bone, posX, posY, width, height) MPD_POINTS_BOX_PAD(bone, posX, posY, width, height, CURVED_BOX_PAD)
#define MPD_POINTS_BOX_POLY(bone, posX, posY, width, height) {\
    {Null, {posX-CURVED_BOX_PAD,posY-CURVED_BOX_PAD}, 1},\
    {Null, {posX+width+CURVED_BOX_PAD, posY-CURVED_BOX_PAD}, 1},\
    {Null, {posX+width+CURVED_BOX_PAD, posY+height+CURVED_BOX_PAD}, 1},\
    {Null, {posX-CURVED_BOX_PAD, posY+height+CURVED_BOX_PAD}, 1},\
}

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

#define MPD_ARROW_R(name, startX, startY, numChars) class Mpd_Arrow_##name##_Line { \
    type = line; \
    points[] = { \
        {{startX + MPD_ARROW_LENGTH, startY - MPD_ARROW_PAD}, 1}, \
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

#define MPD_BOX_R(name, startX, startY, numChars) class Mpd_Box_##name##_Line { \
    type = line; \
    width = 2; \
    points[] = { \
        {{startX - MPD_BOX_PAD_X, startY - MPD_BOX_PAD_Y}, 1}, \
        {{startX + MPD_BOX_PAD_X + numChars * MPD_TEXT_WIDTH, startY - MPD_BOX_PAD_Y}, 1}, \
        {{startX + MPD_BOX_PAD_X + numChars * MPD_TEXT_WIDTH, startY + MPD_TEXT_HEIGHT + MPD_BOX_PAD_Y}, 1}, \
        {{startX - MPD_BOX_PAD_X, startY + MPD_TEXT_HEIGHT + MPD_BOX_PAD_Y}, 1}, \
        {{startX - MPD_BOX_PAD_X, startY - MPD_BOX_PAD_Y}, 1}}; \
};

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

#define MPD_TEXT_BONE_R(name, bone, startX, startY, config) MPD_TEXT(name, bone, startX, startY, align = right; config)
#define MPD_TEXT_BONE_C(name, bone, startX, startY, config) MPD_TEXT(name, bone, startX, startY, align = center; config)
#define MPD_TEXT_BONE_L(name, bone, startX, startY, config) MPD_TEXT(name, bone, startX, startY, align = left; config)

#define MPD_TEXT_SMALL_R(name, startX, startY, config) MPD_TEXT_SMALL(name, startX, startY, align = right; config)
#define MPD_TEXT_SMALL_C(name, startX, startY, config) MPD_TEXT_SMALL(name, startX, startY, align = center; config)
#define MPD_TEXT_SMALL_L(name, startX, startY, config) MPD_TEXT_SMALL(name, startX, startY, align = left; config)

#define MPD_TEXT_R(name, startX, startY, config) MPD_TEXT(name, Null, startX, startY, align = right; config)
#define MPD_TEXT_C(name, startX, startY, config) MPD_TEXT(name, Null, startX, startY, align = center; config)
#define MPD_TEXT_L(name, startX, startY, config) MPD_TEXT(name, Null, startX, startY, align = left; config)

#define MPD_ARROW_C(name, startX, startY, numChars) MPD_ARROW_R(name, (startX - numChars / 2 * MPD_TEXT_WIDTH), startY, numChars)
#define MPD_ARROW_L(name, startX, startY, numChars) MPD_ARROW_R(name, (startX - numChars * MPD_TEXT_WIDTH), startY, numChars)

#define MPD_BOX_C(name, startX, startY, numChars) MPD_BOX_R(name, (startX - numChars / 2 * MPD_TEXT_WIDTH), startY, numChars)
#define MPD_BOX_L(name, startX, startY, numChars) MPD_BOX_R(name, (startX - numChars * MPD_TEXT_WIDTH), startY, numChars)

#define MPD_BOX_TALL_C(name, startX, startY, numChars) MPD_BOX_TALL_R(name, (startX - numChars / 2 * MPD_TEXT_WIDTH), startY, numChars)
#define MPD_BOX_TALL_L(name, startX, startY, numChars) MPD_BOX_TALL_R(name, (startX - numChars * MPD_TEXT_WIDTH), startY, numChars)

#define MPD_BOX_ARROW_R(name, startX, startY, numChars) class Mpd_Box_Arrow_##name##_Line { \
    type = line; \
    width = 2; \
    points[] = { \
        {{startX - MPD_BOX_PAD, startY - MPD_BOX_PAD - MPD_ARROW_HEIGHT - 0.5 * MPD_ARROW_PAD}, 1}, \
        {{startX + MPD_BOX_PAD + numChars * MPD_TEXT_WIDTH, startY - MPD_BOX_PAD- MPD_ARROW_HEIGHT - 0.5 * MPD_ARROW_PAD}, 1}, \
        {{startX + MPD_BOX_PAD + numChars * MPD_TEXT_WIDTH, startY + MPD_TEXT_HEIGHT + MPD_BOX_PAD}, 1}, \
        {{startX - MPD_BOX_PAD, startY + MPD_TEXT_HEIGHT + MPD_BOX_PAD}, 1}, \
        {{startX - MPD_BOX_PAD, startY - MPD_BOX_PAD - MPD_ARROW_HEIGHT - 0.5 * MPD_ARROW_PAD}, 1}}; \
};

#define MPD_BOX_ARROW_C(name, startX, startY, numChars) MPD_BOX_ARROW_R(name, (startX - numChars / 2 * MPD_TEXT_WIDTH), startY, numChars)
#define MPD_BOX_ARROW_L(name, startX, startY, numChars) MPD_BOX_ARROW_R(name, (startX - numChars * MPD_TEXT_WIDTH), startY, numChars)

#define MPD_TEXT_OCCLUDER_R(bone,startX,startY,numChars) { \
    {bone, {(startX), (startY)}, 1},\
    {bone, {(startX) + (numChars) * MPD_TEXT_WIDTH, (startY)}, 1},\
    {bone, {(startX) + (numChars) * MPD_TEXT_WIDTH, (startY)+MPD_TEXT_HEIGHT}, 1},\
    {bone, {(startX), (startY)+MPD_TEXT_HEIGHT}, 1}\
}

#define MPD_TEXT_OCCLUDER_C(bone,startX,startY,numChars) MPD_TEXT_OCCLUDER_R(bone,((startX)-(numChars)/2*MPD_TEXT_WIDTH),startY,numChars)
#define MPD_TEXT_OCCLUDER_L(bone,startX,startY,numChars) MPD_TEXT_OCCLUDER_R(bone,((startX)-(numChars)*MPD_TEXT_WIDTH),startY,numChars)