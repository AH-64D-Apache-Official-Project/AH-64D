// -APU
class fza_APUSoundLoop_Ext_SoundSet: fza_Standard_External_Base
{
	soundshaders[] = 
	{
		"fza_APUSoundLoop_Ext_SoundShader"
	};
	volumefactor=0.25;
};

//External
class fza_Rotor_Distance_SoundSet: fza_External_Base
{
	soundshaders[]=
	{
		"fza_Rotor_Distance_SoundShader"
	};
	volumeFactor=0.5;
	shape="fza_BottomLess_Shape";
	volumecurve="fza_Ext_Distant_Curve";
	distancefilter="fza_Distant_Engine_Filter";
	sound3dprocessingtype="fza_Distant_3DProcessor";
	// doppler=1;
};
class fza_Engine_Distance_SoundSet: fza_Rotor_Distance_SoundSet
{
	soundshaders[]=
	{
		"fza_Engine_Distance_SoundShader"
	};
	volumeFactor=0.75;
	shape="fza_Front_Shape";
	// doppler=1;
};
class fza_EngineExt_SoundSet: fza_External_Base
{
	soundshaders[]=
	{
		"fza_EngineExt_SoundShader"
	};
	volumefactor=0.8;
	volumecurve="fza_Tail_Rotor_Curve";
	sound3dprocessingtype="fza_TailRotor_3DProcessor";
	posoffset[]={0,0,-10};
	// doppler=1;
};
class fza_RotorExt_SoundSet: fza_External_Base
{
	soundshaders[]=
	{
		"fza_RotorExt_SoundShader"
	};
	volumeFactor=0.75;
	shape="fza_BottomLess_Shape";
	sound3dprocessingtype="fza_Rotor_3DProcessor";
};
class fza_Turbine_Ext_SoundSet: fza_External_Base
{
	soundshaders[]=
	{
		"fza_Turbine_Ext_SoundShader"
	};
	volumeFactor=0.5;
	shape="fza_Turbine_Shape";
	sound3dprocessingtype="fza_Turbine_3DProcessor";
};

//- Startup + Shutdown
class fza_ah64_APU_Start_Ext_SoundSet: fza_External_Base
{
	soundshaders[]=
	{
		"fza_ah64_APU_Start_Ext_SoundShader"
	};
	volumeFactor=0.2;
	playTrigger="CustomSoundController9";
	loop=0;
	sound3dprocessingtype="fza_ENG_Trigger_3DProcessor";
	frequencyRandomizerMin=1;
};
class fza_ah64_Starter_Ext_Left_SoundSet: fza_ah64_APU_Start_Ext_SoundSet
{
	soundshaders[]=
	{
		"fza_ah64_Starter_Ext_SoundShader"
	};
	volumeFactor=0.4;
	playTrigger="CustomSoundController5";
};
class fza_ah64_Starter_Ext_Right_SoundSet: fza_ah64_Starter_Ext_Left_SoundSet
{
	playTrigger="CustomSoundController6";
};
class fza_ah64_Startup_Ext_Left_SoundSet: fza_ah64_APU_Start_Ext_SoundSet
{
	soundshaders[]=
	{
		"fza_ah64_Startup_Ext_SoundShader"
	};
	volumeFactor=1;
	playTrigger="CustomSoundController10";
};
class fza_ah64_Startup_Ext_Right_SoundSet: fza_ah64_Startup_Ext_Left_SoundSet
{
	playTrigger="CustomSoundController12";
};
class fza_ah64_Shutdown_Ext_Left_SoundSet: fza_ah64_APU_Start_Ext_SoundSet
{
	soundshaders[]=
	{
		"fza_ah64_Shutdown_Ext_SoundShader"
	};
	volumeFactor=0.5;
	playTrigger="CustomSoundController11";
};
class fza_ah64_Shutdown_Ext_Right_SoundSet: fza_ah64_Shutdown_Ext_Left_SoundSet
{
	playTrigger="CustomSoundController13";
};

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class fza_ah64_APU_Start_Int_SoundSet: fza_Internal_Base
{
	soundshaders[]=
	{
		"fza_ah64_APU_Start_Int_SoundShader"
	};
	sound3dprocessingtype="VehicleInt_Back_3DProcessingType";
	volumeFactor=fza_Vol_Multi_Int(0.5);
	playTrigger="CustomSoundController9";
	loop=0;
};
class fza_ah64_Starter_Int_Left_SoundSet: fza_ah64_APU_Start_Int_SoundSet
{
	soundshaders[]=
	{
		"fza_ah64_Starter_Int_SoundShader"
	};
	sound3dprocessingtype="fza_VehicleInt_Left_3DProcessingType";
	volumeFactor=fza_Vol_Multi_Int(0.1);
	playTrigger="CustomSoundController5";

	frequencyRandomizerMin=1;
};
class fza_ah64_Starter_Int_Right_SoundSet: fza_ah64_Starter_Int_Left_SoundSet
{
	sound3dprocessingtype="fza_VehicleInt_Right_3DProcessingType";
	playTrigger="CustomSoundController6";
};
class fza_ah64_Startup_Int_Left_SoundSet: fza_ah64_APU_Start_Int_SoundSet
{
	soundshaders[]=
	{
		"fza_ah64_Startup_Int_SoundShader"
	};
	sound3dprocessingtype="fza_VehicleInt_Left_3DProcessingType";
	volumeFactor=fza_Vol_Multi_Int(2);
	playTrigger="CustomSoundController10";

	frequencyRandomizerMin=1;
};
class fza_ah64_Startup_Int_Right_SoundSet: fza_ah64_Startup_Int_Left_SoundSet
{
	sound3dprocessingtype="fza_VehicleInt_Right_3DProcessingType";
	playTrigger="CustomSoundController12";
};
class fza_ah64_Shutdown_Int_Left_SoundSet: fza_ah64_APU_Start_Int_SoundSet
{
	soundshaders[]=
	{
		"fza_ah64_Shutdown_Int_SoundShader"
	};
	sound3dprocessingtype="fza_VehicleInt_Left_3DProcessingType";
	volumeFactor=fza_Vol_Multi_Int(2);
	playTrigger="CustomSoundController11";

	frequencyRandomizerMin=1;
};
class fza_ah64_Shutdown_Int_Right_SoundSet: fza_ah64_Shutdown_Int_Left_SoundSet
{
	sound3dprocessingtype="fza_VehicleInt_Right_3DProcessingType";
	playTrigger="CustomSoundController13";
};


// -APU
class fza_ApuSoundLoop_Int_SoundSet: fza_Internal_Base
{
	soundshaders[] = 
	{
		"fza_ApuSoundLoop_Int_SoundShader"
	};
	volumefactor=fza_Vol_Multi_Int(1);
};
class fza_BattLoop_Int_SoundSet: fza_Internal_Base
{
	soundshaders[] = 
	{
		"fza_BattLoop_Int_SoundShader"
	};
	volumefactor=fza_Vol_Multi_Int(0.5);
};

//Internal
class fza_EngineInt_SoundSet: fza_Internal_Base
{
	soundshaders[]=
	{
		"fza_EngineInt_SoundShader"
	};
	volumefactor=fza_Vol_Multi_Int(1.2);
};
class fza_RotorInt_SoundSet: fza_EngineInt_SoundSet
{
	soundshaders[]=
	{
		"fza_RotorInt_SoundShader"
	};
};