#include "\fza_ah64_mpd\headers\mpd_defines.hpp"
#include "\fza_ah64_mpd\headers\mfdConstants.h"

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
        condition = user0;
        #define UFD_CHAR_WIDTH_VEC 0.064
        #define UFD_CHAR_WIDTH (1/35)
        #define UFD_CHAR_HEIGHT 0.1
        class Line0
        {
            type = "text";
            source = "userText";
            sourceIndex = 0;
            scale=1;
            align="right";
            sourceScale = 1;
            pos[] = {{0, 0}, 1};
            right[] = {{UFD_CHAR_WIDTH_VEC, 0}, 1};
            down[] = {{0, 1/10}, 1};
        };
        #define UFD_LINE(N) \
        class Line##N : Line0 \
        { \
            sourceIndex = N; \
            pos[] = {{0, N*UFD_CHAR_HEIGHT}, 1}; \
            right[] = {{UFD_CHAR_WIDTH_VEC, N*UFD_CHAR_HEIGHT}, 1}; \
            down[] = {{0, __EVAL((N +1)*UFD_CHAR_HEIGHT)}, 1}; \
        };
        UFD_LINE(1)
        UFD_LINE(2)
        UFD_LINE(3)
        UFD_LINE(4)
        UFD_LINE(5)
        UFD_LINE(6)
        UFD_LINE(7)
        UFD_LINE(8)
        class Line9 : Line0
        {
            source = "static";
            text = "        XP 1200 B NORM            L";
            pos[] = {{0, 9*UFD_CHAR_HEIGHT}, 1};
            right[] = {{UFD_CHAR_WIDTH_VEC, 9*UFD_CHAR_HEIGHT}, 1};
            down[] = {{0, __EVAL(10*UFD_CHAR_HEIGHT)}, 1};
        };
        class FuelIAFSInstalled {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_IAFS_INSTALLED), 0));
            class Fuel
            {
                type = "text";
                scale=1;
                align="right";
                source = fuel;
                sourceScale = 3180.4;
                sourceLength = 4;
                pos[] = {{0, 9*UFD_CHAR_HEIGHT}, 1};
                right[] = {{UFD_CHAR_WIDTH_VEC, 9*UFD_CHAR_HEIGHT}, 1};
                down[] = {{0, __EVAL(10*UFD_CHAR_HEIGHT)}, 1};
            };
        };
        class FuelIAFSInstalled1Tank : FuelIAFSInstalled {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_IAFS_INSTALLED), 1));
            class Fuel : Fuel
            {
                sourceScale = 4721.4;
            };
        };
        class FuelIAFSInstalled2Tank : FuelIAFSInstalled {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_IAFS_INSTALLED), 2));
            class Fuel : Fuel
            {
                sourceScale = 6262.4;
            };
        };
        class FuelIAFSInstalled3Tank : FuelIAFSInstalled {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_IAFS_INSTALLED), 3));
            class Fuel : Fuel
            {
                sourceScale = 7803.5;
            };
        };
        class FuelIAFSInstalled4Tank : FuelIAFSInstalled {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_IAFS_INSTALLED), 4));
            class Fuel : Fuel
            {
                sourceScale = 9344.5;
            };
        };
        class FuelIAFSNotInstalled : FuelIAFSInstalled {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_IAFS_INSTALLED), 5));
            class Fuel : Fuel
            {
                sourceScale = 2517;
            };
        };
        class FuelIAFSNotInstalled1tank : FuelIAFSInstalled {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_IAFS_INSTALLED), 6));
            class Fuel : Fuel
            {
                sourceScale = 4058;
            };
        };
        class FuelIAFSNotInstalled2tank : FuelIAFSInstalled {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_IAFS_INSTALLED), 7));
            class Fuel : Fuel
            {
                sourceScale = 5599.1;
            };
        };
        class FuelIAFSNotInstalled3tank : FuelIAFSInstalled {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_IAFS_INSTALLED), 8));
            class Fuel : Fuel
            {
                sourceScale = 7140.1;
            };
        };
        class FuelIAFSNotInstalled4tank : FuelIAFSInstalled {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_IAFS_INSTALLED), 9));
            class Fuel : Fuel
            {
                sourceScale = 8681.1;
            };
        };
        class Time : Line9
        {
            source = time;
            text = "%H:%M:%S";
            pos[] = {{25*UFD_CHAR_WIDTH, 9*UFD_CHAR_HEIGHT}, 1};
            right[] = {{25*UFD_CHAR_WIDTH + UFD_CHAR_WIDTH_VEC, 9*UFD_CHAR_HEIGHT}, 1};
            down[] = {{25*UFD_CHAR_WIDTH, 10*UFD_CHAR_HEIGHT}, 1};
        };
    };
};