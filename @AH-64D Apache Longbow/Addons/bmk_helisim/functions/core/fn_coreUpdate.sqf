params ["_heli"];
#include "\bmk_helisim\headers\core.hpp"

if (isGamePaused) exitwith {};
private _flightModel = configFile >> "CfgVehicles" >> typeof _heli >> "FlightModel";
if ((getText _flightModel) != "HeliSim") exitWith {};

private _deltaTime = ((["helisim_deltaTime"] call BIS_fnc_deltaTime) min 1/30);

//--Get input
private _controlInputs       = [_heli, _deltaTime] call bmk_helisim_fnc_utilityGetInput;

////////////////////////////////////////////////////////////////////////////////////////////////////
//Environment    ///////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
private _altitude          = 0;//_heli getVariable "fza_sfmplus_PA"; //0;     //ft
private _altimeter         = 29.92; //in mg
private _temperature       = 15;//_heli getVariable "fza_sfmplus_FAT"; //15;    //deg c 

private _referencePressure = _altimeter * IN_MG_TO_HPA;
private _referenceAltitude = 0;
private _exp               = -GRAVITY * MOLAR_MASS_OF_AIR * (_altitude - _referenceAltitude) / (UNIVERSAL_GAS_CONSTANT * (_temperature + DEG_C_TO_KELVIN));
private _pressure          = ((_referencePressure / 0.01) * (EXP _exp)) * 0.01;

private _densityAltitude   = (_altitude + ((SEA_LEVEL_PRESSURE - _altimeter) * 1000)) + (120 * (_temperature - (STANDARD_TEMP - ((_altitude / 1000) * 2))));
private _dryAirDensity     = (_pressure / 0.01) / (287.05 * (_temperature + DEG_C_TO_KELVIN));
////////////////////////////////////////////////////////////////////////////////////////////////////
//Environment    ///////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

//--Main rotor
private _mainRotorPos = [0.0, 2.06, 0.70]; //m -- MOVE TO CONFIG
private _mainRotorRot = [0.0, 0.0]; //deg -- MOVE TO CONFIG
([_heli, _deltaTime, 1.225, 0, MAIN_RTR_POS, MAIN_RTR_PITCH, MAIN_RTR_ROLL, _controlInputs] call bmk_helisim_fnc_rotor)
    params

//private _mainRotor    = [_heli, _deltaTime, _dryAirDensity, _mainRotorPos, _mainRotorRot, _controlInputs] call bmk_helisim_fnc_rotorMain;
//_mainRotor params ["_mainRotorParams","_mainRotor_outputTorque", "_mainRotor_out_x", "_mainRotor_out_y", "_mainRotor_out_z", "_mainRotor_out_l", "_mainRotor_out_m", "_mainRotor_out_n"];

//--Tail rotor
private _tailRotorPos = [-0.87, -6.98, -0.075]; //m -- MOVE TO CONFIG
private _tailRotorRot = [0.0, 90.0]; //deg -- MOVE TO CONFIG
//private _tailRotor    = [_heli, _deltaTime, _dryAirDensity, _tailRotorPos, _tailRotorRot, _controlInputs] call bmk_helisim_fnc_rotorTail;
//_tailRotor params ["_tailRotorParams", "_tailRotor_outputTorque", "_tailRotor_out_x", "_tailRotor_out_y", "_tailRotor_out_z", "_tailRotor_out_l", "_tailRotor_out_m", "_tailRotor_out_n"];
[_heli, _deltaTime, 1.225, 1, TAIL_RTR_POS, TAIL_RTR_PITCH, TAIL_RTR_ROLL, _controlInputs] call bmk_helisim_fnc_rotor;


//private _outputTorque = _mainRotor_outputTorque + _tailRotor_outputTorque;
//hintsilent format ["Output torque: %1 -- %2", _outputTorque toFixed 0, (_outputTorque / 481) * 100 toFixed 0];

//--Engines

private _engine1Input = _heli getVariable "bmk_helisim_engine1";
private _engine1      = [_heli, 0, _deltaTime, _engine1Input, _controlInputs, _outputTorque, 1.31] call bmk_helisim_fnc_engine;

private _engine2Input = _heli getVariable "bmk_helisim_engine2";
private _engine2      = [_heli, 1, _deltaTime, _engine1Input, _controlInputs, _outputTorque, 1.31] call bmk_helisim_fnc_engine;

//--Transmission
private _engines = [ _engine1, _engine2];
[_heli, _mainRotorParams, _engines, _outputTorque] call bmk_helisim_fnc_xmsn;

//--Fuselage
[_heli, _deltaTime, _altitude, _temperature, _dryAirDensity] call bmk_helisim_fnc_fuselageDrag;