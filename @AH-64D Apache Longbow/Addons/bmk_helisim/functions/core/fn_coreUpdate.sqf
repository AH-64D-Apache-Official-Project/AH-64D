params ["_heli"];
#include "\bmk_helisim\headers\core.hpp"

if (isGamePaused) exitwith {};

private _flightModel = configFile >> "CfgVehicles" >> typeof _heli >> "FlightModel";
if ((getText _flightModel) != "HeliSim") exitWith {};


systemChat format ["HeliSim is running!"];

private _deltaTime   = ((["helisim_deltaTime"] call BIS_fnc_deltaTime) min 1/30);

//--Get input
private _controlInputs     = [_heli, _deltaTime] call bmk_helisim_fnc_utilityGetInput;

//--Environment
private _altitude          = 0;//_heli getVariable "fza_sfmplus_PA"; //0;     //ft
private _altimeter         = 29.92; //in mg
private _temperature       = 15;//_heli getVariable "fza_sfmplus_FAT"; //15;    //deg c 

private _referencePressure = _altimeter * IN_MG_TO_HPA;
private _referenceAltitude = 0;
private _exp               = -GRAVITY * MOLAR_MASS_OF_AIR * (_altitude - _referenceAltitude) / (UNIVERSAL_GAS_CONSTANT * (_temperature + DEG_C_TO_KELVIN));
private _pressure          = ((_referencePressure / 0.01) * (EXP _exp)) * 0.01;

private _densityAltitude   = (_altitude + ((SEA_LEVEL_PRESSURE - _altimeter) * 1000)) + (120 * (_temperature - (STANDARD_TEMP - ((_altitude / 1000) * 2))));
private _dryAirDensity     = (_pressure / 0.01) / (287.05 * (_temperature + DEG_C_TO_KELVIN));

//--Engines
private _engine1Input = _heli getVariable "bmk_helisim_engine1";
private _engine1      = [_heli, _deltaTime, 0, _engine1Input, _controlInputs, 1.31] call bmk_helisim_fnc_engine;

private _engine2Input = _heli getVariable "bmk_helisim_engine2";
private _engine2      = [_heli, _deltaTime, 1, _engine2Input, _controlInputs, 1.31] call bmk_helisim_fnc_engine;

//--Transmission
private _engines = [ _engine1, _engine2];
[_heli, _engines] call bmk_helisim_fnc_xmsn;

//--Main rotor
private _mainRotorPos = [0.0, 2.06, 0.70]; //m -- MOVE TO CONFIG
private _mainRotorRot = [0.0, 0.0]; //deg -- MOVE TO CONFIG
[_heli, _deltaTime, _dryAirDensity, 0, _mainRotorPos, _mainRotorRot, _controlInputs] call bmk_helisim_fnc_rotor;

//--Tail rotor
private _tailRotorPos = [-0.87, -6.98, -0.075]; //m -- MOVE TO CONFIG
private _tailRotorRot = [0.0, 90.0]; //deg -- MOVE TO CONFIG
[_heli, _deltaTime, _dryAirDensity, 1, _tailRotorPos, _tailRotorRot, _controlInputs] call bmk_helisim_fnc_rotor;

//--Fuselage
[_heli, _deltaTime, _altitude, _temperature, _dryAirDensity] call bmk_helisim_fnc_fuselageDrag;