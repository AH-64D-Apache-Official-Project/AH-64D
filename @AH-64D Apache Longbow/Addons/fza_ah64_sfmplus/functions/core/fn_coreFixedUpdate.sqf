#include "\fza_ah64_sfmplus\headers\core.hpp"

params ["_heli"];

if (isGamePaused || CBA_missionTime < 0.1) exitwith {
    _heli setVariable ["fza_sfmplus_previousTime",  diag_tickTime];
    _heli setVariable ["fza_sfmplus_deltaTime_avg", [fza_sfmplus_movingAverageSize] call fza_sfmplus_fnc_smoothAverageInit]
};

//Environment
private _altitude          = _heli getVariable "fza_sfmplus_PA"; //0;     //ft
private _altimeter         = 29.92; //in mg
private _temperature       = _heli getVariable "fza_sfmplus_FAT"; //15;    //deg c 

private _referencePressure = _altimeter * IN_MG_TO_HPA;
private _referenceAltitude = 0;
private _exp               = -GRAVITY * MOLAR_MASS_OF_AIR * (_altitude - _referenceAltitude) / (UNIVERSAL_GAS_CONSTANT * (_temperature + DEG_C_TO_KELVIN));
private _pressure          = ((_referencePressure / 0.01) * (EXP _exp)) * 0.01;

private _densityAltitude   = (_altitude + ((SEA_LEVEL_PRESSURE - _altimeter) * 1000)) + (120 * (_temperature - (STANDARD_TEMP - ((_altitude / 1000) * 2))));
private _dryAirDensity     = (_pressure / 0.01) / (287.05 * (_temperature + DEG_C_TO_KELVIN));

//Main Rotor
[_heli, _altitude, _temperature, _dryAirDensity] call fza_sfmplus_fnc_simpleRotorMain;

//Tail Rotor
[_heli, _altitude, _temperature, _dryAirDensity] call fza_sfmplus_fnc_simpleRotorTail;

//Drag
[_heli, _altitude, _temperature, _dryAirDensity] call fza_sfmplus_fnc_fuselageDrag;

//Vertical fin
[_heli, _dryAirDensity] call fza_sfmplus_fnc_aeroWing;

//Stabilator
[_heli, _dryAirDensity] call fza_sfmplus_fnc_aeroStabilator;