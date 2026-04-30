#include "headers\ufd_macros.hpp"

color[] = {0.74, 0.85, 0, 1};
helmetMountedDisplay = 0;
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
class Draw
{
    class UFDElements {
        condition = "user0";
        class Line0
        {
            type = "text";
            source = "userText";
            sourceIndex = 0;
            scale=1;
            align="right";
            pos[] = {{0, 0}, 1};
            right[] = {{UFD_CHAR_WIDTH_VEC, 0}, 1};
            down[] = {{0, 1/10}, 1};
        };

        UFD_LINE(1);
        UFD_LINE(2);
        UFD_LINE(3);
        UFD_LINE(4);
        UFD_LINE(5);
        UFD_LINE(6);
        UFD_LINE(7);
        UFD_LINE(8);
        class Line9 : Line0
        {
            source = "static";
            text = "        XP 1200 B NORM            L";
            pos[] = {{0, 9*UFD_CHAR_HEIGHT}, 1};
            right[] = {{UFD_CHAR_WIDTH_VEC, 9*UFD_CHAR_HEIGHT}, 1};
            down[] = {{0, 10*UFD_CHAR_HEIGHT}, 1};
        };
        class FuelIAFSInstalled {
            condition = C_COND(C_EQ(C_USER(MFD_IND_IAFS_INSTALLED),0));
            class Fuel
            {
                type = "text";
                scale=1;
                align="right";
                source = "userText";
                sourceIndex = 10;
                pos[] = {{0, 9*UFD_CHAR_HEIGHT}, 1};
                right[] = {{UFD_CHAR_WIDTH_VEC, 9*UFD_CHAR_HEIGHT}, 1};
                down[] = {{0, 10*UFD_CHAR_HEIGHT}, 1};
            };
        };
        class Time : Line9
        {
            source = "time";
            text = "%H:%M:%S";
            pos[] = {{25*UFD_CHAR_WIDTH, 9*UFD_CHAR_HEIGHT}, 1};
            right[] = {{25*UFD_CHAR_WIDTH + UFD_CHAR_WIDTH_VEC, 9*UFD_CHAR_HEIGHT}, 1};
            down[] = {{25*UFD_CHAR_WIDTH, 10*UFD_CHAR_HEIGHT}, 1};
        };
    };
};
