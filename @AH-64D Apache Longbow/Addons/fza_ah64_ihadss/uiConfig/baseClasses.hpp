/////////////////////////////////////////////////////////////
////////////////////////////IHADSS///////////////////////////
/////////////////////////////////////////////////////////////
class RscControlsGroup;
class fza_ah64_mapControl
{
    idc = -1;
    type = 100;
    style = 48;
    x = 0;
    y = 0;
    w = 1;
    h = 1;
    colorBackground[] = {1,1,1,0};
    colorText[] = {0,0,0,0};
    colorSea[] = {0.56,0.8,0.98,0};
    colorForest[] = {0.6,0.8,0.2,0};
    colorRocks[] = {0.5,0.5,0.5,0};
    colorCountlines[] = {0.65,0.45,0.27,0};
    colorMainCountlines[] = {0.65,0.45,0.27,0};
    colorCountlinesWater[] = {0,0.53,1,0};
    colorMainCountlinesWater[] = {0,0.53,1,0};
    colorForestBorder[] = {0.4,0.8,0,0};
    colorRocksBorder[] = {0.5,0.5,0.5,0};
    colorPowerLines[] = {0,0,0,0};
    colorNames[] = {0,0,0,0};
    colorInactive[] = {1,1,1,0};
    colorLevels[] = {0,0,0,0};
    colorRailWay[] = {0,0,0,0};
    colorOutside[] = {0.56,0.8,0.98,0};
    //a3compat//
    colorTracks[] = {0,0,0,0};
    colorRoads[] = {0,0,0,0};
    colorMainRoads[] = {0,0,0,0};
    colorTracksFill[] = {0,0,0,0};
    colorRoadsFill[] = {0,0,0,0};
    colorMainRoadsFill[] = {0,0,0,0};
    colorGrid[] = {0,0,0,0};
    colorGridMap[] = {0,0,0,0};
    ////////////
    font = "TahomaB";
    sizeEx = 0;
    stickX[] = {0,{"Gamma",1,1.5 }};
    stickY[] = {0,{"Gamma",1,1.5 }};
    ptsPerSquareSea = 0;
    ptsPerSquareTxt = 0;
    ptsPerSquareCLn = 0;
    ptsPerSquareExp = 0;
    ptsPerSquareCost = 0;
    ptsPerSquareFor = "0f";
    ptsPerSquareForEdge = "0f";
    ptsPerSquareRoad = 0;
    ptsPerSquareObj = 0;
    fontLabel = "PuristaMedium";
    sizeExLabel = 0;
    fontGrid = "PuristaMedium";
    sizeExGrid = 0;
    fontUnits = "PuristaMedium";
    sizeExUnits = 0;
    fontNames = "PuristaMedium";
    sizeExNames = 0;
    fontInfo = "PuristaMedium";
    sizeExInfo = 0;
    fontLevel = "PuristaMedium";
    sizeExLevel = 0;
    scaleMax = 1;
    scaleMin = 0.125;
    text = "";
    maxSatelliteAlpha = 0;
    alphaFadeStartScale = 1;
    alphaFadeEndScale = 1.1;
    showCountourInterval = 1;
    scaleDefault = 2;
    class Task
    {
        icon = "\fza_ah64_US\tex\ICONS\ah64_gen_pfz.paa";
        color[] = {1,0.537,0,0};
        size = 27;
        importance = 1;
        coefMin = 1;
        coefMax = 1;
        iconCreated = "";
        iconCanceled = "";
        iconDone = "";
        iconFailed = "";
        colorCreated[] = {1,1,1,0};
        colorCanceled[] = {1,1,1,0};
        colorDone[] = {1,1,1,0};
        colorFailed[] = {1,1,1,0};
    };
    class CustomMark
    {
        icon = "\fza_ah64_US\tex\ICONS\ah64_gen_pfz.paa";
        color[] = {0.6471,0.6706,0.6235,0};
        size = 18;
        importance = 1;
        coefMin = 1;
        coefMax = 1;
    };
    class Legend
    {
        x = "SafeZoneX";
        y = "SafeZoneY";
        w = 0.34;
        h = 0.152;
        font = "PuristaMedium";
        sizeEx = 0.03921;
        colorBackground[] = {0.906,0.901,0.88,0};
        color[] = {0,0,0,0};
    };
    class Bunker
    {
        icon = "\fza_ah64_US\tex\ICONS\ah64_gen_pfz.paa";
        color[] = {0.55,0.64,0.43,0};
        size = 14;
        importance = "1.5 * 14 * 0.05";
        coefMin = 0.25;
        coefMax = 4;
    };
    class Bush
    {
        icon = "\fza_ah64_US\tex\ICONS\ah64_gen_pfz.paa";
        color[] = {0.45,0.64,0.33,0};
        size = 14;
        importance = "0.2 * 14 * 0.05";
        coefMin = 0.25;
        coefMax = 4;
    };
    class BusStop
    {
        icon = "\fza_ah64_US\tex\ICONS\ah64_gen_pfz.paa";
        color[] = {0.15,0.26,0.87,0};
        size = 12;
        importance = "1 * 10 * 0.05";
        coefMin = 0.25;
        coefMax = 4;
    };
    class Command
    {
        icon = "\fza_ah64_US\tex\ICONS\ah64_gen_pfz.paa";
        color[] = {0,0.9,0,0};
        size = 18;
        importance = 1;
        coefMin = 1;
        coefMax = 1;
    };
    class Cross
    {
        icon = "\fza_ah64_US\tex\ICONS\ah64_gen_pfz.paa";
        size = 16;
        color[] = {0,0.9,0,0};
        importance = "0.7 * 16 * 0.05";
        coefMin = 0.25;
        coefMax = 4;
    };
    class Fortress
    {
        icon = "\fza_ah64_US\tex\ICONS\ah64_gen_pfz.paa";
        size = 16;
        color[] = {0,0.9,0,0};
        importance = "2 * 16 * 0.05";
        coefMin = 0.25;
        coefMax = 4;
    };
    class Fuelstation
    {
        icon = "\fza_ah64_US\tex\ICONS\ah64_gen_pfz.paa";
        size = 16;
        color[] = {0,0.9,0,0};
        importance = "2 * 16 * 0.05";
        coefMin = 0.75;
        coefMax = 4;
    };
    class Fountain
    {
        icon = "\fza_ah64_US\tex\ICONS\ah64_gen_pfz.paa";
        color[] = {0.2,0.45,0.7,0};
        size = 11;
        importance = "1 * 12 * 0.05";
        coefMin = 0.25;
        coefMax = 4;
    };
    class Hospital
    {
        icon = "\fza_ah64_US\tex\ICONS\ah64_gen_pfz.paa";
        color[] = {0.78,0,0.05,0};
        size = 16;
        importance = "2 * 16 * 0.05";
        coefMin = 0.5;
        coefMax = 4;
    };
    class Chapel
    {
        icon = "\fza_ah64_US\tex\ICONS\ah64_gen_pfz.paa";
        color[] = {0.55,0.64,0.43,0};
        size = 16;
        importance = "1 * 16 * 0.05";
        coefMin = 0.9;
        coefMax = 4;
    };
    class Church
    {
        icon = "\fza_ah64_US\tex\ICONS\ah64_gen_pfz.paa";
        size = 16;
        color[] = {0,0.9,0,0};
        importance = "2 * 16 * 0.05";
        coefMin = 0.9;
        coefMax = 4;
    };
    class Lighthouse
    {
        icon = "\fza_ah64_US\tex\ICONS\ah64_gen_pfz.paa";
        size = 14;
        color[] = {0,0.9,0,0};
        importance = "3 * 16 * 0.05";
        coefMin = 0.9;
        coefMax = 4;
    };
    class Quay
    {
        icon = "\fza_ah64_US\tex\ICONS\ah64_gen_pfz.paa";
        size = 16;
        color[] = {0,0.9,0,0};
        importance = "2 * 16 * 0.05";
        coefMin = 0.5;
        coefMax = 4;
    };
    class Rock
    {
        icon = "\fza_ah64_US\tex\ICONS\ah64_gen_pfz.paa";
        color[] = {0.1,0.1,0.1,0};
        size = 12;
        importance = "0.5 * 12 * 0.05";
        coefMin = 0.25;
        coefMax = 4;
    };
    class Ruin
    {
        icon = "\fza_ah64_US\tex\ICONS\ah64_gen_pfz.paa";
        size = 16;
        color[] = {0,0.9,0,0};
        importance = "1.2 * 16 * 0.05";
        coefMin = 1;
        coefMax = 4;
    };
    class SmallTree
    {
        icon = "\fza_ah64_US\tex\ICONS\ah64_gen_pfz.paa";
        color[] = {0.45,0.64,0.33,0};
        size = 12;
        importance = "0.6 * 12 * 0.05";
        coefMin = 0.25;
        coefMax = 4;
    };
    class Stack
    {
        icon = "\fza_ah64_US\tex\ICONS\ah64_gen_pfz.paa";
        size = 20;
        color[] = {0,0.9,0,0};
        importance = "2 * 16 * 0.05";
        coefMin = 0.9;
        coefMax = 4;
    };
    class Tree
    {
        icon = "\fza_ah64_US\tex\ICONS\ah64_gen_pfz.paa";
        color[] = {0.45,0.64,0.33,0};
        size = 12;
        importance = "0.9 * 16 * 0.05";
        coefMin = 0.25;
        coefMax = 4;
    };
    class Tourism
    {
        icon = "\fza_ah64_US\tex\ICONS\ah64_gen_pfz.paa";
        color[] = {0.78,0,0.05,0};
        size = 16;
        importance = "1 * 16 * 0.05";
        coefMin = 0.7;
        coefMax = 4;
    };
    class Transmitter
    {
        icon = "\fza_ah64_US\tex\ICONS\ah64_gen_pfz.paa";
        color[] = {0,0.9,0,0};
        size = 20;
        importance = "2 * 16 * 0.05";
        coefMin = 0.9;
        coefMax = 4;
    };
    class ViewTower
    {
        icon = "\fza_ah64_US\tex\ICONS\ah64_gen_pfz.paa";
        color[] = {0,0.9,0,0};
        size = 16;
        importance = "2.5 * 16 * 0.05";
        coefMin = 0.5;
        coefMax = 4;
    };
    class Watertower
    {
        icon = "\fza_ah64_US\tex\ICONS\ah64_gen_pfz.paa";
        color[] = {0.2,0.45,0.7,0};
        size = 20;
        importance = "1.2 * 16 * 0.05";
        coefMin = 0.9;
        coefMax = 4;
    };
    class Waypoint
    {
        icon = "\fza_ah64_US\tex\ICONS\ah64_gen_pfz.paa";
        color[] = {0,0.35,0.7,0};
        size = 16;
        importance = "2.5 * 16 * 0.05";
        coefMin = 0.5;
        coefMax = 4;
    };
    class WaypointCompleted
    {
        icon = "\fza_ah64_US\tex\ICONS\ah64_gen_pfz.paa";
        color[] = {0,0.35,0.7,0};
        size = 16;
        importance = "2.5 * 16 * 0.05";
        coefMin = 0.5;
        coefMax = 4;
    };
    class PowerSolar
    {
        icon = "\fza_ah64_US\tex\ICONS\ah64_gen_pfz.paa";
        color[] = {0,0.35,0.7,0};
        size = 16;
        importance = "2.5 * 16 * 0.05";
        coefMin = 0.5;
        coefMax = 4;
    };
    class PowerWave
    {
        icon = "\fza_ah64_US\tex\ICONS\ah64_gen_pfz.paa";
        color[] = {0,0.35,0.7,0};
        size = 16;
        importance = "2.5 * 16 * 0.05";
        coefMin = 0.5;
        coefMax = 4;
    };
    class PowerWind
    {
        icon = "\fza_ah64_US\tex\ICONS\ah64_gen_pfz.paa";
        color[] = {0,0.35,0.7,0};
        size = 16;
        importance = "2.5 * 16 * 0.05";
        coefMin = 0.5;
        coefMax = 4;
    };
    class Shipwreck
    {
        icon = "\fza_ah64_US\tex\ICONS\ah64_gen_pfz.paa";
        color[] = {0,0.35,0.7,0};
        size = 16;
        importance = "2.5 * 16 * 0.05";
        coefMin = 0.5;
        coefMax = 4;
    };
    class ActiveMarker
    {
        color[] = {0.3,0.1,0.9,0};
        size = 50;
    };
};