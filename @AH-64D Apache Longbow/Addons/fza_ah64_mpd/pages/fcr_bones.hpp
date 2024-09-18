class Fcr_NearBar {
    type = rotational;
    MPD_NUM_USER(MFD_IND_FCR_ANIM)
    min=0;
    max=1.6;
    minAngle = -45;
    maxAngle = 45;
    center[] = {0.5,0.87};
};
class Fcr_FarBar : Fcr_NearBar {
    min=1.6;
    max=3.2;
    minAngle=45;
    maxAngle=-45;
};
class Fcr_ATMBar {
    type = rotational;
    MPD_NUM_USER(MFD_IND_FCR_ANIM)
    min=0;
    max=6.4;
    minAngle=0;
    maxAngle=-360;
    center[] = {0.5,0.5};
};

class FCR_CommandHeading {
    type = linear;
    MPD_NUM_USER(MFD_IND_FCR_COMMAND_HEADING)
    min = -90;
    max = 90;
    maxPos[] = {0.3, 0.09};
    minPos[] = {0.7, 0.09};
};
class FCR_AltSensorBearing : FCR_CommandHeading {
    MPD_NUM_USER(MFD_IND_FCR_ALTERNATE_SENSOR)
};

class FCRCenterline : FCR_CommandHeading {
    MPD_NUM_USER(MFD_IND_FCR_CENTERLINE)
};
class FCR_Fov_Centerline : FCRCenterline {
    MPD_NUM_USER(MFD_IND_FCR_CENTERLINE)
    maxPos[] = {0.39, 0.939};
    minPos[] = {0.61, 0.939};
};
class FCR_Fov_PrevCenter : FCR_Fov_Centerline {
    MPD_NUM_USER(MFD_IND_FCR_PREV_CENTER)
};

class FCR_FOV_X {
    type = linear;
    MPD_NUM_USER(MFD_IND_FCR_FOV_X)
    min = -120;
    max = 120;
    maxPos[] = {0.4, 0};
    minPos[] = {0.6, 0};
};
class FCR_FOV_Y : FCR_FOV_X {
    MPD_NUM_USER(MFD_IND_FCR_FOV_Y)
    min = -30;
    max = 60;
    maxPos[] = {0, 0.907};
    minPos[] = {0, 0.971};
};

class FCR_CuedLOS_X {
    type = linear;
    MPD_NUM_USER(MFD_IND_FCR_CuedLOS_X)
    min = -120;
    max = 120;
    maxPos[] = {0.4, 0};
    minPos[] = {0.6, 0};
};

class FCR_CuedLOS_Y : FCR_CuedLOS_X {
    MPD_NUM_USER(MFD_IND_FCR_CuedLOS_Y)
    min = -30;
    max = 60;
    maxPos[] = {0, 0.907};
    minPos[] = {0, 0.971};
};

class FCR_HeadingTape {
    type = linear;
    source = heading;
    min = 0;
    max = 360;
    sourceScale = 1;
    maxPos[] = {0.4, 0.06};
    minPos[] = {-0.4, 0.06};
};

MPD_BONE_ACQ_SRC_BOX(Fcr_Acq, MFD_IND_FCR_ACQ_BOX)