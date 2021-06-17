/* ----------------------------------------------------------------------------
Function: fza_fnc_sfmplusSetFuel

Description:


Parameters:
	_heli - The apache helicopter to get information from [Unit].

Returns:
	The mass of the forward and aft fuel cells.

Examples:
	...
	_fuelMass = [_heli] call fza_fnc_setFuel;
	_fwdFuelMass = _fuelMass select 0;
	_aftFuelMass = _fuelMass select 1;

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

_heli setVariable ["fza_ah64_engStartSwitchState", ["OFF", "OFF"]]; //OFF, START
_heli setVariable ["fza_ah64_engPowerLeverState",  ["OFF", "OFF"]]; //OFF, IDLE, FLY
_heli setVariable ["fza_ah64_engState",            ["OFF", "OFF"]]; //OFF, STARTING, ON
_heli setVariable ["fza_ah64_engClutchState",	   ["DIS", "DIS"]]; //DIS, ENG

//
_heli setVariable ["fza_ah64_isSingleEng",			false];
_heli setVariable ["fza_ah64_engTqMult",			2];
_heli setVariable ["fza_ah64_baseTQ",				0];

//Ng variables
_heli setVariable ["fza_ah64_engStartNg",           0.23];
_heli setVariable ["fza_ah64_engIdleNg",            0.679];
_heli setVariable ["fza_ah64_engFlyNg",             0.834];

//Np variables
_heli setVariable ["fza_ah64_engStartNp",           0.15];
_heli setVariable ["fza_ah64_engIdleNp",            0.55];
_heli setVariable ["fza_ah64_engFlyNp",             1.01];

//Outputs
_heli setVariable ["fza_ah64_engFF",               [0.0, 0.0]];
_heli setVariable ["fza_ah64_engBaseNG",		   [0.0, 0.0]];
_heli setVariable ["fza_ah64_engPctNG",            [0.0, 0.0]];
_heli setVariable ["fza_ah64_engBaseNP",           [0.0, 0.0]];
_heli setVariable ["fza_ah64_engPctNP",            [0.0, 0.0]];
_heli setVariable ["fza_ah64_engBaseTQ",		   [0.0, 0.0]];
_heli setVariable ["fza_ah64_engPctTQ",  		   [0.0, 0.0]];
_heli setVariable ["fza_ah64_engBaseTGT",     	   [0.0, 0.0]];
_heli setVariable ["fza_ah64_engTGT",        	   [0.0, 0.0]];
_heli setVariable ["fza_ah64_engDst", 			   [false, false]];

//------------------------------------------------NG--------TGT--------TQ-------NP---
_heli setVariable ["fza_ah64_engBaseTable",	[[	0.000,		0,		0.00,	0.00],		//Off
                                             [	0.262,		3,		0.00,	0.00],
											 [	0.318,	  244,	    0.00,	0.00],
											 [	0.355,    339,		0.00,	0.00],
											 [	0.407,    435,		0.00,	0.00],
											 [	0.455,    513,		0.00,	0.00],
											 [	0.548,    622,		0.00,	0.01],
											 [	0.643,    678,		0.00,	0.02],
											 [	0.670,    582,		0.00,	0.03],
											 [	0.672,    485,		0.00,	0.12],
											 [	0.675,    479,		0.00,	0.20],
											 [	0.677,    486,		0.03,	0.37],
											 [	0.679,    500,		0.07,	0.55],		//Idle
											 [	0.698,    525,		0.08,	0.59],
											 [	0.718,    550,		0.09,	0.63],
											 [	0.737,    566,		0.10,	0.67],
											 [	0.757,    564,		0.11,	0.71],
											 [	0.776,    571,		0.12,	0.78],
											 [	0.795,    552,		0.13,	0.82],
											 [	0.815,    546,		0.14,	0.95],
											 [	0.834,    541,		0.15,	1.01]]];	//Fly

//------------------------------------------------GWT---IGE---OGE--
_heli setVariable ["fza_ah64_hvrTqTable",   [[6350, 0.54, 0.66],	//13000lbs
											 [6803, 0.59, 0.72],	//14000lbs
											 [7257, 0.64, 0.79],	//15000lbs
											 [7711, 0.69, 0.86],	//16000lbs
											 [8164, 0.73, 0.94],	//17000lbs
											 [8618, 0.80, 1.01],	//18000lbs
											 [9071, 0.86, 1.09],	//20000lbs
											 [9525, 0.92, 1.16]]];	//21000lbs

//------------------------------------------------GWT---24kt--40kt--60kt--70kt--90kt--100kt-120kt-130kt-150kt
_heli setVariable ["fza_ah64_cruiseTable",	[[5897, 0.48, 0.39, 0.34, 0.34, 0.40, 0.44, 0.62, 0.72, 1.03],
											 [6804, 0.58, 0.47, 0.40, 0.40, 0.43, 0.48, 0.65, 0.77, 1.08],
											 [7711, 0.70, 0.56, 0.47, 0.46, 0.48, 0.53, 0.69, 0.82, 1.14],
											 [8618, 0.83, 0.67, 0.54, 0.53, 0.55, 0.60, 0.75, 0.88, 1.21],
											 [9525, 0.96, 0.78, 0.64, 0.61, 0.63, 0.68, 0.84, 1.00, 1.34]]];