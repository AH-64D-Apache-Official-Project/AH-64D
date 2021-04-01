/* ----------------------------------------------------------------------------
Function: fza_fnc_engineGetData

Description:

Parameters:
	_heli - The apache helicopter to get information from [Unit].

Returns:

Examples:

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_TQ"];

//-------------------------TQ----FF (kg/s)
private _fuelFlowTable = [[0.00, 0.0000],
				 		  [0.15, 0.0699],
				  	      [0.44, 0.1008],
				          [0.65, 0.1260],
				          [0.83, 0.1512],
				          [1.00, 0.1732]];

[_fuelFlowTable, _TQ] call fza_fnc_linearInterp select 1;


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