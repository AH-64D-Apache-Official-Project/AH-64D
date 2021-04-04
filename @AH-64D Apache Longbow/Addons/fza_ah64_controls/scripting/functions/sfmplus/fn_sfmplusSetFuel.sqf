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

private _percentFuel    = _heli getVariable "fza_ah64d_percentFuel";
private _maxFwdFuelMass = _heli getVariable "fza_ah64d_maxFwdFuelMass";
private _maxAftFuelMass = _heli getVariable "fza_ah64d_maxAftFuelMass";

//Sum all the fuel together for balancing purposes
private _totFuelMass = (_maxFwdFuelMass * _percentFuel) + (_maxAftFuelMass * _percentFuel);

//Set the amount of fuel int he forward fuel scell accordinly and declare a variable
//to track any fuel that exceeds the maximum of the fuel cell
private _fwdFuelMass = (_totFuelMass / 2) * _percentFuel;
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
private _aftFuelMass = ((_totFuelMass / 2) * _percentFuel) + _fwdFuelRmng;

[_fwdFuelMass, _aftFuelMass];