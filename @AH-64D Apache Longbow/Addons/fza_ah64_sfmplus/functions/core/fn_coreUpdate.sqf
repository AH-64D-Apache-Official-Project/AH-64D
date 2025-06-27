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

if (isGamePaused || CBA_missionTime < 0.1) exitwith {
    fza_ah64_previousTime = diag_tickTime;
    _heli setVariable ["fza_sfmplus_previousTime",  diag_tickTime];
    _heli setVariable ["fza_sfmplus_deltaTime_avg", [fza_sfmplus_movingAverageSize] call fza_sfmplus_fnc_smoothAverageInit];
};

private _config      = configFile >> "CfgVehicles" >> typeof _heli;

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

if (fza_ah64_sfmPlusFmDebug) then { 
    hintSilent format [
    "_cyclicFwdAft = %1
    \n_cyclicLeftRight = %2
    \n_pedalYaw = %3
    \n_collectiveOuput = %4 
    \n_stabilatorPosition = %5
    \n--------------------    
    \n_springlessCyclic = %7
    \n_springlessPedals = %8
    \n_stickyPitch = %9
    \n_stickyRoll = %10
    \n_stickyYaw = %11
    \n_autoPedal = %12
    \n_cyclicCenterTrimMode = %35
    \n_pedalCenterTrimMode = %36
    \n--------------------    
    \n_kbStickyInterupt = %13
    \n_forceTrimInterupted = %14
    \n--------------------
    \n_attHoldCycPitchOut = %15
    \n_sasPitchOut = %31
    \n_attHoldCycRollOut = %16
    \n_sasRollOut = %32
    \n_hdgHoldPedalYawOut = %17
    \n_sasYawOut = %33
    \n_altHoldCollOut = %18
    \n--------------------
    \n_forceTrimPosPitch = %19
    \n_forceTrimPosRoll = %20
    \n_forceTrimPosPedal = %21
    \n--------------------    
    \n_centerOfMass = [%22, %23, %24]
    \n_grossWeight = %6 lbs
    \n--------------------    
    \n_attHoldActive = %25 
    \n_attHoldSubMode = %26
    \n--------------------    
    \n_altHoldActive = %27
    \n_altHoldSubMode = %28
    \n--------------------    
    \n_hdgHoldActive = %29
    \n_hdgHoldSubMode = %30
    \n--------------------    
    \n_flightControlLockOut = %34
    \n_autoPedalTimeScalar = %37
    \nF/B[%41, %42] L/R[%43,%44]
    \nPL/PR[%45,%46] CR/CL[%47,%48]
    ",
    _heli getVariable "fza_sfmplus_cyclicFwdAft" toFixed 3,        //1    
    _heli getVariable "fza_sfmplus_cyclicLeftRight" toFixed 3,     //2    
    _heli getVariable "fza_sfmplus_pedalLeftRight" toFixed 3,      //3    
    _heli getVariable "fza_sfmplus_collectiveOutput" toFixed 3,    //4    
    _heli getVariable "fza_ah64_stabilatorPosition" toFixed 3,     //5    
    ((_heli getVariable "fza_sfmplus_GWT") * 2.20462) toFixed 0,  //6    
    fza_ah64_sfmPlusSpringlessCyclic,   //7    
    fza_ah64_sfmPlusSpringlessPedals,   //8    
    fza_ah64_sfmPlusKeyboardStickyPitch,    //9    
    fza_ah64_sfmPlusKeyboardStickyRoll,     //10    
    fza_ah64_sfmPlusKeyboardStickyYaw,      //11    
    fza_ah64_sfmPlusAutoPedal,  //12    
    _heli getVariable "fza_sfmplus_kbStickyInterupt",   //13    
    _heli getVariable "fza_ah64_forceTrimInterupted",  //14    
    _heli getVariable "fza_sfmplus_fmcAttHoldCycPitchOut" toFixed 3,  //15    
    _heli getVariable "fza_sfmplus_fmcAttHoldCycRollOut" toFixed 3,   //16    
    _heli getVariable "fza_sfmplus_fmcHdgHoldPedalYawOut" toFixed 3,  //17    
    _heli getVariable "fza_sfmplus_fmcAltHoldCollOut" toFixed 3,  //18    
    _heli getVariable "fza_ah64_forceTrimPosPitch" toFixed 3,  //19    
    _heli getVariable "fza_ah64_forceTrimPosRoll" toFixed 3,   //20    
    _heli getVariable "fza_ah64_forceTrimPosPedal" toFixed 3,   //21    
    getCenterOfMass _heli select 0 toFixed 3, //22    
    getCenterOfMass _heli select 1 toFixed 3, //23    
    getCenterOfMass _heli select 2 toFixed 3,  //24    
    _heli getVariable "fza_ah64_attHoldActive", //25    
    _heli getVariable "fza_ah64_attHoldSubMode", //26    
    _heli getVariable "fza_ah64_altHoldActive", //27    
    _heli getVariable "fza_ah64_altHoldSubMode", //28    
    _heli getVariable "fza_ah64_hdgHoldActive", //29    
    _heli getVariable "fza_ah64_hdgHoldSubMode", //30    
    _heli getVariable "fza_sfmplus_fmcSasPitchOut" toFixed 3, //31    
    _heli getVariable "fza_sfmplus_fmcSasRollOut" toFixed 3, //32    
    _heli getVariable "fza_sfmplus_fmcSasYawOut" toFixed 3,   //33    
    _heli getVariable "fza_sfmplus_flightControlLockOut", //34   
    fza_sfmplus_cyclicCenterTrimMode, //35   
    fza_sfmplus_pedalCenterTrimMode, //36   
    fza_ah64_sfmPlusAutoPedalTimeScalar, //37   
    0, //38   
    0, //39   
    0, //40  
    _heli getVariable "fza_sfmplus_pedalLeftRight" toFixed 2, //41  
    _heli getVariable "fza_sfmplus_heliCyclicBackwardOut" toFixed 2, //42  
    _heli getVariable "fza_sfmplus_heliCyclicLeftOut" toFixed 2, //43  
    _heli getVariable "fza_sfmplus_heliCyclicRightOut" toFixed 2, //44  
    _heli getVariable "fza_sfmplus_heliRudderLeftOut" toFixed 2, //45  
    _heli getVariable "fza_sfmplus_heliRudderRightOut" toFixed 2, //46  
    _heli getVariable "fza_sfmplus_heliCollectiveRaiseOut" toFixed 2, //47  
    _heli getVariable "fza_sfmplus_heliCollectiveLowerOut" toFixed 2 //48  
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
                    _heli getVariable "fza_sfmplus_engFF",
                    _heli getVariable "fza_sfmplus_engBaseNG"];
*/
#endif