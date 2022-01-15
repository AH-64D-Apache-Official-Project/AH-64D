class ase_ownship {
    type = fixed;
    pos[] = {0.5, 0.5};
};

class ase_obj_01 {
    type        = rotational;
    MPD_NUM_USER(MFD_IND_ASE_ICON_01_AZ)
    min         = 0;
    max         = 1;
    minAngle    = 0;
    maxAngle    = 360;
    center[]    = {0.5,0.5};
};
/*
class ase_obj_02: ase_obj_01 {
    MPD_NUM_USER(MFD_IND_ASE_ICON_02_AZ)
};
class ase_obj_03: ase_obj_01 {
    MPD_NUM_USER(MFD_IND_ASE_ICON_03_AZ)
};
class ase_obj_04: ase_obj_01 {
    MPD_NUM_USER(MFD_IND_ASE_ICON_04_AZ)
};
class ase_obj_05: ase_obj_01 {
    MPD_NUM_USER(MFD_IND_ASE_ICON_05_AZ)
};
class ase_obj_06: ase_obj_01 {
    MPD_NUM_USER(MFD_IND_ASE_ICON_06_AZ)
};
class ase_obj_07: ase_obj_01 {
    MPD_NUM_USER(MFD_IND_ASE_ICON_07_AZ)
};*/