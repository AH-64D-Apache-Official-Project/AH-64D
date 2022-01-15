class ase_ownship {
    type = fixed;
    pos[] = {0.5, 0.5};
};

class ase_obj_iconTranslate {
    type = fixed;
    pos[] = {0, 0.27};
};
//ASE object 01
class ase_obj_01 {
    type        = rotational;
    MPD_NUM_USER(MFD_IND_ASE_OBJECT_01_AZ)
    min         = 0;
    max         = 360;
    minAngle    = 0;
    maxAngle    = 360;
    center[]    = {0.5,0.5};
};
class ase_obj_01_iconRotCorr {
    type        = rotational;
    MPD_NUM_USER(MFD_IND_ASE_OBJECT_01_AZ)
    min         = 0;
    max         = 360;
    minAngle    = 0;
    maxAngle    = 360;
    center[]    = {0,0};
};
//ASE object 02
class ase_obj_02: ase_obj_01 {
    MPD_NUM_USER(MFD_IND_ASE_OBJECT_02_AZ)
};
class ase_obj_02_iconRotcorr: ase_obj_01_iconRotCorr{
    MPD_NUM_USER(MFD_IND_ASE_OBJECT_02_AZ)
};
//ASE object 03
class ase_obj_03: ase_obj_01 {
    MPD_NUM_USER(MFD_IND_ASE_OBJECT_03_AZ)
};
class ase_obj_03_iconRotcorr: ase_obj_01_iconRotCorr{
    MPD_NUM_USER(MFD_IND_ASE_OBJECT_03_AZ)
};
//ASE object 04
class ase_obj_04: ase_obj_01 {
    MPD_NUM_USER(MFD_IND_ASE_OBJECT_04_AZ)
};
class ase_obj_04_iconRotcorr: ase_obj_01_iconRotCorr{
    MPD_NUM_USER(MFD_IND_ASE_OBJECT_04_AZ)
};
//ASE object 05
class ase_obj_05: ase_obj_01 {
    MPD_NUM_USER(MFD_IND_ASE_OBJECT_05_AZ)
};
class ase_obj_05_iconRotcorr: ase_obj_01_iconRotCorr{
    MPD_NUM_USER(MFD_IND_ASE_OBJECT_05_AZ)
};
//ASE object 06
class ase_obj_06: ase_obj_01 {
    MPD_NUM_USER(MFD_IND_ASE_OBJECT_06_AZ)
};
class ase_obj_06_iconRotcorr: ase_obj_01_iconRotCorr{
    MPD_NUM_USER(MFD_IND_ASE_OBJECT_06_AZ)
};
//ASE object 07
class ase_obj_07: ase_obj_01 {
    MPD_NUM_USER(MFD_IND_ASE_OBJECT_07_AZ)
};
class ase_obj_07_iconRotcorr: ase_obj_01_iconRotCorr{
    MPD_NUM_USER(MFD_IND_ASE_OBJECT_07_AZ)
};