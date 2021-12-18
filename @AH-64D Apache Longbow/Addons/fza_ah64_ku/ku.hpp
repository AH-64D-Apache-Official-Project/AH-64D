color[] = {0.74, 0.85, 0, 1};
helmetMountedDisplay = false;
borderLeft=0;
borderRight=0;
borderTop=0;
font="fza_ticketing";
borderBottom=0;
class material
{
	ambient[]	= { 1, 1, 1, 1 };
	diffuse[]	= { 1, 1, 1, 1 };
	emissive[]	= { 30, 30, 30, 1 };
};
class Bones {};
// HUD-Elements definitions
class Draw
{
    class KU {
        condition = user0;
        class Solid {
            condition = "1-user3";
            class Text {
                type = text;
                align = right;
                scale = 1
                source = userText;
                sourceIndex = 9;
                pos[] = {{0.05,0.05},1};
                right[] = {{0.15,0.05},1};
                down[] = {{0.05,0.95},1};
            };
        };
        class Flashing {
            condition = "user3";
            blinkingPattern[] = {1,1};
            blinkingStartsOn = 1;
            class Text {
                type = text;
                align = right;
                scale = 1
                source = userText;
                sourceIndex = 9;
                pos[] = {{0.05,0.05},1};
                right[] = {{0.15,0.05},1};
                down[] = {{0.05,0.95},1};
            };
        };
    };
};