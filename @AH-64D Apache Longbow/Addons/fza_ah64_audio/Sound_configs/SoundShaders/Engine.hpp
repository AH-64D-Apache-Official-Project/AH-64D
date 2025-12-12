//External
// -APU
class fza_APUSoundLoop_Ext_SoundShader
{
	samples[]=
	{
		
		{
			"\fza_ah64_audio\audio\Engine\Env\share\apu_ext_loop.ogg",
			1
		}
	};
	frequency="CustomSoundController1";
	volume="camPos*CustomSoundController2*(CustomSoundController14+1)";
	range=200;
	rangecurve[]=
	{
		{0,1},
		{100,0.6},
		{200,0}
	};
};
class fza_Rotor_Distance_SoundShader
{
	samples[]=
	{
		
		{
			"\fza_ah64_audio\audio\Engine\Ext\Distant_Rotor.ogg",
			1
		}
	};
	frequency="rotorspeed * (1-rotorthrust/15) * (CustomSoundController15 + 0.75)";
	volume="(CustomSoundController14+1)*camext*(0 max (rotorspeed-0.1))*(1 + rotorthrust) * (CustomSoundController15 + 0.75)";
	range=3000;
	rangecurve[]=
	{
		{0,0},
		{100,0},
		{600,1},
		{1000,0.15},
		{3000,0}
	};
};
class fza_Engine_Distance_SoundShader
{
	samples[]=
	{
		
		{
			"\fza_ah64_audio\audio\Engine\Ext\Distant_Engine.ogg",
			1
		}
	};
	frequency="rotorspeed*(1-rotorthrust/15) * (CustomSoundController15 + 0.75)";
	volume="camext*((rotorspeed-0.72)*4)*(CustomSoundController14+1) * (CustomSoundController15 + 0.75)";
	range=3000;
	rangecurve[]=
	{
		{0,0},
		{800,1},
		{2000,0.3},
		{3000,0}
	};
};
class fza_EngineExt_SoundShader
{
	samples[]=
	{
		
		{
			"\fza_ah64_audio\audio\Engine\Ext\Engine_Ext.ogg",
			1
		}
	};
	frequency="rotorSpeed*(1+rotorThrust/15)";
	volume="camext*(rotorSpeed factor [0.3, 1])*(CustomSoundController14+1)";
	range=1000;
	rangecurve[]=
	{
		{0,0.35},
		{300,1},
		{800,0.3},
		{1000,0}
	};
};
class fza_RotorExt_SoundShader: fza_EngineExt_SoundShader
{
	samples[]=
	{
		
		{
			"\fza_ah64_audio\audio\Engine\Ext\Rotor_Ext.ogg",
			1
		}
	};
	frequency="(rotorSpeed factor [0.3, 0.7])*(1 - rotorThrust/10) * (CustomSoundController15 + 0.75)";
	volume="camext*(rotorSpeed factor [0.3, 1])*(1 + (rotorThrust * 1.2))*(CustomSoundController14+1) * (CustomSoundController15 + 0.75)";
	range=1200;
	rangecurve[]=
	{
		{0,0.2},
		{150,1},
		{1000,0.4},
		{1200,0}
	};
};
class fza_Turbine_Ext_SoundShader
{
	samples[]=
	{
		
		{
			"\fza_ah64_audio\audio\Engine\Ext\Turbine_Ext.ogg",
			1
		}
	};
	frequency="rotorSpeed * (CustomSoundController15 + 0.75)";
	volume="(CustomSoundController14+1)*camext*(0 max (rotorSpeed-0.4)) * (CustomSoundController15 + 0.75)";
	range=500;
	rangecurve[]=
	{
		{0,1},
		{30,1},
		{400,0.65},
		{500,0}
	};
};

