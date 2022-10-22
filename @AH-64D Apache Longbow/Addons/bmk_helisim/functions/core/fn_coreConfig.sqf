params ["_heli"];

private _flightModel = configFile >> "CfgVehicles" >> typeof _heli >> "FlightModel";
//if ((getText _flightModel) != "HeliSim") exitWith {};

private _liftCurveSlope             = 5.7;

private _mainRotor_numBlades        = 4;
private _mainRotor_bladeRadius      = 7.315; //m
private _mainRotor_bladeChord       = 0.533; //m
private _mainRotor_bladeTwist       = 0.0;   //deg
private _mainRotor_bladeMass        = 71.2;  //kg
private _mainRotor_hingeOffsetRatio = 0.137;
private _mainRotor_tipLoss          = 0.97;

private _mainRotor_gearRatio        = 72.29;

_heli setVariable ["bmk_helisim_a",                    _liftCurveSlope];
//--Main Rotor
_heli setVariable ["bmk_helisim_mainRotor_b",          _mainRotor_numBlades];
_heli setVariable ["bmk_helisim_mainRotor_R",          _mainRotor_bladeRadius];
_heli setVariable ["bmk_helisim_mainRotor_c",          _mainRotor_bladeChord];
_heli setVariable ["bmk_helisim_mainRotor_theta1_deg", _mainRotor_bladeTwist];
_heli setVariable ["bmk_helisim_mainRotor_m",          _mainRotor_bladeMass];
_heli setVariable ["bmk_helisim_mainRotor_eR",         _mainRotor_hingeOffsetRatio];
_heli setVariable ["bmk_helisim_mainRotor_e",          _mainRotor_bladeRadius * _mainRotor_hingeOffsetRatio];

//--Other variables
private _mainRotor_solidity = (_mainRotor_numBlades * _mainRotor_bladeChord) / (pi * _mainRotor_bladeRadius);
_heli setVariable ["bmk_helisim_mainRotor_s",          _mainRotor_solidity];

private _mainRotor_Ib = (1.0 / 3.0) * _mainRotor_bladeMass * (_mainRotor_bladeRadius * _mainRotor_bladeRadius);
private _hingeOffset  = 1.0 - _mainRotor_hingeOffsetRatio;
_mainRotor_Ib         = _mainRotor_Ib * (_hingeOffset * _hingeOffset * _hingeOffset);
_heli setVariable ["bmk_helisim_mainRotor_Ib", _mainRotor_Ib];
_heli setVariable ["bmk_helisim_mainRotor_gearRatio",  _mainRotor_gearRatio];

[_heli] call bmk_helisim_fnc_rotorVariables;