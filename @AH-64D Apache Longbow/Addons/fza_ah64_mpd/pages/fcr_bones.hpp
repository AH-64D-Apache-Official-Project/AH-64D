class Fcr_NearBar {
    type = rotational;
    MPD_NUM_USER(MFD_IND_FCR_ANIM)
    min=0;
    max=1;
    minAngle = -45;
    maxAngle = 45;
    center[] = {0.5,0.87};
};
class Fcr_FarBar : Fcr_NearBar {
    min=1;
    max=2;
    minAngle=45;
    maxAngle=-45;
};

MPD_BONE_ACQ_SRC_BOX(Fcr_Acq, MFD_IND_FCR_ACQ_BOX)