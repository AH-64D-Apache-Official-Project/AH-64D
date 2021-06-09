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

//Ng variables
_heli setVariable ["fza_ah64_engStartNg",           0.23];
_heli setVariable ["fza_ah64_engIdleNg",            0.679];
_heli setVariable ["fza_ah64_engFlyNg",             0.834];


//Np variables
_heli setVariable ["fza_ah64_engStartNp",           0.15];
_heli setVariable ["fza_ah64_engIdleNp",            0.55];
_heli setVariable ["fza_ah64_engFlyNp",             1.01];
_heli setVariable ["fza_ah64_engCurPctNp",		   [0.0, 0.0]];

_heli setVariable ["fza_ah64_engPctNG",            [0.0, 0.0]];
_heli setVariable ["fza_ah64_engPctTQ",  		   [0, 0]];
_heli setVariable ["fza_ah64_engTGT",        	   [0, 0]];
_heli setVariable ["fza_ah64_engDst", 			   [false, false]];

//------------------------------------------------NG--------TGT--------TQ----
_heli setVariable ["fza_ah64_engBaseTable",		[[		0,		0,		0.00],		//Off
                                                 [	0.262,		3,		0.00],
												 [	0.318,	  244,	    0.00],
												 [	0.355,    339,		0.00],
												 [	0.407,    435,		0.01],
												 [	0.455,    513,		0.02],
												 [	0.548,    622,		0.03],
												 [	0.643,    678,		0.04],
												 [	0.670,    582,		0.05],
												 [	0.672,    485,		0.06],
												 [	0.675,    479,		0.06],
												 [	0.677,    486,		0.07],
												 [	0.679,    500,		0.07],		//Idle
												 [	0.721,    525,		0.08],
												 [	0.767,    550,		0.09],
												 [	0.814,    566,		0.10],
												 [	0.844,    564,		0.11],
												 [	0.878,    571,		0.12],
												 [	0.857,    552,		0.13],
												 [	0.842,    546,		0.14],
												 [	0.834,    541,		0.15]]];	//Fly

//------------------------------------------------GWT---IGE---OGE--
_heli setVariable ["fza_ah64_engHvrTqTable",   	[[6350, 0.54, 0.66],	//13000lbs
												 [6803, 0.59, 0.72],	//14000lbs
												 [7257, 0.64, 0.79],	//15000lbs
												 [7711, 0.69, 0.86],	//16000lbs
												 [8164, 0.73, 0.94],	//17000lbs
												 [8618, 0.80, 1.01],	//18000lbs
												 [9071, 0.86, 1.09],	//20000lbs
												 [9525, 0.92, 1.16]]];	//21000lbs