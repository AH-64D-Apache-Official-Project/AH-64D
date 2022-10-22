params ["_heli"];

private _flightModel = configFile >> "CfgVehicles" >> typeof _heli >> "FlightModel";
//if ((getText _flightModel) != "HeliSim") exitWith {};

private _deltaTime = ((["helisim_deltaTime"] call BIS_fnc_deltaTime) min 1/30);

[_heli, _deltaTime] call bmk_helisim_fnc_rotor;