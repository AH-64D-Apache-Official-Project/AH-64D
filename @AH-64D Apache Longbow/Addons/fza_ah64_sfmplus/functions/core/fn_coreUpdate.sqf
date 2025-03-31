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

if (isGamePaused || CBA_missionTime < 0.1) exitwith {};

private _config      = configFile >> "CfgVehicles" >> typeof _heli;

[_heli] call fza_sfmplus_fnc_getDeltaTime;

if (isAutoHoverOn _heli) then {
    _heli action ["AutoHoverCancel", _heli];  
};

//Environment
[_heli] call fza_sfmplus_fnc_environment;

//Velocities
[_heli, fza_ah64_sfmplusEnableWind] call fza_sfmplus_fnc_getVelocities;
[_heli] call fza_sfmplus_fnc_getAccelerations;

//Input
[_heli] call fza_sfmplus_fnc_fmc;
[_heli] call fza_sfmplus_fnc_getInput;

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

//Damage
[_heli] call fza_sfmplus_fnc_damageApply;

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