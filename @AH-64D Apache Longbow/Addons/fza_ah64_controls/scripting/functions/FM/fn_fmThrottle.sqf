params ["_heli", "_engNum"];

private _flightModel = configFile >> "CfgVehicles" >> typeof _heli >> "FlightModel";

if ((getText _flightModel) == "SFMPlus") then {
    //SFM+

} else {
    //HeliSim

};