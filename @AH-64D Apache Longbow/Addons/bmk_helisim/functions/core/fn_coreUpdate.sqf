params ["_heli"];
#include "\bmk_helisim\headers\core.hpp"

private _flightModel = configFile >> "CfgVehicles" >> typeof _heli >> "FlightModel";
//if ((getText _flightModel) != "HeliSim") exitWith {};

private _deltaTime = ((["helisim_deltaTime"] call BIS_fnc_deltaTime) min 1/30);

////////////////////////////////////////////////////////////////////////////////////////////////////
//Environment    ///////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
private _altitude          = _heli getVariable "fza_sfmplus_PA"; //0;     //ft
private _altimeter         = 29.92; //in mg
private _temperature       = _heli getVariable "fza_sfmplus_FAT"; //15;    //deg c 

private _referencePressure = _altimeter * IN_MG_TO_HPA;
private _referenceAltitude = 0;
private _exp               = -GRAVITY * MOLAR_MASS_OF_AIR * (_altitude - _referenceAltitude) / (UNIVERSAL_GAS_CONSTANT * (_temperature + DEG_C_TO_KELVIN));
private _pressure          = ((_referencePressure / 0.01) * (EXP _exp)) * 0.01;

private _densityAltitude   = (_altitude + ((SEA_LEVEL_PRESSURE - _altimeter) * 1000)) + (120 * (_temperature - (STANDARD_TEMP - ((_altitude / 1000) * 2))));
private _dryAirDensity     = (_pressure / 0.01) / (287.05 * (_temperature + DEG_C_TO_KELVIN));

[_heli, _deltaTime, _dryAirDensity] call bmk_helisim_fnc_rotor;

[_heli, _deltaTime, _dryAirDensity] call bmk_helisim_fnc_fuselageDrag;