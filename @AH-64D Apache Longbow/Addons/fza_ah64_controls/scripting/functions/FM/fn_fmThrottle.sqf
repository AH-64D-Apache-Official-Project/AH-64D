params ["_heli", "_engNum", "_throttlePos", "_throttleSetPoint"];

private _flightModel = configFile >> "CfgVehicles" >> typeof _heli >> "FlightModel";

//if ((getText _flightModel) == "SFMPlus") then {
    //SFM+
    [_heli, _engNum, _throttlePos] call fza_sfmplus_fnc_interactSetThrottle;
//} else {
    //HeliSim
//    [_heli, _engNum, _throttlePos, _throttleSetPoint] call bmk_helisim_fnc_interactSetThrottle;
//};