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

if (isGamePaused || CBA_missionTime < 0.1) exitWith {
    fza_ah64_previousTime = diag_tickTime;
    _heli setVariable ["fza_sfmplus_previousTime",  diag_tickTime];
    _heli setVariable ["fza_sfmplus_deltaTime_avg", [fza_sfmplus_movingAverageSize] call fza_sfmplus_fnc_smoothAverageInit];
};

private _config      = configOf _heli;

[_heli] call fza_sfmplus_fnc_getDeltaTime;

if (isAutoHoverOn _heli) then {
    _heli action ["AutoHoverCancel", _heli];  
};

//Environment
[_heli] call fza_sfmplus_fnc_environment;

//Velocities
[_heli] call fza_sfmplus_fnc_getVelocities;
[_heli] call fza_sfmplus_fnc_getAccelerations;

//Input
[_heli] call fza_sfmplus_fnc_fmc;
[_heli] call fza_sfmplus_fnc_getConnectedAxes;
[_heli] call fza_sfmplus_fnc_getInput;

//
[_heli] call fza_sfmplus_fnc_calculateAeroValues;

//Fuel
[_heli] call fza_fuel_fnc_fuelUpdate;
[_heli] call fza_fuel_fnc_fuelMgmtUpdate;

//Mass and Balance
[_heli] call fza_sfmplus_fnc_massUpdate;

//Performance
[_heli] call fza_sfmplus_fnc_perfData;

//Engines
[_heli] call fza_sfmplus_fnc_engineController;

//Transmission
[_heli] call fza_sfmplus_fnc_transmission;

//Damage
[_heli] call fza_sfmplus_fnc_damageApply;

if !(isMultiplayer) then {
    [_heli] call fza_sfmplus_fnc_probes;
};

if (fza_ah64_sfmPlusFmDebug) then { 
    hintSilent format [
    "_cyclicFwdAft = %1
    \n_cyclicLeftRight = %2
    \n_pedalYaw = %3
    \n_collectiveOuput = %4
    \n_stabilatorPosition = %5
    \n--------------------
    \n_springlessCyclic = %6
    \n_springlessPedals = %7
    \n_stickyPitch = %8
    \n_stickyRoll = %9
    \n_stickyYaw = %10
    \n_autoPedal = %11
    \n_cyclicCenterTrimMode = %12
    \n_pedalCenterTrimMode = %13
    \n--------------------
    \n_mouseAsJoystick = %14
    \n_kbStickyInterupt = %15
    \n_forceTrimInterupted = %16
    \n--------------------
    \n_attHoldCycPitchOut = %17
    \n_sasPitchOut = %18
    \n_attHoldCycRollOut = %19
    \n_sasRollOut = %20
    \n_hdgHoldPedalYawOut = %21
    \n_sasYawOut = %22
    \n_altHoldCollOut = %23
    \n--------------------
    \n_forceTrimPosPitch = %24
    \n_forceTrimPosRoll = %25
    \n_forceTrimPosPedal = %26
    \n--------------------
    \n_centerOfMass = [%27, %28, %29]
    \n_grossWeight = %30 lbs
    \n--------------------
    \n_attHoldActive = %31
    \n_attHoldSubMode = %32
    \n--------------------
    \n_altHoldActive = %33
    \n_altHoldSubMode = %34
    \n--------------------
    \n_hdgHoldActive = %35
    \n_hdgHoldSubMode = %36
    \n--------------------
    \n_flightControlLockOut = %37
    \n--------------------
    \nPitch = %38 Roll = %39
    \nYaw = %41  Sideslip = %40
    \n--------------------
    \nAutoPitch = %42 PitchActive = %43
    \nAPTarget = %44
    ",
    _heli getVariable "fza_sfmplus_cyclicFwdAft" toFixed 3,                    //1
    _heli getVariable "fza_sfmplus_cyclicLeftRight" toFixed 3,                 //2
    _heli getVariable "fza_sfmplus_pedalLeftRight" toFixed 3,                  //3
    _heli getVariable "fza_sfmplus_collectiveOutput" toFixed 3,                //4
    _heli getVariable "fza_ah64_stabilatorPosition" toFixed 3,                 //5
    fza_ah64_sfmPlusSpringlessCyclic,                                          //6
    fza_ah64_sfmPlusSpringlessPedals,                                          //7
    fza_ah64_sfmPlusKeyboardStickyPitch,                                       //8
    fza_ah64_sfmPlusKeyboardStickyRoll,                                        //9
    fza_ah64_sfmPlusKeyboardStickyYaw,                                         //10
    fza_ah64_sfmPlusAutoPedal,                                                 //11
    fza_sfmplus_cyclicCenterTrimMode,                                          //12
    fza_sfmplus_pedalCenterTrimMode,                                           //13
    fza_ah64_sfmPlusMouseAsJoystick,                                           //14
    _heli getVariable "fza_sfmplus_kbStickyInterupt",                          //15
    _heli getVariable "fza_ah64_forceTrimInterupted",                          //16
    _heli getVariable "fza_sfmplus_fmcAttHoldCycPitchOut" toFixed 3,          //17
    _heli getVariable "fza_sfmplus_fmcSasPitchOut" toFixed 3,                 //18
    _heli getVariable "fza_sfmplus_fmcAttHoldCycRollOut" toFixed 3,           //19
    _heli getVariable "fza_sfmplus_fmcSasRollOut" toFixed 3,                  //20
    _heli getVariable "fza_sfmplus_fmcHdgHoldPedalYawOut" toFixed 3,          //21
    _heli getVariable "fza_sfmplus_fmcSasYawOut" toFixed 3,                   //22
    _heli getVariable "fza_sfmplus_fmcAltHoldCollOut" toFixed 3,              //23
    _heli getVariable "fza_ah64_forceTrimPosPitch" toFixed 3,                 //24
    _heli getVariable "fza_ah64_forceTrimPosRoll" toFixed 3,                  //25
    _heli getVariable "fza_ah64_forceTrimPosYaw" toFixed 3,                 //26
    getCenterOfMass _heli select 0 toFixed 3,                                 //27
    getCenterOfMass _heli select 1 toFixed 3,                                 //28
    getCenterOfMass _heli select 2 toFixed 3,                                 //29
    ((_heli getVariable "fza_sfmplus_GWT") * 2.20462) toFixed 0,              //30
    _heli getVariable "fza_ah64_attHoldActive",                               //31
    _heli getVariable "fza_ah64_attHoldSubMode",                              //32
    _heli getVariable "fza_ah64_altHoldActive",                               //33
    _heli getVariable "fza_ah64_altHoldSubMode",                              //34
    _heli getVariable "fza_ah64_hdgHoldActive",                               //35
    _heli getVariable "fza_ah64_hdgHoldSubMode",                              //36
    _heli getVariable "fza_sfmplus_flightControlLockOut",                     //37
    _heli call BIS_fnc_getPitchBank select 0 toFixed 2,                       //38
    _heli call BIS_fnc_getPitchBank select 1 toFixed 2,                       //39
    _heli getVariable "fza_sfmplus_aero_beta_deg" toFixed 2,                  //40
    ([player getRelDir _heli] call CBA_fnc_simplifyAngle180) toFixed 2,       //41
    fza_ah64_sfmPlusAutoPitch,                                                //42
    _heli getVariable "fza_sfmplus_autoPitchActive",                          //43
    _heli getVariable "fza_sfmplus_autoPitchTarget" toFixed 1                 //44
    ];
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
                    _heli getVariable "fza_sfmplus_engFF"];
*/
#endif
