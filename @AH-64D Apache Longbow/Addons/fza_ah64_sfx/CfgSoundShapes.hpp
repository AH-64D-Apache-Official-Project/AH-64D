class CfgSoundShapes
{
    class fza_Turbine_Shape {
        type="cone";
        innerVolume=1.0;
        outervolume=0.4;
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