class CfgSoundShapes
{
	class fza_Front_Shape
	{
		type="cone";
		innerVolume=1.0;
		outervolume=0.4;
		innerangle=150;
		outerangle=230;
		azimuth=0;
		elevation=0;
	};
  class fza_Rear_Shape: fza_Front_Shape
	{
		innerVolume=1.0;
		outervolume=0.65;
		innerangle=120;
		outerangle=240;
		azimuth=180;
	};
  class fza_Bottom_Shape
	{
		innerVolume=1;
		outervolume=0.8;
		innerangle=140;
		outerangle=160;
		azimuth=0;
    elevation=-90;
	};
  class fza_BottomLess_Shape: fza_Bottom_Shape
	{
		innerVolume=0;
		outervolume=1;
		innerangle=140;
		outerangle=160;
	};
  class fza_Turbine_Shape: fza_Rear_Shape
	{
    outervolume=0.15;
		innerangle=130;
		outerangle=210;
	};
	class fza_Distance_Shape: fza_Rear_Shape
	{
		outervolume=0.45;
		innerangle=65;
		outerangle=100;
	};
};