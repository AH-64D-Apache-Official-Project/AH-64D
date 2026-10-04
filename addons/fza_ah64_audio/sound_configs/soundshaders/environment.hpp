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
	volume="engineOn*camPos";
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
	volume="camPos*((scrubTree) factor [0, 0.01])*(CustomSoundController14+1)";
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
	frequency="0.66 + rotorspeed / 3";
	volume="(transmissiondamage factor [0.3, 0.35])*(transmissiondamage factor [0.5, 0.45])*(rotorspeed factor [0.2, 0.5])*(CustomSoundController14+1)";
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
	volume="(transmissiondamage factor [0.45, 0.5])*(rotorspeed factor [0.2, 0.5])*(CustomSoundController14+1)";
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
	volume="camPos*(rain - rotorSpeed/2)*2*(CustomSoundController14+1)";
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
	frequency="rotorSpeed";
	volume="camPos*(0 max (rotorSpeed-0.1)*6)*(CustomSoundController14+1) * (0.25 max CustomSoundController15)";
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
	frequency="rotorSpeed";
	volume="(CustomSoundController14+1)*engineOn*camPos*((gmeterZ factor[1.5, 2.5]) + (gmeterZ factor[0.5, -0.5]))";
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
	volume="2*camInt*(scrubLand factor[0.02, 0.05])*(1 - (lateralMovement factor [0.7,1]))*(CustomSoundController16+1)";
};
class fza_ScrubBuilding_Int_SoundShader_Base: fza_ScrubLand_Int_SoundShader_Base
{
	volume="camInt*(scrubBuilding factor[0.02, 0.05])*(1 - (lateralMovement factor [0.7,1]))*(CustomSoundController16+1)";
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
	volume="camInt*((scrubTree) factor [0, 0.01])*(CustomSoundController16+1)";
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
	frequency="0.66 + CustomSoundController3 / 3";
	volume="camInt*rotorSpeed*CustomSoundController4*(CustomSoundController16+1)";
	range=100;
	//frequency="0.66 + rotorspeed / 3";
	//volume="camInt*(transmissiondamage factor [0.3, 0.35])*(transmissiondamage factor [0.5, 0.45])*(rotorspeed factor [0.2, 0.5])";
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
	frequency="CustomSoundController3";
	volume="camInt*rotorSpeed*CustomSoundController4*(CustomSoundController16+1)";
	range=100;
	//frequency="0.66 + rotorspeed / 3";
	//volume="camInt*(transmissiondamage factor [0.45, 0.5])*(rotorspeed factor [0.2, 0.5])";
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
	frequency="CustomSoundController3";
	volume="camInt*rotorSpeed*CustomSoundController4*(CustomSoundController16+1)";
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
	volume="camInt*(rain - rotorSpeed/2)*2*(CustomSoundController16+1)";
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
	volume="camInt*(speed factor[5, 60])*(speed factor[5, 60])*(CustomSoundController16+1) * (0.25 max CustomSoundController15)";
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
	volume="engineOn*camInt*CustomSoundController8*(-playerPos + 1)*(CustomSoundController16+1)*((rotorSpeed factor [0.3, 0.5])+((lateralMovement*((speed factor [5,40])+(speed factor [-5,-40])) max 0) min 1.5)) * (0.25 max CustomSoundController15)";
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
	volume="engineOn*camInt*(gmeterZ factor[1.0, 2.5])*(CustomSoundController16+1)";
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
	frequency="rotorSpeed*2";
	volume="engineOn*camInt*((gmeterZ factor[1.5, 2.5]) + (gmeterZ factor[0.5, -0.5]))*(CustomSoundController16+1)";
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
	volume="camInt*(speed factor[40,80])*(CustomSoundController16+1)";
};
class fza_ETL_VRS_Shake_01_SoundShader_Base: fza_Wind_Int_SoundShader_Base
{
	sound[]   = {"\fza_ah64_us\audio\CreakingAirFrame.ogg", 1, 1};
	frequency = "CustomSoundController3";
	volume    = "camInt*rotorSpeed*CustomSoundController4";
};
class fza_ETL_VRS_Shake_02_SoundShader_Base: fza_Wind_Int_SoundShader_Base
{
	sound[]   = {"A3\Sounds_F\vehicles\noises\vehicle_stress3.wss", 1, 1};
	frequency = "CustomSoundController3";
	volume    = "camInt*rotorSpeed*CustomSoundController4";
};
