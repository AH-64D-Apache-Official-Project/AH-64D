/* ----------------------------------------------------------------------------
Function: fza_fnc_setGWT

Description:


Parameters:
	_heli - The apache helicopter to get information from [Unit].

Returns:


Examples:


Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

_heli setVariable ["fza_ah64d_emptyMassFCR",    6609]; //kg
_heli setVariable ["fza_ah64d_emptyMassNonFCR", 6314]; //kg

_heli setVariable ["fza_ah64d_percentFuel", 1.0]; //% fuel
_heli setVariable ["fza_ah64d_maxFwdFuelMass", 473]; //1043lbs in kg
//_heli setVariable ["fza_ah64d_maxCtrFuelMass", 300]; //663lbs in kg, net yet implemented, center robbie
_heli setVariable ["fza_ah64d_maxAftFuelMass", 669]; //1474lbs in kg

/***
[] spawn 
{
	runLoop = true;
	while {runLoop} do 
	{
		private _heli = vehicle player;
		private _pylonMass = 0;

		private _magazineMass = 0;
	{
		private _magazineClass = (configFile >> "CfgMagazines" >> _x);
		private _ammoClass     = (configFile >> "CfgAmmo" >> getText (_magazineClass >> "ammo"));
		
		private _massFull  = getNumber (_magazineClass >> "mass");
		private _countNow  = _heli ammoOnPylon (_forEachIndex + 1);
		private _countFull = 1 max getNumber (_magazineClass >> "count");
		private _magazineMass = _massFull * _countNow / _countFull;
		_pylonMass = _pylonMass + _magazineMass;
	} foreach (getPylonMagazines _heli);
		
		private _pylon1 = _heli ammoOnPylon 1;
		private _pylon2 = _heli ammoOnPylon "pylons2";
		private _pylon3 = _heli ammoOnPylon "pylons3";

		private _test = 0;

		for "_i" from 0 to 28 do { 
			_pylons = (configFile >> "pylons" >> _x);
			_ammoCount = _heli ammoOnPylon _i;

			_test = _test + _ammoCount;
		} foreach (getPylon);

		hintSilent format ["Pylon mass = %1
							\nMagazine Mass = %2
							\nAmmo on Pylon 1 = %3", _pylonMass, _magazineMass, _test];
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