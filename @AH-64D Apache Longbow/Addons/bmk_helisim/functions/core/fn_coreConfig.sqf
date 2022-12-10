params ["_heli"];

private _hingeOffset                = 0.0; 

//---MOVE TO CONFIG
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

private _tailRotor_numBlades        = 4;
private _tailRotor_bladeRadius      = 1.402; //m
private _tailRotor_bladeChord       = 0.253; //m
private _tailRotor_bladeTwist       = 0.0;   //deg
private _tailRotor_bladeMass        = 17.7;  //kg
private _tailRotor_hingeOffsetRatio = 0.0;
private _tailRotor_tipLoss          = 0.97;
private _tailRotor_gearRatio        = 14.90;

_heli setVariable ["bmk_helisim_a",                    _liftCurveSlope];
//--Main Rotor
_heli setVariable ["bmk_helisim_mainRotor_b",          _mainRotor_numBlades];
_heli setVariable ["bmk_helisim_mainRotor_R",          _mainRotor_bladeRadius];
_heli setVariable ["bmk_helisim_mainRotor_c",          _mainRotor_bladeChord];
_heli setVariable ["bmk_helisim_mainRotor_theta1_deg", _mainRotor_bladeTwist];
_heli setVariable ["bmk_helisim_mainRotor_m",          _mainRotor_bladeMass];
_heli setVariable ["bmk_helisim_mainRotor_eR",         _mainRotor_hingeOffsetRatio];
_heli setVariable ["bmk_helisim_mainRotor_e",          _mainRotor_bladeRadius * _mainRotor_hingeOffsetRatio];

private _mainRotor_solidity = (_mainRotor_numBlades * _mainRotor_bladeChord) / (pi * _mainRotor_bladeRadius);
_heli setVariable ["bmk_helisim_mainRotor_s",          _mainRotor_solidity];

private _mainRotor_Ib = (1.0 / 3.0) * _mainRotor_bladeMass * (_mainRotor_bladeRadius * _mainRotor_bladeRadius);
_hingeOffset          = 1.0 - _mainRotor_hingeOffsetRatio;
_mainRotor_Ib         = _mainRotor_Ib * (_hingeOffset * _hingeOffset * _hingeOffset);
_heli setVariable ["bmk_helisim_mainRotor_Ib",         _mainRotor_Ib];
_heli setVariable ["bmk_helisim_mainRotor_gearRatio",  _mainRotor_gearRatio];

private _mainRotor_polarMomentOfInertia = _mainRotor_numBlades * _mainRotor_bladeMass * ((_mainRotor_bladeRadius * 0.55) * (_mainRotor_bladeRadius * 0.55));
_heli setVariable ["bmk_helisim_mainRotor_polarMomentOfInertia",    _mainRotor_polarMomentOfInertia];

//--Tail Rotor
_heli setVariable ["bmk_helisim_tailRotor_b",          _tailRotor_numBlades];
_heli setVariable ["bmk_helisim_tailRotor_R",          _tailRotor_bladeRadius];
_heli setVariable ["bmk_helisim_tailRotor_c",          _tailRotor_bladeChord];
_heli setVariable ["bmk_helisim_tailRotor_theta1_deg", _tailRotor_bladeTwist];
_heli setVariable ["bmk_helisim_tailRotor_m",          _tailRotor_bladeMass];
_heli setVariable ["bmk_helisim_tailRotor_eR",         _tailRotor_hingeOffsetRatio];
_heli setVariable ["bmk_helisim_tailRotor_e",          _tailRotor_bladeRadius * _tailRotor_hingeOffsetRatio];

private _tailRotor_solidity = (_tailRotor_numBlades * _tailRotor_bladeChord) / (pi * _tailRotor_bladeRadius);
_heli setVariable ["bmk_helisim_tailRotor_s",          _tailRotor_solidity];

private _tailRotor_Ib = (1.0 / 3.0) * _tailRotor_bladeMass * (_tailRotor_bladeRadius * _tailRotor_bladeRadius);
_hingeOffset          = 1.0 - _tailRotor_hingeOffsetRatio;
_tailRotor_Ib         = _tailRotor_Ib * (_hingeOffset * _hingeOffset * _hingeOffset);
_heli setVariable ["bmk_helisim_tailRotor_Ib",         _tailRotor_Ib];
_heli setVariable ["bmk_helisim_tailRotor_gearRatio",  _tailRotor_gearRatio];

//--Engines
private _engine1 = [_heli, 1066, 21109, 0.57, 1.01, 0.09, 0.18] call bmk_helisim_fnc_engineInit;
_heli setVariable ["bmk_helisim_engine1", _engine1];

private _engine2 = [_heli, 1066, 21109, 0.57, 1.01, 0.09, 0.18] call bmk_helisim_fnc_engineInit;
_heli setVariable ["bmk_helisim_engine2", _engine2];

[_heli] call bmk_helisim_fnc_rotorVariables;
[_heli] call bmk_helisim_fnc_engineVariables;
[_heli] call bmk_helisim_fnc_xmsnVariables;