/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_coreConfig

Description:
    Defines key values for the simulation.

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

private _config = configFile >> "CfgVehicles" >> typeof _heli >> "fza_sfmplus";

fza_sfmplus_liftLossTimer    = 0;
fza_sfmplus_collectiveOutput = 0.0;

_heli setVariable ["fza_sfmplus_emptyMassFCR",       getNumber (_config >> "emptyMassFCR")];        //kg
_heli setVariable ["fza_sfmplus_emptyMomFCR",        getNumber (_config >> "emptyMomFCR")];
_heli setVariable ["fza_sfmplus_emptyCoMFCR",        getArray (_config >> "emptyCoMFCR")];

_heli setVariable ["fza_sfmplus_emptyMassNonFCR",    getNumber (_config >> "emptyMassNonFCR")];     //kg
_heli setVariable ["fza_sfmplus_emptyMomNonFCR",     getNumber (_config >> "emptyMomNonFCR")];
_heli setVariable ["fza_sfmplus_emptyCoMNonFCR",     getArray (_config >> "emptyCoMNonFCR")];

//private _emptyCoM = 0.0;
//if (_heli animationPhase "fcr_enable" == 1) then {
//    _emptyCoM = _heli getVariable "fza_sfmplus_emptyCoMFCR";
//} else {
//    _emptyCoM = _heli getVariable "fza_sfmplus_emptyCoMNonFCR";
//};
//_heli setVariable ["fza_sfmplus_emptyCoM",          _emptyCoM];
//_heli setCenterOfMass [_emptyCoM];

_heli setVariable ["fza_sfmplus_stabPos",            getArray  (_config >> "stabPos")];
_heli setVariable ["fza_sfmplus_stabWidth",          getNumber (_config >> "stabWidth")];           //m
_heli setVariable ["fza_sfmplus_stabLength",         getNumber (_config >> "stabLength")];          //m

_heli setVariable ["fza_sfmplus_aerodynamicCenter",  getArray  (_config >> "aerodynamicCenter")];   //m
_heli setVariable ["fza_sfmplus_fuselageAreaFront",  getNumber (_config >> "fuselageAreaFront")];
_heli setVariable ["fza_sfmplus_fuselageAreaSide",   getNumber (_config >> "fuselageAreaSide")];
_heli setVariable ["fza_sfmplus_fuselageAreaBottom", getNumber (_config >> "fuselageAreaBottom")];

_heli setVariable ["fza_sfmplus_maxFwdFuelMass",     getNumber (_config >> "maxFwdFuelMass")];  //1043lbs in kg
_heli setVariable ["fza_sfmplus_maxCtrFuelMass",     getNumber (_config >> "maxCtrFuelMass")];  //663lbs in kg, net yet implemented, center robbie
_heli setVariable ["fza_sfmplus_maxAftFuelMass",     getNumber (_config >> "maxAftFuelMass")];  //1474lbs in kg
_heli setVariable ["fza_sfmplus_maxExtFuelMass",     getNumber (_config >> "maxExtFuelMass")];     //1541lbs in kg, not yet implemented, 230gal external tank

_heli setVariable ["fza_sfmplus_collectiveVal",      0.0];

//Position Hold
_heli setVariable ["fza_sfmplus_pid_roll",           [0.0240, 0.0030, 0.0360] call fza_fnc_pidCreate];
_heli setVariable ["fza_sfmplus_pid_pitch",          [0.1500, 0.0050, 0.0900] call fza_fnc_pidCreate];
//Attitude Hold
_heli setVariable ["fza_sfmplus_pid_roll_att",       [0.0400, 0.0015, 0.0180] call fza_fnc_pidCreate];
_heli setVariable ["fza_sfmplus_pid_pitch_att",      [0.0925, 0.0025, 0.0450] call fza_fnc_pidCreate];
//Altitude Hold
_heli setVariable ["fza_sfmplus_pid_radHold",        [0.015,  0.003,  0.025]  call fza_fnc_pidCreate];
_heli setVariable ["fza_sfmplus_pid_barHold",        [0.0075, 0.0001, 0.0025] call fza_fnc_pidCreate];
//Heading Hold
_heli setVariable ["fza_sfmplus_pid_hdgHold",        [0.0750, 0.0200, 0.0050] call fza_fnc_pidCreate];
_heli setVariable ["fza_sfmplus_pid_trnCoord",       [0.0600, 0.0002, 0.0050] call fza_fnc_pidCreate];
//SAS Functions
_heli setVariable ["fza_sfmplus_pid_sas_pitch",      [0.0750, 0.00002, 0.0100] call fza_fnc_pidCreate];
_heli setVariable ["fza_sfmplus_pid_sas_roll",       [0.0450, 0.00002, 0.0100] call fza_fnc_pidCreate];
_heli setVariable ["fza_sfmplus_pid_sas_yaw",        [0.0000, 0.00000, 0.0000] call fza_fnc_pidCreate];

//Aerodynamic State Variables
_heli setVariable ["fza_sfmplus_aero_alpha",         0.0];
_heli setVariable ["fza_sfmplus_aero_beta_deg",      0.0];
_heli setVariable ["fza_sfmplus_aero_beta_g",        0.0];
_heli setVariable ["fza_sfmplus_aero_gamma",         0.0];

_heli setVariable ["fza_sfmplus_aero_prevVelX",      0.0];
_heli setVariable ["fza_sfmplus_aero_accelX",        0.0];

_heli setVariable ["fza_sfmplus_aero_prevVelY",      0.0];
_heli setVariable ["fza_sfmplus_aero_accelY",        0.0];

_heli setVariable ["fza_sfmplus_aero_prevVelZ",      0.0];
_heli setVariable ["fza_sfmplus_aero_accelZ",        0.0];

_heli setVariable ["fza_sfmplus_aero_accel",         [0.0, 0.0, 0.0]];

//Fuel
[_heli] call fza_sfmplus_fnc_fuelVariables;
[_heli] call fza_sfmplus_fnc_fuelSet;

//Engines
[_heli] call fza_sfmplus_fnc_engineVariables;

//Rotors
[_heli] call fza_sfmplus_fnc_simpleRotorVariables;

//Performance
[_heli] call fza_sfmplus_fnc_perfVariables;

//Actuators
[_heli] call fza_sfmplus_fnc_actuatorVariables;
