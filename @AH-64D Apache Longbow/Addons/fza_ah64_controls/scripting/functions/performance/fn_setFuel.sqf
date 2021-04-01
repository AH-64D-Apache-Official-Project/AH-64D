/* ----------------------------------------------------------------------------
Function: fza_fnc_setGWT

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

//----------------------------------------Fuel----------------------------------------//
private _fuelFrac       = _heli getVariable "fza_ah64d_percentFuel";
private _maxFwdFuelMass = _heli getVariable "fza_ah64d_maxFwdFuelMass";
private _maxAftFuelMass = _heli getVariable "fza_ah64d_maxAftFuelMass";

//Sum all the fuel together for balancing purposes
private _totFuelMass = (_maxFwdFuelMass * _fuelFrac) + (_maxAftFuelMass * _fuelFrac);

//Set the amount of fuel int he forward fuel scell accordinly and declare a variable
//to track any fuel that exceeds the maximum of the fuel cell
private _fwdFuelMass = (_totFuelMass / 2) * _fuelFrac;
private _fwdFuelRmng  = 0;	
//Check to see if the current fwd fuel cell capacity has been exceeded, and if it has,
//first subtract the maximum and hold it in the remainder and then set the fwd fuel
//cell fuel equal to the max.
if (_fwdFuelMass > _maxFwdFuelMass) then {
	_fwdFuelRmng = _fwdFuelMass - _maxFwdFuelMass;
	_fwdFuelMass = _maxFwdFuelMass;
};
//Calculate the amount of fuel in the aft fuel cell and add any remaining fuel from
//the forward fuel cell.
private _aftFuelMass = ((_totFuelMass / 2) * _fuelFrac) + _fwdFuelRmng;

[_fwdFuelMass, _aftFuelMass];

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