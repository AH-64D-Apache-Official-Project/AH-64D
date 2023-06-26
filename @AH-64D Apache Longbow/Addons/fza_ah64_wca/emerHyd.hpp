color[] = {0.74, 0.85, 0, 1};
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
class Draw
{
    class pushButton {
        class emer_hyd
        {
            type = "text";
            source = "static";
            text = "ON";
            sourceIndex = 0;
            scale=1;
            align="right";
            sourceScale = 1;
            pos[] = {{0, 0}, 1};
            right[] = {{0, 0}, 1};
            down[] = {{0, 0.0}, 1};
        };
    };
};