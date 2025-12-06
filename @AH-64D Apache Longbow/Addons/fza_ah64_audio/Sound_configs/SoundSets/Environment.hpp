class fza_Internal_Base
{
	volumefactor=fza_Vol_Multi_Int(0.3);
	spatial=0;
	loop=1;
};
class fza_External_Base
{
	sound3dprocessingtype="fza_Close_3DProcessor";
	distancefilter="fza_Close_Engine_Filter";
	volumecurve="fza_Ext_Base_Curve";
	occlusionObstruction=1;
	occlusionFactor=0.3;
	obstructionFactor=0.2;
	doppler=1;
	volumefactor=1;
	spatial=1;
	loop=1;
};
class fza_Standard_External_Base: fza_External_Base
{
	sound3dprocessingtype="default3DProcessingType";
};

//External

// -Empty
class fza_Empty_SoundSet: fza_External_Base
{
	soundshaders[]=
	{
		"fza_Empty_SoundShader"
	};
};

// -Alarm
class fza_Alarm_Damage_Ext_SoundSet_Base: fza_Standard_External_Base
{
	soundshaders[]=
	{
		"fza_Alarm_Damage_Ext_SoundShader_Base"
	};
	volumefactor=0.2;
};
class fza_Alarm_RotorLow_Ext_SoundSet_Base: fza_Alarm_Damage_Ext_SoundSet_Base
{
	soundshaders[]=
	{
		"fza_Alarm_RotorLow_Ext_SoundShader_Base"
	};
};

// -Scrub Sound
class fza_ScrubTree_Ext_SoundSet_Base: fza_Standard_External_Base
{
	soundshaders[]=
	{
		"fza_ScrubTree_Ext_SoundShader_Base"
	};
	volumefactor=0.5;
};

// -Damage
class fza_TransmissionDamage_Ext_phase1_SoundSet_Base: fza_Standard_External_Base
{
	soundshaders[]=
	{
		"fza_TransmissionDamage_Ext_phase1_SoundShader_Base"
	};
	volumefactor=0.4;
};
class fza_TransmissionDamage_Ext_phase2_SoundSet_Base: fza_TransmissionDamage_Ext_phase1_SoundSet_Base
{
	soundshaders[]=
	{
		"fza_TransmissionDamage_Ext_phase2_SoundShader_Base"
	};
};

//-SlingLoad
class fza_SlingLoadDown_Ext_SoundSet_Base: fza_Standard_External_Base
{
	soundshaders[]=
	{
		"fza_SlingLoadDown_Ext_SoundShader_Base"
	};
	volumefactor=0.2;
};
class fza_SlingLoadUp_Ext_SoundSet_Base: fza_SlingLoadDown_Ext_SoundSet_Base
{
	soundshaders[]=
	{
		"fza_SlingLoadUp_Ext_SoundShader_Base"
	};
};
//-Noise
class fza_Rain_Ext_SoundSet_Base: fza_Standard_External_Base
{
	soundshaders[]=
	{
		"fza_Rain_Ext_SoundShader_Base"
	};
	volumefactor=0.25;
};
class fza_Rotor_Stress_Ext_SoundSet_Base: fza_External_Base
{
	soundshaders[]=
	{
		"fza_Rotor_Stress_Ext_SoundShader_Base"
	};
	shape="fza_BottomLess_Shape";
	sound3dprocessingtype="fza_Rotor_3DProcessor";
};
class fza_Wind_Close_Ext_SoundSet_Base: fza_External_Base
{
	soundshaders[]=
	{
		"fza_Wind_Close_Ext_SoundShader_Base"
	};
	volumefactor=0.15;
	sound3dprocessingtype="fza_WindWash_3DProcessor";
};

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Internal
// -Alarm
class fza_Alarm_Damage_Int_SoundSet_Base: fza_Internal_Base
{
	soundshaders[]=
	{
		"fza_Alarm_Damage_Int_SoundShader_Base"
	};
	volumefactor=fza_Vol_Multi_Int(2);
};
class fza_Alarm_RotorLow_Int_SoundSet_Base: fza_Internal_Base
{
	soundshaders[]=
	{
		"fza_Alarm_RotorLow_Int_SoundShader_Base"
	};
	volumefactor=fza_Vol_Multi_Int(2);
};

// -Scrub Sound
class fza_ScrubLand_Int_SoundSet_Base: fza_Internal_Base
{
	soundshaders[]=
	{
		"fza_ScrubLand_Int_SoundShader_Base"
	};
};
class fza_ScrubBuilding_Int_SoundSet_Base: fza_Internal_Base
{
	soundshaders[]=
	{
		"fza_ScrubBuilding_Int_SoundShader_Base"
	};
};
class fza_ScrubTree_Int_SoundSet_Base: fza_Internal_Base
{
	soundshaders[]=
	{
		"fza_ScrubTree_Int_SoundShader_Base"
	};
};

// -Damage
class fza_TransmissionDamage_Int_phase1_SoundSet_Base: fza_Internal_Base
{
	soundshaders[]=
	{
		"fza_TransmissionDamage_Int_phase1_SoundShader_Base"
	};
};
class fza_TransmissionDamage_Int_phase2_SoundSet_Base: fza_Internal_Base
{
	soundshaders[]=
	{
		"fza_TransmissionDamage_Int_phase2_SoundShader_Base"
	};
};
class fza_TransmissionDamage_Int_phase3_SoundSet_Base: fza_Internal_Base
{
	soundshaders[]=
	{
		"fza_TransmissionDamage_Int_phase3_SoundShader_Base"
	};
};

//-SlingLoad
class fza_SlingLoadDown_Int_SoundSet_Base: fza_Internal_Base
{
	soundshaders[]=
	{
		"fza_SlingLoadDown_Int_SoundShader_Base"
	};
};
class fza_SlingLoadUp_Int_SoundSet_Base: fza_Internal_Base
{
	soundshaders[]=
	{
		"fza_SlingLoadUp_Int_SoundShader_Base"
	};
};

//-Noise
class fza_Rain_Int_SoundSet_Base: fza_Internal_Base
{
	soundshaders[]=
	{
		"fza_Rain_Int_SoundShader_Base"
	};
	volumefactor=fza_Vol_Multi_Int(0.5);
};
class fza_Wind_Int_SoundSet_Base: fza_Internal_Base
{
	soundshaders[]=
	{
		"fza_Wind_Int_SoundShader_Base"
	};
};
class fza_WindWash_Int_SoundSet_Base: fza_Internal_Base
{
	soundshaders[]=
	{
		"fza_WindWash_Int_SoundShader_Base"
	};
	volumeFactor=fza_Vol_Multi_Int(1.2);
};
class fza_FrameStress_Int_SoundSet_Base: fza_Internal_Base
{
	soundshaders[]=
	{
		"fza_FrameStress_Int_SoundShader_Base"
	};
	volumeFactor=fza_Vol_Multi_Int(0.8);
};
class fza_GStress_Int_SoundSet_Base: fza_Internal_Base
{
	soundshaders[]=
	{
		"fza_GStress_Int_SoundShader_Base"
	};
	volumeFactor=fza_Vol_Multi_Int(0.45);
};
class fza_SpeedStress_Int_SoundSet_Base: fza_Internal_Base
{
	soundshaders[]=
	{
		"fza_SpeedStress_Int_SoundShader_Base"
	};
};