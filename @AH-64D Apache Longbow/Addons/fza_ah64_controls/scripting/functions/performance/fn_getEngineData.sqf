/* ----------------------------------------------------------------------------
Function: fza_fnc_getEngineData

Description:

Parameters:
	_heli - The apache helicopter to get information from [Unit].

Returns:

Examples:

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

private _curGWT_kg = getMass _heli;

//--------------GWT---IGE---OGE
_hvrTQTable = [[6350, 0.54, 0.66],	//13000lbs
			   [6803, 0.59, 0.72],	//14000lbs
			   [7257, 0.64, 0.79],	//15000lbs
			   [7711, 0.69, 0.86],	//16000lbs
			   [8164, 0.73, 0.94],	//17000lbs
			   [8618, 0.80, 1.01],	//18000lbs
			   [9071, 0.86, 1.09],	//20000lbs
			   [9525, 0.92, 1.16]];	//21000lbs

private _intHvrTQTable = [_hvrTQTable, _curGWT_kg] call fza_fnc_linearInterp;
private _hvrIGE = _intHvrTQTable select 1;
private _hvrOGE = _intHvrTQTable select 2;

//---------------Coll---TQ(N)------TGT(C)
_engTQTable = [	[0,     0.15   ,   450],
				[0.7,   _hvrIGE,   658],
				[1.0, 	1.29   ,   867]];
				
private _gndEffMod = _hvrOGE / _hvrIGE;

//----------------AGL(m)----TQ Mod
_gndEffTable = [ [1.52, 	1.0],
				 [15.24,	_gndEffMod]];

//This encounters problems when over water...
private _heightAGL = getPosATL _heli select 2;
private _gndEffVal = [_gndEffTable, _heightAGL] call fza_fnc_linearInterp select 1;

//First we need to get the analog collective input, both of these are positive values: low is 1 to 0, and high is 0 to 1
_collLow  = inputAction "HeliCollectiveLowerCont";
_collHigh = inputAction "HeliCollectiveRaiseCont";
//If we take high - low, we get an output from -1 to 1 
_collVal = _collHigh - _collLow;
//Now that convert the -1 to 1 to a 0 to 1 output
_collOut = linearConversion [-1, 1, _collVal, 0, 1];

private _intEngTQTable = [_engTQTable, _collOut] call fza_fnc_linearInterp;
private _hvrTQVal = _intEngTQTable select 1;
private _TGT      = _intEngTQTable select 2;
private _finalTQ = _hvrTQVal * _gndEffVal;

hintSilent format ["Gnd Effect Mod = %1
					\nGnd Effect Val = %2
					\nAGL = %3
					\nHvr Tq Val = %4
					\nFin Tq Val = %5
					\nTQT = %6", _gndEffMod, _gndEffVal, _heightAGL, _hvrTQVal, _finalTq, _TGT];

[_finalTQ, _TGT];

/***

[] spawn 
{
	runLoop = true;
	while {runLoop} do 
	{
		_hvrTQTable = [[6350, 0.54, 0.66],
					[6803, 0.59, 0.72],
					[7257, 0.64, 0.79],
					[7711, 0.69, 0.86],
					[8164, 0.73, 0.94],
					[8618, 0.80, 1.01],
					[9071, 0.86, 1.09],
					[9525, 0.92, 1.16]];


		_gwt_kg = 8322;

			

		_hvrTQ = [_hvrTQTable, _gwt_kg] call fza_fnc_linearInterp select 1;
		
		hintSilent format ["Hover TQ = %1", _hvrTQ];
		sleep 0.03;
	}
};






[] spawn 
{
	runLoop = true;
	while {runLoop} do 
	{
		_collLow  = inputAction "HeliCollectiveLowerCont";
		_collHigh = inputAction "HeliCollectiveRaiseCont";
		_collVal = _collHigh - _collLow;
		
		_collOut = linearConversion [-1, 1, _collVal, 0, 1];
		
		_tqOut = linearConversion[0, 1, _collOut, 70, 630];
		
		hintSilent format ["Lower %1\nUpper %2\nColl Out %3\nTq Out %4", inputAction "HeliCollectiveLowerCont", inputAction "HeliCollectiveRaiseCont", _collOut, _tqOut];
		sleep 0.03;
	}
};


[] spawn 
{
	runLoop = true;
	while {runLoop} do 
	{
		_collLow  = inputAction "HeliCollectiveLowerCont";
		_collHigh = inputAction "HeliCollectiveRaiseCont";

		_collVal = _collHigh - _collLow;

		_collOut = linearConversion [-1, 1, _collVal, 0, 1];

		_engTQTable = [	  [	0, 			72],
						[	0.7, 		390],
						[	1.0, 		620]];

		_gndEffTable = [  [	1.52, 		1.0],
							15.24, 		1.27]];

		_curTQ = [_engTQTable, _collOut] call fza_fnc_linearInterp;
		_tqOut = (_engTQTable select 0, select 1) + _curTQ;
		
		hintSilent format ["Lower %1\nUpper %2\nColl Out %3\nTq Out %4", inputAction "HeliCollectiveLowerCont", inputAction "HeliCollectiveRaiseCont", _collOut, _tqOut];
		sleep 0.03;
	}
};

***/