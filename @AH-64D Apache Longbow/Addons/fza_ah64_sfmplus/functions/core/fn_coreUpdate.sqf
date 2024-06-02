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

private _sfmPlusConfig = _config >> "Fza_SfmPlus";
private _numRtrs       = getNumber (_sfmPlusConfig >> "numRotors");

private _deltaTime   = ["sfmplus_deltaTime"] call BIS_fnc_deltaTime;

if (isAutoHoverOn _heli && _flightModel != "SFMPlus") then {
    _heli action ["AutoHoverCancel", _heli];  
};

//Input
[_heli, _deltaTime] call fza_sfmplus_fnc_getInput;

//Fuel
[_heli,_deltaTime] call fza_sfmplus_fnc_fuelUpdate;

//Mass and Balance
[_heli] call fza_sfmplus_fnc_massUpdate;

//Performance
[_heli] call fza_sfmplus_fnc_perfData;

//Engines
[_heli, _deltaTime] call fza_sfmplus_fnc_engineController;

if (_flightModel != "SFMPlus") then {
    //Main Rotor
    for "_i" from 0 to (_numRtrs - 1) do {
        [_heli, _i, _deltaTime] call fza_sfmplus_fnc_simpleRotor;
    };
    //Drag
    [_heli, _deltaTime] call fza_sfmplus_fnc_fuselageDrag;
    //Vertical fin
    private _vertFinPosition   = [0.0, -6.40, -1.75];
    private _vertFinSweep      = -1.2;
    private _vertFinRot        = 7.5;
    private _vertFinDimensions = [2.25, 0.90];
    [_heli, _deltaTime, _heli getVariable "fza_sfmplus_rho", 1, _vertFinPosition, _vertFinSweep, _vertFinDimensions, _vertFinRot] call fza_sfmplus_fnc_aeroWing;
};

//Damage
[_heli, _deltaTime] call fza_sfmplus_fnc_damageApply;

//Stabilator
if(fza_ah64_sfmPlusStabilatorEnabled == STABILATOR_MODE_ALWAYSENABLED 
    || fza_ah64_sfmPlusStabilatorEnabled == STABILATOR_MODE_JOYSTICKONLY && !fza_ah64_sfmPlusKeyboardOnly) then {
    [_heli, _deltaTime, _dryAirDensity] call fza_sfmplus_fnc_aeroStabilator;
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