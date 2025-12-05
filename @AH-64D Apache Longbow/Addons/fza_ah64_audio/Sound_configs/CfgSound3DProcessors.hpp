class CfgSound3DProcessors
{
	class fza_Close_3DProcessor
	{
		type="panner";
		rangeCurve="Smooth1Curve";
		innerRange=100;
		range=300;
	};
  class fza_ENG_Trigger_3DProcessor: fza_Close_3DProcessor
	{
		innerRange=3;
		range=20;
	};
	class fza_WindWash_3DProcessor: fza_Close_3DProcessor
	{
		innerRange=5;
		range=15;
	};
	class fza_Distant_3DProcessor: fza_Close_3DProcessor
	{
		innerrange = 100;
		range = 800;
	};
	class fza_TailRotor_3DProcessor: fza_Close_3DProcessor
	{
		innerRange=0;
		range=120;
	};
	class fza_Rotor_3DProcessor: fza_Close_3DProcessor
	{
		innerRange=0;
		range=50;
	};
	class fza_Turbine_3DProcessor: fza_TailRotor_3DProcessor
	{
		type="emitter";
		innerRange=8;
		range=15;
	};
};