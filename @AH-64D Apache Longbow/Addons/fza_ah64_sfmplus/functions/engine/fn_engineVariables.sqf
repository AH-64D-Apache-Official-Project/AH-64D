/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_engineVariables

Description:
	Defines core engine variables.

Parameters:
	_heli - The helicopter to get information from [Unit].

Returns:
	...

Examples:
	...

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

_heli setVariable ["fza_sfmplus_engStartSwitchState", 	["OFF", "OFF"]]; //OFF, START
_heli setVariable ["fza_sfmplus_engPowerLeverState",  	["OFF", "OFF"]]; //OFF, IDLE, FLY
_heli setVariable ["fza_sfmplus_engState",            	["OFF", "OFF"]]; //OFF, STARTING, ON
_heli setVariable ["fza_sfmplus_engClutchState",	  	["DIS", "DIS"]]; //DIS, ENG

_heli setVariable ["fza_sfmplus_isSingleEng",			false];
_heli setVariable ["fza_sfmplus_engTqMult",				2];
_heli setVariable ["fza_sfmplus_baseTQ",				0];

//Ng variables
_heli setVariable ["fza_sfmplus_engStartNg",           	0.23];
_heli setVariable ["fza_sfmplus_engIdleNg",           	0.679];
_heli setVariable ["fza_sfmplus_engFlyNg",             	0.834];

//Np variables
_heli setVariable ["fza_sfmplus_engStartNp",           	0.15];
_heli setVariable ["fza_sfmplus_engIdleNp",            	0.55];
_heli setVariable ["fza_sfmplus_engFlyNp",             	1.01];

//Outputs
_heli setVariable ["fza_sfmplus_engFF",               	[0.0, 0.0]];
_heli setVariable ["fza_sfmplus_engBaseNG",		   		[0.0, 0.0]];
_heli setVariable ["fza_sfmplus_engPctNG",            	[0.0, 0.0]];
_heli setVariable ["fza_sfmplus_engBaseNP",           	[0.0, 0.0]];
_heli setVariable ["fza_sfmplus_engPctNP",            	[0.0, 0.0]];
_heli setVariable ["fza_sfmplus_engBaseTQ",		   		[0.0, 0.0]];
_heli setVariable ["fza_sfmplus_engPctTQ",  		   	[0.0, 0.0]];
_heli setVariable ["fza_sfmplus_engBaseTGT",     	   	[0.0, 0.0]];
_heli setVariable ["fza_sfmplus_engTGT",        	   	[0.0, 0.0]];
_heli setVariable ["fza_sfmplus_engBaseOilPSI",	  		[0.0, 0.0]];
_heli setVariable ["fza_sfmplus_engOilPSI",		   		[0.0, 0.0]];
_heli setVariable ["fza_sfmplus_engDest", 			   	[false, false]];

//------------------------------------------------0-NG-----1-TGT----2-TQ----3-NP----4-Oil
_heli setVariable ["fza_sfmplus_engBaseTable",	[[0.000,	  0,	0.00,	0.00,	0.00],		//Off
                                             	 [0.262,      3,	0.01,	0.00,	0.01],	
											 	 [0.318,    244,	0.015,	0.00,	0.11],
											 	 [0.355,    339,	0.02,	0.00,	0.19],
											 	 [0.407,    435,	0.025,	0.00,	0.25],
											 	 [0.455,    513,	0.03,	0.00,	0.29],
											 	 [0.548,    622,	0.035,	0.01,	0.38],
											 	 [0.643,    678,	0.04,	0.02,	0.41],
											 	 [0.670,    582,	0.045,	0.03,	0.48],
											 	 [0.672,    565,	0.05,	0.12,	0.51],
											 	 [0.675,    530,	0.055,	0.20,	0.58],
											 	 [0.677,    505,	0.06,	0.37,	0.62],
											 	 [0.679,    500,	0.07,	0.55,	0.70],		//Idle
											 	 [0.698,    525,	0.08,	0.59,	0.71],
											 	 [0.718,    550,	0.09,	0.63,	0.73],
											 	 [0.737,    566,	0.10,	0.67,	0.77],
											 	 [0.757,    564,	0.11,	0.71,	0.81],
											 	 [0.776,    571,	0.12,	0.78,	0.82],
											 	 [0.795,    552,	0.13,	0.82,	0.84],
											 	 [0.815,    546,	0.14,	0.95,	0.86],
											 	 [0.834,    541,	0.15,	1.01,	0.88]]];	//Fly

//-----------------------------------------------GWT---IGE---OGE--
_heli setVariable ["fza_sfmplus_hvrTqTable",   	[[6350, 0.54, 0.66],	//13000lbs
											 	 [6803, 0.59, 0.72],	//14000lbs
											 	 [7257, 0.64, 0.79],	//15000lbs
											 	 [7711, 0.69, 0.86],	//16000lbs
											 	 [8164, 0.73, 0.94],	//17000lbs
											 	 [8618, 0.80, 1.01],	//18000lbs
											 	 [9071, 0.86, 1.09],	//20000lbs
											 	 [9525, 0.92, 1.16]]];	//21000lbs

//------------------------------------------------GWT---24kt--40kt--60kt--70kt--90kt--100kt-120kt-130kt-150kt
_heli setVariable ["fza_sfmplus_cruiseTable",	[[5897, 0.48, 0.39, 0.34, 0.34, 0.40, 0.44, 0.62, 0.72, 1.03],
											 	 [6804, 0.58, 0.47, 0.40, 0.40, 0.43, 0.48, 0.65, 0.77, 1.08],
											 	 [7711, 0.70, 0.56, 0.47, 0.46, 0.48, 0.53, 0.69, 0.82, 1.14],
											 	 [8618, 0.83, 0.67, 0.54, 0.53, 0.55, 0.60, 0.75, 0.88, 1.21],
											 	 [9525, 0.96, 0.78, 0.64, 0.61, 0.63, 0.68, 0.84, 1.00, 1.34]]];