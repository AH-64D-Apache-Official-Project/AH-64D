class ase_ownship {
    type = fixed;
    pos[] = {0.5, 0.5};
};

class ase_az_01 {
    type        = rotational;
    MPD_NUM_USER(MFD_IND_ASE_01_AZ)
    min         = 0;
    max         = 360;
    minAngle    = 0;
    maxAngle    = 360;
    center[]    = {0.5,0.5};
};
class ase_az_02: ase_az_01 {
    MPD_NUM_USER(MFD_IND_ASE_02_AZ)
};
class ase_az_03: ase_az_01 {
    MPD_NUM_USER(MFD_IND_ASE_03_AZ)
};
class ase_az_04: ase_az_01 {
    MPD_NUM_USER(MFD_IND_ASE_04_AZ)
};
class ase_az_05: ase_az_01 {
    MPD_NUM_USER(MFD_IND_ASE_05_AZ)
};
class ase_az_06: ase_az_01 {
    MPD_NUM_USER(MFD_IND_ASE_06_AZ)
};
class ase_az_07: ase_az_01 {
    MPD_NUM_USER(MFD_IND_ASE_07_AZ)
};