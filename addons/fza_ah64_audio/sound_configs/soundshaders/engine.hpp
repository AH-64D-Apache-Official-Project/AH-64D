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
	frequency="1.15 * CustomSoundController1";
	volume="camPos*CustomSoundController1*(CustomSoundController14+1)";
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
	frequency="CustomSoundController17 * CustomSoundController15";
	volume="camext*rotorSpeed*(CustomSoundController14+1)*(0 max (CustomSoundController17-0.1)) * CustomSoundController15";
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
	frequency="CustomSoundController17 * CustomSoundController15";
	volume="camext*rotorSpeed*((CustomSoundController17-0.72)*4)*(CustomSoundController14+1) * CustomSoundController15";
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
	frequency="CustomSoundController17 * CustomSoundController15";
	volume="camext*rotorSpeed*(CustomSoundController17 factor [0.3, 1])*(CustomSoundController14+1) * CustomSoundController15";
	range=1000;
	rangecurve[]=
	{
		{0,0.35},
		{150,1},
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
	frequency="(CustomSoundController17 factor [0.3, 0.7]) * CustomSoundController15";
	volume="camext*rotorSpeed*(CustomSoundController17 factor [0.3, 1])*(CustomSoundController14+1) * CustomSoundController15";
	range=1200;
	rangecurve[]=
	{
		{0,0.2},
		{500,1},
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
	frequency="CustomSoundController17 * (1 - rotorThrust/10) * (0.2 max CustomSoundController15)";
	volume="camext*rotorSpeed*(CustomSoundController14+1)*(0 max (CustomSoundController17-0.4)) * (0.25 max CustomSoundController15)";
	range=200;
	rangecurve[]=
	{
		{0,1},
		{50,0.65},
		{200,0}
	};
};

//-Startup + Shutdown
class fza_ah64_Starter_Ext_SoundShader
{
	samples[]=
	{

		{
			"\fza_ah64_audio\audio\Engine\Env\share\Engine_Starter.wss",
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
		{300,0}
	};
};
class fza_ah64_Turbine_Starter_Ext_SoundShader: fza_ah64_Starter_Ext_SoundShader
{
	samples[]=
	{

		{
			"\fza_ah64_audio\audio\Engine\Env\share\Engine_Turbine_Starter.ogg",
			1
		}
	};
	volume="camext*(CustomSoundController14+1)";
};
class fza_ah64_Shutdown_Ext_SoundShader: fza_ah64_Starter_Ext_SoundShader
{
	samples[]=
	{

		{
			"\fza_ah64_audio\audio\Engine\Env\share\Engine_Shutdown.ogg",
			1
		}
	};
	volume="camext*(CustomSoundController14+1)";
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
class fza_ah64_Turbine_Starter_Int_SoundShader: fza_ah64_Turbine_Starter_Ext_SoundShader
{
	samples[]=
	{

		{
			"\fza_ah64_audio\audio\Engine\Env\share\Engine_Turbine_Starter_Int.ogg",
			1
		}
	};
	volume="camInt*(CustomSoundController16+1)";
};
class fza_ah64_Startup_Int_SoundShader: fza_ah64_Starter_Ext_SoundShader
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
	volume="camInt*(CustomSoundController16+1)";
};

// -APU
class fza_APUSoundLoop_Int_SoundShader: fza_APUSoundLoop_Ext_SoundShader
{
	samples[]=
	{
		
		{
			"\fza_ah64_audio\audio\Engine\Env\share\apu_int_loop.ogg",
			1
		}
	};
	volume="camInt*CustomSoundController1*(CustomSoundController16+1)";
};
class fza_BattLoop_Int_SoundShader: fza_APUSoundLoop_Int_SoundShader
{
	samples[]=
	{
		
		{
			"\fza_ah64_audio\audio\Engine\Env\share\avionics.ogg",
			1
		}
	};
	frequency=1;
	volume="camInt*CustomSoundController2*(CustomSoundController16+1)";
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
	frequency="CustomSoundController17 * CustomSoundController15";
	volume="camInt*rotorSpeed*(CustomSoundController17 factor [0.3, 1])*(CustomSoundController16+1) * (0.7 max CustomSoundController15)";
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
	frequency="CustomSoundController17";
	volume="camInt*rotorSpeed*(0 max (CustomSoundController17-0.1))*(CustomSoundController17 factor [0.3, 1])*((playerPos interpolate [0,1,1,4]) max 1)*(CustomSoundController16+1) * (0.25 max CustomSoundController15)";
};
