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

fza_sfmplus_liftLossTimer = 0;

_heli setVariable ["fza_sfmplus_emptyMassFCR",       getNumber (_config >> "emptyMassFCR")];        //kg
_heli setVariable ["fza_sfmplus_emptyMassNonFCR",    getNumber (_config >> "emptyMassNonFCR")];     //kg

_heli setVariable ["fza_sfmplus_stabPos",            getArray  (_config >> "stabPos")];
_heli setVariable ["fza_sfmplus_stabWidth",          getNumber (_config >> "stabWidth")];           //m
_heli setVariable ["fza_sfmplus_stabLength",         getNumber (_config >> "stabLength")];          //m

_heli setVariable ["fza_sfmplus_centerOfMass",       getArray  (_config >> "centerOfMass")];        //m
_heli setVariable ["fza_sfmplus_aerodynamicCenter",  getArray  (_config >> "aerodynamicCenter")];   //m
_heli setVariable ["fza_sfmplus_fuselageAreaFront",  getNumber (_config >> "fuselageAreaFront")];
_heli setVariable ["fza_sfmplus_fuselageAreaSide",   getNumber (_config >> "fuselageAreaSide")];
_heli setVariable ["fza_sfmplus_fuselageAreaBottom", getNumber (_config >> "fuselageAreaBottom")];

_heli setVariable ["fza_sfmplus_maxFwdFuelMass",     getNumber (_config >> "maxFwdFuelMass")];  //1043lbs in kg
_heli setVariable ["fza_sfmplus_maxCtrFuelMass",     getNumber (_config >> "maxCtrFuelMass")];  //663lbs in kg, net yet implemented, center robbie
_heli setVariable ["fza_sfmplus_maxAftFuelMass",     getNumber (_config >> "maxAftFuelMass")];  //1474lbs in kg
//_heli setVariable ["fza_sfmplus_maxExtFuelMass", getNumber (_config >> "maxExtFuelMass")];     //1541lbs in kg, not yet implemented, 230gal external tank

//Position Hold
_heli setVariable ["fza_sfmplus_pid_roll",           [1.200, 0.048, 0.920] call fza_fnc_pidCreate];
_heli setVariable ["fza_sfmplus_pid_pitch",          [0.550, 0.250, 2.200] call fza_fnc_pidCreate];
//Attitude Hold
_heli setVariable ["fza_sfmplus_pid_roll_att",       [0.500, 0.050, 0.050] call fza_fnc_pidCreate];
_heli setVariable ["fza_sfmplus_pid_pitch_att",      [0.550, 0.250, 2.200] call fza_fnc_pidCreate];
//Altitude Hold
_heli setVariable ["fza_sfmplus_pid_radHold",        [0.015,  0.003,  0.025]  call fza_fnc_pidCreate];
_heli setVariable ["fza_sfmplus_pid_barHold",        [0.0075, 0.0001, 0.0025] call fza_fnc_pidCreate];
//Heading Hold
_heli setVariable ["fza_sfmplus_pid_hdgHold",        [0.075, 0.020, 0.005] call fza_fnc_pidCreate];
_heli setVariable ["fza_sfmplus_pid_trnCoord",       [0.050, 0.010, 0.100] call fza_fnc_pidCreate];

//Fuel and Mass
if (fuel _heli > 0.99) then {
    private _initFuelFrac  = 0.0;
    private _IAFSInstalled = _heli getVariable "fza_ah64_IAFSInstalled";
    if (_IAFSInstalled) then {
        _initFuelFrac = getNumber (_config >> "initFuelFracRobbie");
    } else {
        _initFuelFrac = getNumber (_config >> "initFuelFracNoRobbie");
    };
    _heli setFuel _initFuelFrac;
};

[_heli] call fza_sfmplus_fnc_fuelSet;
[_heli] call fza_sfmplus_fnc_massSet;

//Engines
[_heli] call fza_sfmplus_fnc_engineVariables;

//Rotors
[_heli] call fza_sfmplus_fnc_simpleRotorVariables;

//Performance
[_heli] call fza_sfmplus_fnc_perfVariables;

//Actuators
[_heli] call fza_sfmplus_fnc_actuatorVariables;
