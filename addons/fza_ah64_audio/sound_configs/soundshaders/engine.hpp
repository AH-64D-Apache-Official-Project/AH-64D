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
	frequency=QUOTE(CustomSoundController1);

	//- Make sure volume reduced when Power is pushed to FLY
	volume=QUOTE(camext*EXT_VOL_CONTROLLER * CustomSoundController1 * FACTOR(NP_CONTROLLER,1,0)); 
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
	frequency=QUOTE(NP_CONTROLLER);
	volume=QUOTE(camext*rotorSpeed*EXT_VOL_CONTROLLER*(0 max (NP_CONTROLLER-0.1)));
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
	frequency=QUOTE(NP_CONTROLLER);
	volume=QUOTE(camext*rotorSpeed*EXT_VOL_CONTROLLER*((NP_CONTROLLER-0.72)*4));
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
	frequency=QUOTE(NP_CONTROLLER);
	volume=QUOTE(camext*rotorSpeed*EXT_VOL_CONTROLLER * FACTOR(NP_CONTROLLER,0.3,1));
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
	frequency=QUOTE(FACTOR(NP_CONTROLLER,0.3,0.7));
	volume=QUOTE(camext*rotorSpeed*EXT_VOL_CONTROLLER * FACTOR(NP_CONTROLLER,0.3,1));
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
	frequency=QUOTE(NP_CONTROLLER);
	volume=QUOTE(camext*rotorSpeed*EXT_VOL_CONTROLLER*(0 max (NP_CONTROLLER-0.4)) * FACTOR(NP_CONTROLLER,0.75,1));
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
	volume=QUOTE(camext*EXT_VOL_CONTROLLER);
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
	volume=QUOTE(camext*EXT_VOL_CONTROLLER);
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
	volume=QUOTE(camext*EXT_VOL_CONTROLLER);
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
	volume=QUOTE(camInt*INT_VOL_CONTROLLER);
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
	volume=QUOTE(camInt*INT_VOL_CONTROLLER);
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
	volume=QUOTE(camInt*INT_VOL_CONTROLLER);
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
	volume=QUOTE(camInt*INT_VOL_CONTROLLER);
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
	volume=QUOTE(camInt*INT_VOL_CONTROLLER * CustomSoundController1);
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
	volume=QUOTE(camInt*INT_VOL_CONTROLLER * CustomSoundController2);
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
	frequency=QUOTE(NP_CONTROLLER);
	volume=QUOTE(camInt*rotorSpeed*INT_VOL_CONTROLLER * (FACTOR(NP_CONTROLLER,0.3,1)));
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
	frequency=QUOTE(NP_CONTROLLER);
	volume=QUOTE(camInt*rotorSpeed*INT_VOL_CONTROLLER * FACTOR(NP_CONTROLLER,0.3,1) * (0 max (NP_CONTROLLER-0.1)) * ((INTERPOLATE(playerPos,0,1,1,4)) max 1));
};

