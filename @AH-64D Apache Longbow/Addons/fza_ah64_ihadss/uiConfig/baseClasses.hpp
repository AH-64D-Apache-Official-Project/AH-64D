/////////////////////////////////////////////////////////////
////////////////////////////IHADSS///////////////////////////
/////////////////////////////////////////////////////////////
class RscControlsGroup;
class RscMapControlEmpty;
class fza_ah64_mapControl : RscMapControlEmpty
{
    colorBackground[] = {0,0,0,0};
    colorCountlines[] = {0,0,0,0};
    colorCountlinesWater[] = {0,0,0,0};
    colorForest[] = {0,0,0,0};
    colorForestBorder[] = {0,0,0,0};
    colorGrid[] = {0,0,0,0};
    colorGridMap[] = {0,0,0,0};
    colorInactive[] = {0,0,0,0};
    colorLevels[] = {0,0,0,0};
    colorMainCountlines[] = {0,0,0,0};
    colorMainCountlinesWater[] = {0,0,0,0};
    colorMainRoads[] = {0,0,0,0};
    colorMainRoadsFill[] = {0,0,0,0};
    colorNames[] = {0,0,0,0};
    colorOutside[] = {0,0,0,0};
    colorPowerLines[] = {0,0,0,0};
    colorRailWay[] = {0,0,0,0};
    colorRoads[] = {0,0,0,0};
    colorRoadsFill[] = {0,0,0,0};
    colorRocks[] = {0,0,0,0};
    colorRocksBorder[] = {0,0,0,0};
    colorSea[] = {0,0,0,0};
    colorText[] = {0,0,0,1};
    colorTracks[] = {0,0,0,0};
    colorTracksFill[] = {0,0,0,0};
    colorTrails[] = {0,0,0,0};
    colorTrailsFill[] = {0,0,0,0};

