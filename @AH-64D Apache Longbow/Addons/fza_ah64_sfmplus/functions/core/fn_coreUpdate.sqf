/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_coreUpdate

Description:
    Updates all of the modules core functions.
    
Parameters:
    _heli - The helicopter to get information from [Unit].

Returns:
    ...

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli"];
#include "\fza_ah64_sfmplus\headers\core.hpp"

if (isGamePaused) exitwith {};
if (CBA_missionTime < 0.1) exitwith {};

private _config      = configFile >> "CfgVehicles" >> typeof _heli;
private _flightModel = getText (_config >> "fza_flightModel");

[] call fza_sfmplus_fnc_getDeltaTime;

if (isAutoHoverOn _heli && _flightModel != "SFMPlus") then {
    _heli action ["AutoHoverCancel", _heli];  
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

//Input
([_heli] call fza_sfmplus_fnc_fmc)
    params ["_attHoldCycPitchOut", "_attHoldCycRollOut", "_hdgHoldPedalYawOut", "_altHoldCollOut"];
[_heli, _attHoldCycPitchOut, _attHoldCycRollOut] call fza_sfmplus_fnc_getInput;

//
[_heli] call fza_sfmplus_fnc_calculateAeroValues;

//Fuel
[_heli] call fza_sfmplus_fnc_fuelUpdate;

//Mass and Balance
[_heli] call fza_sfmplus_fnc_massUpdate;

//Performance
[_heli] call fza_sfmplus_fnc_perfData;

//Engines
[_heli] call fza_sfmplus_fnc_engineController;

if (_flightModel != "SFMPlus") then {
    //Main Rotor
    [_heli, _altitude, _temperature, _dryAirDensity, _attHoldCycPitchOut, _attHoldCycRollOut, _altHoldCollOut] call fza_sfmplus_fnc_simpleRotorMain;
    //Tail Rotor
    [_heli, _altitude, _temperature, _dryAirDensity, _hdgHoldPedalYawOut] call fza_sfmplus_fnc_simpleRotorTail;
    //Drag
    [_heli, _altitude, _temperature, _dryAirDensity] call fza_sfmplus_fnc_fuselageDrag;
    //Vertical fin
    [_heli, _dryAirDensity] call fza_sfmplus_fnc_aeroWing;
};

//Damage
[_heli] call fza_sfmplus_fnc_damageApply;

//Stabilator
[_heli, _dryAirDensity] call fza_sfmplus_fnc_aeroStabilator;

if !(isMultiplayer) then {
    [_heli] call fza_sfmplus_fnc_probes;
};

#ifdef __A3_DEBUG_
/*
(_heli call BIS_fnc_getPitchBank)
    params ["_pitch", "_roll"];

hintsilent format ["Pitch =%1
                    \nRoll = %2", _pitch toFixed 0, _roll toFixed 0];

hintsilent format ["v0.11
                    \nEngine 1 Ng = %1
                    \nEngine 1 TQ = %2
                    \nEngine 1 TGT = %3
                    \n------------------
                    \nEngine 2 Ng = %4
                    \nEngine 2 TQ = %5
                    \nEngine 2 TGT = %6
                    \n------------------
                    \nEng State = %7
                    \nIs Single Engine? = %8
                    \nPercent NP = %9
                    \nEng Power Lever = %10;
                    \n-------------------
                    \nColl Pos = %11
                    \nEng FF = %12
                    \nEngine Base NG = %13",
                    _heli getVariable "fza_sfmplus_engPctNG" select 0, 
                    _heli getVariable "fza_sfmplus_engPctTQ" select 0, 
                    _heli getVariable "fza_sfmplus_engTGT" select 0,
                    _heli getVariable "fza_sfmplus_engPctNG" select 1, 
                    _heli getVariable "fza_sfmplus_engPctTQ" select 1, 
                    _heli getVariable "fza_sfmplus_engTGT" select 1,
                    _heli getVariable "fza_sfmplus_engState",
                    _heli getVariable "fza_sfmplus_isSingleEng",
                    _heli getVariable "fza_sfmplus_engPctNP",
                    _heli getVariable "fza_sfmplus_engPowerLeverState",
                    fza_sfmplus_collectiveOutput,
                    _heli getVariable "fza_sfmplus_engFF",
                    _heli getVariable "fza_sfmplus_engBaseNG"];
*/
#endif