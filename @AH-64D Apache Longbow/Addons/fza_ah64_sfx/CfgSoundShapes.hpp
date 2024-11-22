class CfgSoundShapes
{
    class fza_base_shape {
        type="cone";
        innerVolume=1.0;
        outervolume=0.6;
        elevation=0;
        azimuth=0;
    };
    class fza_apu_shape: fza_base_shape {
        azimuth=200;
        innerangle=45;
        outerangle=45;
    };
    class fza_ckpt_shape: fza_base_shape {
        azimuth=270;
        innerangle=70;
        outerangle=120;
        outervolume=0.4;
    };
    
    class fza_Turbine_Shape {
        type="cone";
        innerVolume=1.0;
        outervolume=0.6;
        innerangle=130;
        outerangle=210;
        azimuth=180;
        elevation=0;
    };
    class fza_Front_Shape {
        type="cone";
        innerVolume=1.0;
        outervolume=0.4;
        innerangle=150;
        outerangle=230;
        azimuth=0;
        elevation=0;
    };
    class fza_TailRotor_Shape: fza_Turbine_Shape {
        outervolume=0.5;
        innerangle=70;
        outerangle=120;
    };
};