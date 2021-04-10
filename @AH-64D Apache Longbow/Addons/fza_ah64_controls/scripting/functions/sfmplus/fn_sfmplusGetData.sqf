/* ----------------------------------------------------------------------------
Function: fza_fnc_sfmplusGetData

Description:
	This function contains tables generated using 0ft PA and 15C (standard day)
	conditions for hover and max torque available. Cruise data was derived from
	the 2000ft PA and 20C chart. ARMA uses 70% throttle travel as the hover and 
	level flight in cruise point in the SFM. The idea behind this function is 
	to display the real values by using table interpolation. This is meant to
	be real time and dynamic, as the aircraft gross weight (GWT) changes, so to
	will the required torque.

Parameters:
	_heli - The apache helicopter to get information from [Unit].

Returns:

Examples:

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

private _collOut = fza_ah64_collectiveOutput;

private _curGWT_kg = getMass _heli;

//-----------------------GWT---IGE---OGE
private _hvrTQTable = [	[6350, 0.54, 0.66],	//13000lbs
						[6803, 0.59, 0.72],	//14000lbs
						[7257, 0.64, 0.79],	//15000lbs
						[7711, 0.69, 0.86],	//16000lbs
						[8164, 0.73, 0.94],	//17000lbs
						[8618, 0.80, 1.01],	//18000lbs
						[9071, 0.86, 1.09],	//20000lbs
						[9525, 0.92, 1.16]];//21000lbs

private _intHvrTQTable = [_hvrTQTable, _curGWT_kg] call fza_fnc_linearInterp;
private _hvrIGE    = _intHvrTQTable select 1;
private _hvrOGE    = _intHvrTQTable select 2;
private _gndEffMod = _hvrOGE / _hvrIGE;
//--------------------TQ%----TGT(C)
private _TGTTable  = [[0.15,  540],
                      [1.00,  810],
					  [1.29,  867]];				 
//-----------------------Coll---TQ(N)
private _engTQTable = [[0,     0.15   ],
				       [0.7,   _hvrIGE],
					   [1.0, 	1.29  ]];

//----------------AGL(m)----TQ Mod
_gndEffTable = [[1.52, 	1.0],
				[15.24,	_gndEffMod]];

private _heightAGL = getPos _heli select 2;
private _gndEffVal = [_gndEffTable, _heightAGL] call fza_fnc_linearInterp select 1;

private _hvrTQVal = [_engTQTable, _collOut] call fza_fnc_linearInterp select 1;
private _V_mps    = abs vectorMagnitude [velocity _heli select 0, velocity _heli select 1];
private _ETLMod   = linearConversion[0, 12.3467, _V_mps, 1.0, 0.0, true];

//13000lbs
private _cruiseTable6350 = [[ 0.00, 0.54],
							[10.29, 0.59],
							[20.58, 0.39],
							[30.87, 0.34],
							[36.01, 0.34],
							[46.30, 0.40],
							[56.59, 0.52],
							[61.73, 0.61],
							[72.02, 0.87],
							[75.62, 1.00]];
//17000lbs
private _cruiseTable8164 = [[ 0.00, 0.73],
							[10.29, 0.71],
							[20.58, 0.57],
							[30.87, 0.46],
							[36.01, 0.46],
							[46.30, 0.48],
							[56.59, 0.60],
							[61.73, 0.82],
							[72.02, 0.97],
							[73.05, 1.00]];
//21000lbs
private _cruiseTable9525 = [[ 0.00, 0.92],
							[15.43, 1.00],
							[20.58, 0.78],
							[30.87, 0.63],
							[36.01, 0.61],
							[46.30, 0.63],
							[56.59, 0.74],
							[61.73, 0.84],
							[66.88, 1.00],
							[66.88, 1.00]];

private _int6350 = [_cruiseTable6350, _V_mps] call fza_fnc_linearInterp;
private _int8164 = [_cruiseTable8164, _V_mps] call fza_fnc_linearInterp;
private _int9525 = [_cruiseTable9525, _V_mps] call fza_fnc_linearInterp;

private _cruiseTable = [[6350, _int6350 select 1],
 						[8164, _int8164 select 1],
 						[9525, _int9525 select 1]];

private _cruiseTQVal = [_cruiseTable, _curGWT_kg] call fza_fnc_linearInterp select 1;
private _velMod = _cruiseTQVal / _hvrIGE;

private _finalTQ = (_hvrTQVal * (1 + ((_gndEffVal - 1) * _ETLMod)));
_finalTQ = _finalTQ * _velMod;
//-------------------------TQ----FF (kg/s)
private _fuelFlowTable = [[0.00, 0.0000],
				 		  [0.15, 0.0699],
				  	      [0.44, 0.1008],
				          [0.65, 0.1260],
				          [0.83, 0.1512],
				          [1.00, 0.1732]];

private _finalTGT = [_TGTTable, _finalTQ] call fza_fnc_linearInterp select 1;
private _finalFF  = [_fuelFlowTable, _finalTQ] call fza_fnc_linearInterp select 1;

[_finalTQ, _finalTGT, _finalFF];