    text = "#(argb,8,8,3)color(0,0,0,0)";
    showMarkers = 0;
    class ActiveMarker {
        color[] = {0,0,0,0};
        size = 0;
    };
    class Bunker {
        coefMax = 4;
        coefMin = 0.25;
        color[] = {0,0,0,0};
        icon = "#(argb,8,8,3)color(0,0,0,0)";
        importance = "1.5 * 14 * 0.05";
        size = 0;
    };
    class Bush {
        coefMax = 4;
        coefMin = 0.25;
        color[] = {0,0,0,0};
        icon = "#(argb,8,8,3)color(0,0,0,0)";
        importance = "0.2 * 14 * 0.05 * 0.05";
        size = 0;
    };
    class busstop {
        coefMax = 1;
        coefMin = 0.85;
        color[] = {0,0,0,0};
        icon = "#(argb,8,8,3)color(0,0,0,0)";
        importance = 1;
        size = 0;
    };
    class Chapel {
        coefMax = 1;
        coefMin = 0.85;
        color[] = {0,0,0,0};
        icon = "#(argb,8,8,3)color(0,0,0,0)";
        importance = 1;
        size = 0;
    };
    class church {
        coefMax = 1;
        coefMin = 0.85;
        color[] = {0,0,0,0};
        icon = "#(argb,8,8,3)color(0,0,0,0)";
        importance = 1;
        size = 0;
    };
    class Command {
        coefMax = 1;
        coefMin = 1;
        color[] = {0,0,0,0};
        icon = "#(argb,8,8,3)color(0,0,0,0)";
        importance = 1;
        size = 0;
    };
    class Cross {
        coefMax = 1;
        coefMin = 0.85;
        color[] = {0,0,0,0};
        icon = "#(argb,8,8,3)color(0,0,0,0)";
        importance = 1;
        size = 0;
    };
    class CustomMark {
        coefMax = 1;
        coefMin = 1;
        color[] = {0,0,0,0};
        icon = "#(argb,8,8,3)color(0,0,0,0)";
        importance = 1;
        size = 0;
    };
    class Fortress {
        coefMax = 4;
        coefMin = 0.25;
        color[] = {0,0,0,0};
        icon = "#(argb,8,8,3)color(0,0,0,0)";
        importance = "2 * 16 * 0.05";
        size = 0;
    };
    class Fountain {
        coefMax = 4;
        coefMin = 0.25;
        color[] = {0,0,0,0};
        icon = "#(argb,8,8,3)color(0,0,0,0)";
        importance = "1 * 12 * 0.05";
        size = 0;
    };
    class fuelstation {
        coefMax = 1;
        coefMin = 0.85;
        color[] = {0,0,0,0};
        icon = "#(argb,8,8,3)color(0,0,0,0)";
        importance = 1;
        size = 0;
    };
    class hospital {
        coefMax = 1;
        coefMin = 0.85;
        color[] = {0,0,0,0};
        icon = "#(argb,8,8,3)color(0,0,0,0)";
        importance = 1;
        size = 0;
    };
    class Legend {
        color[] = {0,0,0,0};
        colorBackground[] = {0,0,0,0};
        font = "RobotoCondensed";
        h = "3.5 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
        sizeEx = 0;
        w = "10 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
        x = "SafeZoneX + 					(			((safezoneW / safezoneH) min 1.2) / 40)";
        y = "SafeZoneY + safezoneH - 4.5 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
    };
    class lighthouse {
        coefMax = 1;
        coefMin = 0.85;
        color[] = {0,0,0,0};
        icon = "#(argb,8,8,3)color(0,0,0,0)";
        importance = 1;
        size = 0;
    };
    class LineMarker {
        lineDistanceMin = 3e-005;
        lineLengthMin = 5;
        lineWidthThick = 0.014;
        lineWidthThin = 0.008;
        textureComboBoxColor = "#(argb,8,8,3)color(0,0,0,0)";
    };
    class power {
        coefMax = 1;
        coefMin = 0.85;
        color[] = {0,0,0,0};
        icon = "#(argb,8,8,3)color(0,0,0,0)";
        importance = 1;
        size = 0;
    };
    class powersolar {
        coefMax = 1;
        coefMin = 0.85;
        color[] = {0,0,0,0};
        icon = "#(argb,8,8,3)color(0,0,0,0)";
        importance = 1;
        size = 0;
    };
    class powerwave {
        coefMax = 1;
        coefMin = 0.85;
        color[] = {0,0,0,0};
        icon = "#(argb,8,8,3)color(0,0,0,0)";
        importance = 1;
        size = 0;
    };
    class powerwind {
        coefMax = 1;
        coefMin = 0.85;
        color[] = {0,0,0,0};
        icon = "#(argb,8,8,3)color(0,0,0,0)";
        importance = 1;
        size = 0;
    };
    class quay {
        coefMax = 1;
        coefMin = 0.85;
        color[] = {0,0,0,0};
        icon = "#(argb,8,8,3)color(0,0,0,0)";
        importance = 1;
        size = 0;
    };
    class Rock {
        coefMax = 4;
        coefMin = 0.25;
        color[] = {0,0,0,0};
        icon = "#(argb,8,8,3)color(0,0,0,0)";
        importance = "0.5 * 12 * 0.05";
        size = 0;
    };
    class Ruin {
        coefMax = 4;
        coefMin = 1;
        color[] = {0,0,0,0};
        icon = "#(argb,8,8,3)color(0,0,0,0)";
        importance = "1.2 * 16 * 0.05";
        size = 0;
    };
    class shipwreck {
        coefMax = 1;
        coefMin = 0.85;
        color[] = {0,0,0,0};
        icon = "#(argb,8,8,3)color(0,0,0,0)";
        importance = 1;
        size = 0;
    };
    class SmallTree {
        coefMax = 1;
        coefMin = 0.85;
        color[] = {0,0,0,0};
        icon = "#(argb,8,8,3)color(0,0,0,0)";
        importance = 1;
        size = 0;
    };
    class Stack {
        coefMax = 2;
        coefMin = 0.4;
        color[] = {0,0,0,0};
        icon = "#(argb,8,8,3)color(0,0,0,0)";
        importance = "2 * 16 * 0.05";
        size = 0;
    };
    class Task {
        coefMax = 1;
        coefMin = 1;
        color[] = {0,0,0,0};
        colorCanceled[] = {0,0,0,0};
        colorCreated[] = {0,0,0,0};
        colorDone[] = {0,0,0,0};
        colorFailed[] = {0,0,0,0};
        icon = "#(argb,8,8,3)color(0,0,0,0)";
        iconCanceled = "#(argb,8,8,3)color(0,0,0,0)";
        iconCreated = "#(argb,8,8,3)color(0,0,0,0)";
        iconDone = "#(argb,8,8,3)color(0,0,0,0)";
        iconFailed = "#(argb,8,8,3)color(0,0,0,0)";
        importance = 1;
        size = 0;
        taskAssigned = "#(argb,8,8,3)color(0,0,0,0)";
        taskCanceled = "#(argb,8,8,3)color(0,0,0,0)";
        taskCreated = "#(argb,8,8,3)color(0,0,0,0)";
        taskFailed = "#(argb,8,8,3)color(0,0,0,0)";
        taskNone = "#(argb,8,8,3)color(0,0,0,0)";
        taskSucceeded = "#(argb,8,8,3)color(0,0,0,0)";
    };
    class Tourism {
        coefMax = 4;
        coefMin = 0.7;
        color[] = {0,0,0,0};
        icon = "#(argb,8,8,3)color(0,0,0,0)";
        importance = "1 * 16 * 0.05";
        size = 0;
    };
    class transmitter {
        coefMax = 1;
        coefMin = 0.85;
        color[] = {0,0,0,0};
        icon = "#(argb,8,8,3)color(0,0,0,0)";
        importance = 1;
        size = 0;
    };
    class Tree {
        coefMax = 4;
        coefMin = 0.25;
        color[] = {0,0,0,0};
        icon = "#(argb,8,8,3)color(0,0,0,0)";
        importance = "0.9 * 16 * 0.05";
        size = 0;
    };
    class ViewTower {
        coefMax = 4;
        coefMin = 0.5;
        color[] = {0,0,0,0};
        icon = "#(argb,8,8,3)color(0,0,0,0)";
        importance = "2.5 * 16 * 0.05";
        size = 0;
    };
    class watertower {
        coefMax = 1;
        coefMin = 0.85;
        color[] = {0,0,0,0};
        icon = "#(argb,8,8,3)color(0,0,0,0)";
        importance = 1;
        size = 0;
    };
    class Waypoint {
        coefMax = 1;
        coefMin = 1;
        color[] = {0,0,0,0};
        icon = "#(argb,8,8,3)color(0,0,0,0)";
        importance = 1;
        size = 0;
    };
    class WaypointCompleted {
        coefMax = 1;
        coefMin = 1;
        color[] = {0,0,0,0};
        icon = "#(argb,8,8,3)color(0,0,0,0)";
        importance = 1;
        size = 0;
    };
};