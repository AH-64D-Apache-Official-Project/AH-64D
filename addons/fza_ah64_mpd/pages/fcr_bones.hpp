class Fcr_NearBar {
    type = "rotational";
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
// Linear bones for RMAP B-scope scan bar — translate horizontally across the display.
// Arma convention: maxPos = position at min value; minPos = position at max value.
// NearBar: L→R during t=0–1.6s  (ANIM=0→left=0.18, ANIM=1.6→right=0.82)
// FarBar:  R→L during t=1.6–3.2s (ANIM=1.6→right=0.82, ANIM=3.2→left=0.18)
class FCR_RMAP_NearBar {
    type = "linear";
    MPD_NUM_USER(MFD_IND_FCR_ANIM)
    min = 0;
    max = 1.6;
    maxPos[] = {0.18, 0};   // at min(0)   → LEFT start
    minPos[] = {0.82, 0};   // at max(1.6) → RIGHT end
};
class FCR_RMAP_FarBar {
    type = "linear";
    MPD_NUM_USER(MFD_IND_FCR_ANIM)
    min = 1.6;
    max = 3.2;
    maxPos[] = {0.82, 0};   // at min(1.6) → RIGHT start
    minPos[] = {0.18, 0};   // at max(3.2) → LEFT end
};

// TPM-specific rotational scan bar bones — GTM rate: 1.6s per 90 degrees.
// Wide (+-90 deg, speed<45kts): NearBar L->R in 0-3.2s, FarBar R->L in 3.2-6.4s.
// Narrow (+-45 deg, speed>55kts): NearBar L->R in 0-1.6s, FarBar R->L in 1.6-3.2s.
// Arma convention: maxAngle = angle at min value; minAngle = angle at max value.
class Fcr_TPM_NearBar_Wide {
    type = "rotational";
    MPD_NUM_USER(MFD_IND_FCR_ANIM)
    min = 0;   max = 3.2;
    maxAngle =  90;   // at min(0)   -> LEFT
    minAngle = -90;   // at max(3.2) -> RIGHT
    center[] = {0.5, 0.87};
};
class Fcr_TPM_FarBar_Wide {
    type = "rotational";
    MPD_NUM_USER(MFD_IND_FCR_ANIM)
    min = 3.2; max = 6.4;
    maxAngle = -90;   // at min(3.2) -> RIGHT
    minAngle =  90;   // at max(6.4) -> LEFT
    center[] = {0.5, 0.87};
};
class Fcr_TPM_NearBar_Narrow {
    type = "rotational";
    MPD_NUM_USER(MFD_IND_FCR_ANIM)
    min = 0;   max = 1.6;
    maxAngle =  45;
    minAngle = -45;
    center[] = {0.5, 0.87};
};
class Fcr_TPM_FarBar_Narrow {
    type = "rotational";
    MPD_NUM_USER(MFD_IND_FCR_ANIM)
    min = 1.6; max = 3.2;
    maxAngle = -45;
    minAngle =  45;
    center[] = {0.5, 0.87};
};

class Fcr_ATMBar {
    type = "rotational";
    MPD_NUM_USER(MFD_IND_FCR_ANIM)
    min=0;
    max=6.4;
    minAngle=0;
    maxAngle=-360;
    center[] = {0.5,0.5};
};

// ATM sector wedge rotates on the PPI to the slewed bearing (TM fig 4-46).
// The ATM PPI has a 180 deg base rotation, so -y geometry renders aft at value 0; the
// +180 base offset here brings the wedge round to the nose. Per-unit rotation and the
// +bias direction feed (fn_fcrATMDraw) are unchanged, so left/right slew stays correct.
class Fcr_ATMSector {
    type = "rotational";
    MPD_NUM_USER(MFD_IND_FCR_ATM_SECTOR_ROT)
    min=0;
    max=6.4;
    minAngle=180;
    maxAngle=-180;
    center[] = {0.5,0.5};
};

class FCR_CommandHeading {
    type = "linear";
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
// FOR box scale is 0.001/deg (sides 0.38/0.62 = +-120, tics 0.410/0.590 = +-90)
class FCR_Fov_Centerline : FCRCenterline {
    MPD_NUM_USER(MFD_IND_FCR_CENTERLINE)
    maxPos[] = {0.410, 0.939};
    minPos[] = {0.590, 0.939};
};
class FCR_Fov_PrevCenter : FCR_Fov_Centerline {
    MPD_NUM_USER(MFD_IND_FCR_PREV_CENTER)
};

class FCR_FOV_X {
    type = "linear";
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
    type = "linear";
    MPD_NUM_USER(MFD_IND_FCR_CUEDLOS_X)
    min = -120;
    max = 120;
    maxPos[] = {0.4, 0};
    minPos[] = {0.6, 0};
};

class FCR_CuedLOS_Y : FCR_CuedLOS_X {
    MPD_NUM_USER(MFD_IND_FCR_CUEDLOS_Y)
    min = -30;
    max = 60;
    maxPos[] = {0, 0.907};
    minPos[] = {0, 0.971};
};

class FCR_HeadingTape {
    type = "linear";
    source = "heading";
    min = 0;
    max = 360;
    sourceScale = 1;
    maxPos[] = {0.4, 0.06};
    minPos[] = {-0.4, 0.06};
};

MPD_BONE_ACQ_SRC_BOX(Fcr_Acq, MFD_IND_FCR_ACQ_BOX)