//-Startup + Shutdown
class fza_ah64_Starter_Ext_SoundShader
{
	samples[]=
	{

		{
			"\fza_ah64_audio\audio\Engine\Env\share\Engine_Start.ogg",
			1
		}
	};
	frequency=1;
	volume="camext*(CustomSoundController14+1)";
	range=300;
	rangecurve[]=
	{
		{0,1},
		{30,1},
		{100,0.65},
		{600,0}
	};
};
class fza_ah64_Startup_Ext_SoundShader: fza_ah64_Starter_Ext_SoundShader
{
	samples[]=
	{

		{
			"\fza_ah64_audio\audio\Engine\Env\share\Engine_Start.ogg",
			1
		}
	};
	volume="camext*(CustomSoundController14+1)";
};
class fza_ah64_Shutdown_Ext_SoundShader: fza_ah64_Startup_Ext_SoundShader
{
	samples[]=
	{

		{
			"\fza_ah64_audio\audio\Engine\Env\share\Engine_Shutdown.ogg",
			1
		}
	};
	volume="camext*(CustomSoundController14+1) * CustomSoundController11";
};
class fza_ah64_APU_Start_Ext_SoundShader: fza_ah64_Startup_Ext_SoundShader
{
	samples[]=
	{

		{
			"\fza_ah64_audio\audio\Engine\Env\share\APU_Start_Ext.ogg",
			1
		}
	};
	volume="camext*(CustomSoundController14+1)*CustomSoundController9";
};

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Internal

class fza_ah64_Starter_Int_SoundShader: fza_ah64_Starter_Ext_SoundShader
{
	samples[]=
	{

		{
			"\fza_ah64_audio\audio\Engine\Env\share\Engine_Starter_Int.ogg",
			1
		}
	};
	volume="camInt*(CustomSoundController16+1)";
};
class fza_ah64_Startup_Int_SoundShader: fza_ah64_Startup_Ext_SoundShader
{
	samples[]=
	{

		{
			"\fza_ah64_audio\audio\Engine\Env\share\Engine_Start_Int.ogg",
			1
		}
	};
	volume="camInt*(CustomSoundController16+1)";
};
class fza_ah64_Shutdown_Int_SoundShader: fza_ah64_Startup_Int_SoundShader
{
	samples[]=
	{

		{
			"\fza_ah64_audio\audio\Engine\Env\share\Engine_Shutdown_Int.ogg",
			1
		}
	};
	volume="camInt*(CustomSoundController16+1) * CustomSoundController11";
};
class fza_ah64_APU_Start_Int_SoundShader: fza_ah64_Startup_Int_SoundShader
{
	samples[]=
	{

		{
			"\fza_ah64_audio\audio\Engine\Env\share\APU_Start_Int.ogg",
			1
		}
	};
	frequency=1;
	volume="camInt*(CustomSoundController16+1)*CustomSoundController9";
};

// -APU
class fza_ApuSoundLoop_Int_SoundShader: fza_ApuSoundLoop_Ext_SoundShader
{
	samples[]=
	{
		
		{
			"\fza_ah64_audio\audio\Engine\Env\share\apu_int_loop.ogg",
			1
		}
	};
	volume="camInt*CustomSoundController2*(CustomSoundController16+1)";
};
class fza_BattLoop_Int_SoundShader: fza_ApuSoundLoop_Int_SoundShader
{
	samples[]=
	{
		
		{
			"\fza_ah64_audio\audio\Engine\Env\share\avionics.ogg",
			1
		}
	};
	frequency=1;
	volume="camInt*CustomSoundController5*(CustomSoundController16+1)";
};

class fza_EngineInt_SoundShader
{
	samples[]=
	{
		
		{
			"\fza_ah64_audio\audio\Engine\Int\Engine_Int.ogg",
			1
		}
	};
	frequency="rotorSpeed*(1+rotorThrust/15) * (CustomSoundController15 + 0.75)";
	volume="camInt*(rotorSpeed factor [0.3, 1])*(CustomSoundController16+1) * (CustomSoundController15 + 0.75)";
};
class fza_RotorInt_SoundShader
{
	samples[]=
	{
		
		{
			"\fza_ah64_audio\audio\Engine\Int\Rotor_Int.ogg",
			1
		}
	};
	frequency="rotorSpeed*(1-rotorThrust/15)";
	volume="camInt*(0 max (rotorSpeed-0.1))*(1 + rotorThrust)*(rotorSpeed factor [0.3, 1])*((playerPos interpolate [0,1,1,4]) max 1)*(CustomSoundController16+1)";
};