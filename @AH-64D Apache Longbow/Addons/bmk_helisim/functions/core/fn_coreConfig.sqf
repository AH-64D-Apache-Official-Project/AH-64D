params ["_heli"];

private _flightModel = configFile >> "CfgVehicles" >> typeof _heli >> "FlightModel";
//if ((getText _flightModel) != "HeliSim") exitWith {};

//--Initialize variables
private _liftCurveSlope         = 5.7;
private _rotor_numBlades        = [4,     4];
private _rotor_bladeRadius      = [7.315, 1.402];   //m
private _rotor_bladeChord       = [0.533, 0.253];   //m
private _rotor_bladeTwist       = [0.0,   0.0];     //deg
private _rotor_bladeMass        = [71.2,  17.7];    //kg
private _rotor_hingeOffsetRatio = [0.137, 0.0];
private _rotor_tipLos           = [0.97,  0.97];
private _rotor_gearRatio        = [72.29, 14.90];

//---Set variables
_heli setVariable ["bmk_helisim_rotor_a",          _liftCurveSlope];
_heli setVariable ["bmk_helisim_rotor_b",          _rotor_numBlades];
_heli setVariable ["bmk_helisim_rotor_R",          _rotor_bladeRadius];
_heli setVariable ["bmk_helisim_rotor_c",          _rotor_bladeChord];
_heli setVariable ["bmk_helisim_rotor_theta1_deg", _rotor_bladeTwist];
_heli setVariable ["bmk_helisim_rotor_m",          _rotor_bladeMass];
_heli setVariable ["bmk_helisim_rotor_eR",         _rotor_hingeOffsetRatio];
private _rtr_0_e  = _rotor_bladeRadius # 0 * _rotor_hingeOffsetRatio # 0;
private _rtr_1_e  = _rotor_bladeRadius # 1 * _rotor_hingeOffsetRatio # 1;
_heli setVariable ["bmk_helisim_rotor_e",          [_rtr_0_e, _rtr_1_e]];
private _rtr_0_s  = (_rotor_numBlades # 0 * _rotor_bladeChord # 0) / (pi * _rotor_bladeRadius # 0);
private _rtr_1_s  = (_rotor_numBlades # 1 * _rotor_bladeChord # 1) / (pi * _rotor_bladeRadius # 1);
_heli setVariable ["bmk_helisim_rotor_s",          [_rtr_0_s, _rtr_1_s]];
private _rtr_0_Ib = (1.0 / 3.0) * _rotor_bladeMass # 0 * (_rotor_bladeRadius # 0 * _rotor_bladeRadius # 0);
private _rtr_0_HO = 1.0 - _rotor_hingeOffsetRatio # 0;
_rtr_0_Ib = _rtr_0_Ib * (_rtr_0_HO * _rtr_0_HO * _rtr_0_HO);

private _rtr_1_Ib = (1.0 / 3.0) * _rotor_bladeMass # 1 * (_rotor_bladeRadius # 1 * _rotor_bladeRadius # 1);
private _rtr_1_HO = 1.0 - _rotor_hingeOffsetRatio # 1;
_rtr_1_Ib = _rtr_1_Ib * (_rtr_0_HO * _rtr_0_HO * _rtr_0_HO);
_heli setVariable ["bmk_helisim_rotor_Ib",         [_rtr_0_Ib, _rtr_1_Ib]];
_heli setVariable ["bmk_helisim_rotor_gearRatio",  _rotor_gearRatio];
private _rtr_0_MOI = _rotor_numBlades # 0 * _rotor_bladeMass # 0 * ((_rotor_bladeRadius # 0 * 0.55) * (_rotor_bladeRadius # 0 * 0.55));
private _rtr_1_MOI = _rotor_numBlades # 1 * _rotor_bladeMass # 1 * ((_rotor_bladeRadius # 1 * 0.55) * (_rotor_bladeRadius # 1 * 0.55));
_heli setVariable ["bmk_helisim_rotor_polarMOI",   [_rtr_0_MOI, _rtr_1_MOI]];

//--Engines
private _engine1 = [_heli, 1066, 21109, 0.57, 1.01, 0.09, 0.18] call bmk_helisim_fnc_engineInit;
_heli setVariable ["bmk_helisim_engine1", _engine1];

private _engine2 = [_heli, 1066, 21109, 0.57, 1.01, 0.09, 0.18] call bmk_helisim_fnc_engineInit;
_heli setVariable ["bmk_helisim_engine2", _engine2];

[_heli] call bmk_helisim_fnc_rotorVariables;
[_heli] call bmk_helisim_fnc_engineVariables;
[_heli] call bmk_helisim_fnc_xmsnVariables;