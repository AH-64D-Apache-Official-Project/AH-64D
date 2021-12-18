class Flt_Horizon {
    type = horizon;
    angle = -5;
    pos0[] = {0.5, 0.5};
    pos10[] = {0.57, 0.57};
};

class Flt_RadarAlt {
    type = linear;
    source = altitudeAGL
    sourceScale = MPD_SCALE_METERS_FEET;
    min = 0;
    max = 200;
    maxPos[] = {0, 0};
    minPos[] = {0, -0.5};
};

class Flt_VerticalSpeed {
    type = linear;
    source = vspeed;
    sourceScale = MPD_SCALE_METERS_PER_SECOND_FEET_PER_MINUTE;
    max = 1000;
    min = -1000;
    maxPos[] = {0, 0.25};
    minPos[] = {0, -0.25};
};

class Flt_BankAngle {
    type = rotational;
    source = horizonBank;
    sourceScale = MPD_SCALE_RADIANS_DEGREES;
    min = -180;
    max = 180;
    minAngle = -180;
    maxAngle = 180;
    center[] = {0.5, 0.5};
};

class Flt_TurnIndicator {
    type = linear;
    MPD_NUM_USER(MFD_IND_FLT_TURN)
    sourceScale = 1;
    min = -1.5;
    max = 1.5;
    maxPos[] = {0.38, 0.915};
    minPos[] = {0.62, 0.915};
};

class Flt_SlipIndicator {
    type = linear;
    MPD_NUM_USER(MFD_IND_FLT_SLIP)
    sourceScale = 1;
    min = -9.5;
    max = 9.5;
    maxPos[] = {0.375, 0.9525};
    minPos[] = {0.625, 0.9525};
};

class Flt_FlyToCueX {
    type = linear;
    MPD_NUM_USER(MFD_IND_FLT_FLY_TO_CUE_X)
    min = -20;
    max = 20;
    maxPos[] = {-0.1, 0};
    minPos[] = {1.1, 0};
};

class Flt_FlyToCueY : Flt_FlyToCueX {
    MPD_NUM_USER(MFD_IND_FLT_FLY_TO_CUE_Y)
    maxPos[] = {0, 1.1};
    minPos[] = {0, -0.1};
};

class Flt_FlightPathVectorX : Flt_FlyToCueX {
    MPD_NUM_USER(MFD_IND_FLT_FLIGHT_PATH_X)
};

class Flt_FlightPathVectorY : Flt_FlyToCueY {
    MPD_NUM_USER(MFD_IND_FLT_FLIGHT_PATH_Y)
};

class Flt_CommandHeading {
    type = linear;
    MPD_NUM_USER(MFD_IND_FLT_COMMAND_HEADING)
    min = -90;
    max = 90;
    maxPos[] = {0.25, 0.18};
    minPos[] = {0.75, 0.18};
};

class Flt_FCRCenterline : Flt_CommandHeading {
    MPD_NUM_USER(MFD_IND_FLT_FCR_CENTERLINE)
};

class Flt_AltSensorBearing : Flt_CommandHeading {
    MPD_NUM_USER(MFD_IND_FLT_ALTERNATE_SENSOR)
};