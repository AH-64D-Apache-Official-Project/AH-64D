//External

// -Empty
class fza_Empty_SoundShader
{
	samples[]=
	{

		{
			"a3\sounds_f\dummysound.wss",
			1
		}
	};
	frequency=1;
	volume=QUOTE(engineOn*camext);
	range=3000;
	rangeCurve[]=
	{
		{0,1},
		{3000,1}
	};
};

// -Scrub Sound
class fza_ScrubTree_Ext_SoundShader_Base
{
	samples[]=
	{

		{
			"A3\Sounds_F\vehicles\air\noises\scrubTreeExt.wss",
			1
		}
	};
	frequency=1;
	volume=QUOTE(camext*EXT_VOL_CONTROLLER * FACTOR(scrubTree,0,0.01));
	range=20;
};

// -Damage
class fza_TransmissionDamage_Ext_phase1_SoundShader_Base
{
	samples[]=
	{

		{
			"a3\sounds_f\vehicles\air\noises\heli_damage_transmission_ext_1.wss",
			1
		}
	};
	frequency=QUOTE(0.66 + NP_CONTROLLER / 3);
	volume=QUOTE(camext*EXT_VOL_CONTROLLER*(FACTOR(transmissiondamage,0.3,0.35))*(FACTOR(transmissiondamage,0.5,0.45))*(FACTOR(NP_CONTROLLER,0.2,0.5)));
	range=100;
};
class fza_TransmissionDamage_Ext_phase2_SoundShader_Base: fza_TransmissionDamage_Ext_phase1_SoundShader_Base
{
	samples[]=
	{

		{
			"a3\sounds_f\vehicles\air\noises\heli_damage_transmission_ext_2.wss",
			1
		}
	};
	volume=QUOTE(camext*EXT_VOL_CONTROLLER*(FACTOR(transmissiondamage,0.45,0.5))*(FACTOR(NP_CONTROLLER,0.2,0.5)));
};

//-Noise
class fza_Rain_Ext_SoundShader_Base
{
	samples[]=
	{

		{
			"A3\Sounds_F\vehicles\noises\rain1_ext.wss",
			1
		}
	};
	range=100;
	frequency=1;
	volume=QUOTE(camext*EXT_VOL_CONTROLLER * (rain - (1 min NP_CONTROLLER)/2)*2);
	rangecurve[]=
	{
		{0,1},
		{50,0.3},
		{100,0}
	};
};
class fza_Wind_Close_Ext_SoundShader_Base
{
	samples[]=
	{

		{
			"\fza_ah64_audio\audio\Engine\Env\Share\Wind_Ext.ogg",
			1
		}
	};
	frequency=QUOTE(NP_CONTROLLER);
	volume=QUOTE(camext*rotorSpeed*EXT_VOL_CONTROLLER * (0 max (NP_CONTROLLER-0.1)*6) * (0.25 max NP_CONTROLLER));
	range=20;
	rangecurve[]=
	{
		{0,1},
		{20,0}
	};
};
class fza_Rotor_Stress_Ext_SoundShader_Base
{
	samples[]=
	{

		{
			"\fza_ah64_audio\audio\Engine\Env\Share\BladeSlap_ext.wss",
			1
		}
	};
	range=1200;
	frequency=QUOTE(NP_CONTROLLER);
	volume=QUOTE(camext*rotorSpeed*EXT_VOL_CONTROLLER * (FACTOR(gmeterZ,1.5,2.5) + FACTOR(gmeterZ,0.5,-0.5)));
	rangecurve[]=
	{
		{0,1},
		{300,0.8},
		{1200,0}
	};
};

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Internal

// -Scrub Sound
class fza_ScrubLand_Int_SoundShader_Base
{
	samples[]=
	{

		{
			"A3\Sounds_F\vehicles\air\noises\wheelsInt.wss",
			1
		}
	};
	frequency=1;
	volume=QUOTE(2*camInt*INT_VOL_CONTROLLER * FACTOR(scrubLand,0.02,0.05) * (1 - FACTOR(lateralMovement,0.7,1)));
};
class fza_ScrubBuilding_Int_SoundShader_Base: fza_ScrubLand_Int_SoundShader_Base
{
	volume=QUOTE(camInt*INT_VOL_CONTROLLER * FACTOR(scrubBuilding,0.02,0.05) * (1 - FACTOR(lateralMovement,0.7,1)));
};
class fza_ScrubTree_Int_SoundShader_Base: fza_ScrubLand_Int_SoundShader_Base
{
	samples[]=
	{

		{
			"A3\Sounds_F\vehicles\air\noises\scrubTreeInt.wss",
			1
		}
	};
	volume=QUOTE(camInt*INT_VOL_CONTROLLER * FACTOR(scrubTree,0,0.01));
};

