color[] = {0.0, 0.80, 0.51, 1};
helmetMountedDisplay=0;
borderBottom=0;
borderLeft=0;
borderRight=0;
borderTop=0;
font="fza_ticketing";
helmetDown[] = {0,-0.075,0};
helmetPosition[] = {-0.0375,0.0375,0.1};
helmetRight[] = {0.075,0,0};
class material
{
    ambient[]   = { 1, 1, 1, 1 };
    diffuse[]   = { 1, 1, 1, 1 };
    emissive[]  = { 30, 30, 30, 1 };
};
class Bones {};
// HUD-Elements definitions
class Draw {
    #define START_X     0.50
    #define TOP_START_Y 0.28
    #define BOT_START_Y 0.72
    
    #define CHAR_WIDTH_VEC 0.32
    #define CHAR_HEIGHT 0.5

    class battOff {
        condition = C_COND(C_AND(C_USER(MFD_IND_BATT), C_USER(MFD_IND_MSTR_CAUT)));    
        class pushButton {
            class mstr_top {
                type = "text";
                source = "static";
                text = "MSTR";
                sourceIndex = 0;
                scale=1.0;
                align="center";
                sourceScale = 1;
                pos[]   = {{START_X,                  TOP_START_Y - 0.5*CHAR_HEIGHT}, 1};
                right[] = {{START_X + CHAR_WIDTH_VEC, TOP_START_Y - 0.5*CHAR_HEIGHT},1};
                down[]  = {{START_X,                  TOP_START_Y - 0.5*CHAR_HEIGHT + CHAR_HEIGHT},1};
            };
            class caut_bot {
                type = "text";
                source = "static";
                text = "CAUT";
                sourceIndex = 0;
                scale=1.0;
                align="center";
                sourceScale = 1;
                pos[]   = {{START_X,                  BOT_START_Y - 0.5*CHAR_HEIGHT}, 1};
                right[] = {{START_X + CHAR_WIDTH_VEC, BOT_START_Y - 0.5*CHAR_HEIGHT},1};
                down[]  = {{START_X,                  BOT_START_Y - 0.5*CHAR_HEIGHT + CHAR_HEIGHT},1};
            };
        };
    };
};