// -Damage
class fza_TransmissionDamage_Int_phase1_SoundShader_Base
{
	samples[]=
	{

		{
			"a3\sounds_f\vehicles\air\noises\heli_damage_transmission_int_1.wss",
			1
		}
	};
	frequency=QUOTE(0.66 + CustomSoundController3 / 3);
	volume=QUOTE(camInt*INT_VOL_CONTROLLER * NP_CONTROLLER*CustomSoundController4);
	range=100;
};
class fza_TransmissionDamage_Int_phase2_SoundShader_Base
{
	samples[]=
	{

		{
			"a3\sounds_f\vehicles\air\noises\heli_damage_transmission_int_2.wss",
			1
		}
	};
	frequency=QUOTE(CustomSoundController3);
	volume=QUOTE(camInt*INT_VOL_CONTROLLER * NP_CONTROLLER*CustomSoundController4);
	range=100;
};
class fza_TransmissionDamage_Int_phase3_SoundShader_Base
{
	samples[]=
	{

		{
			"A3\Sounds_F\vehicles\noises\vehicle_stress3.wss",
			1
		}
	};
	frequency=QUOTE(CustomSoundController3);
	volume=QUOTE(camInt*INT_VOL_CONTROLLER * NP_CONTROLLER*CustomSoundController4);
	range=50;
};

//-Noise
class fza_Rain_Int_SoundShader_Base: fza_Rain_Ext_SoundShader_Base
{
	samples[]=
	{

		{
			"A3\Sounds_F\vehicles\noises\rain1_int.wss",
			1
		}
	};
	volume=QUOTE(camInt*INT_VOL_CONTROLLER * (rain - NP_CONTROLLER/2)*2);
};

class fza_Wind_Int_SoundShader_Base
{
	samples[]=
	{

		{
			"A3\Sounds_F\vehicles\air\noises\wind_closed.wss",
			1
		}
	};
	range=50;
	frequency=1;
	volume=QUOTE(camInt*INT_VOL_CONTROLLER * FACTOR(speed,5,60) * FACTOR(speed,5,60) * NP_CONTROLLER);
};
class fza_WindWash_Int_SoundShader_Base: fza_Wind_Int_SoundShader_Base
{
	samples[]=
	{

		{
			"\fza_ah64_audio\audio\Engine\Env\Share\Wind_Int.ogg",
			1
		}
	};
	volume=QUOTE(camInt*engineOn*INT_VOL_CONTROLLER * CustomSoundController8 * (-playerPos + 1) * (FACTOR(NP_CONTROLLER,0.3,0.5) + ((lateralMovement * (FACTOR(speed,5,40) + FACTOR(speed,-5,-40)) max 0) min 1.5)) * NP_CONTROLLER);
};
class fza_FrameStress_Int_SoundShader_Base: fza_Wind_Int_SoundShader_Base
{
	samples[]=
	{
		{
			"A3\Sounds_F\vehicles\noises\vehicle_stress2c.wss",
			1
		}
	};
	volume=QUOTE(camInt*engineOn*INT_VOL_CONTROLLER * FACTOR(gmeterZ,1.0,2.5));
};
class fza_GStress_Int_SoundShader_Base: fza_Wind_Int_SoundShader_Base
{
	samples[]=
	{

		{
			"\fza_ah64_audio\audio\Engine\Env\Share\BladeSlap.wss",
			1
		}
	};
	frequency=QUOTE(NP_CONTROLLER*2);
	volume=QUOTE(camInt*engineOn*INT_VOL_CONTROLLER * FACTOR(gmeterZ,1.5,2.5) + FACTOR(gmeterZ,0.5,-0.5));
};
class fza_SpeedStress_Int_SoundShader_Base: fza_Wind_Int_SoundShader_Base
{
	samples[]=
	{

		{
			"A3\Sounds_F\vehicles\noises\vehicle_stress3.wss",
			1
		}
	};
	volume=QUOTE(camInt*INT_VOL_CONTROLLER * FACTOR(speed,40,80));
};
class fza_ETL_VRS_Shake_01_SoundShader_Base: fza_Wind_Int_SoundShader_Base
{
	samples[]=
	{

		{
			"\fza_ah64_audio\audio\engine\env\share\creakingairframe.wss",
			1
		}
	};
	frequency=QUOTE(CustomSoundController3);
	volume=QUOTE(camInt*INT_VOL_CONTROLLER * NP_CONTROLLER * CustomSoundController4);
};
class fza_ETL_VRS_Shake_02_SoundShader_Base: fza_Wind_Int_SoundShader_Base
{
	samples[]=
	{

		{
			"A3\Sounds_F\vehicles\noises\vehicle_stress3.wss",
			1
		}
	};
	frequency=QUOTE(CustomSoundController3);
	volume=QUOTE(camInt*INT_VOL_CONTROLLER * NP_CONTROLLER * CustomSoundController4);
};
