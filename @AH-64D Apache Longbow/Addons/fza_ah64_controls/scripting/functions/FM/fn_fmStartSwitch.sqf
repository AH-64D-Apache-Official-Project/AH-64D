params ["_heli", "_engNum"];

private _flightModel = configFile >> "CfgVehicles" >> typeof _heli >> "FlightModel";

if ((getText _flightModel) == "SFMPlus") then {
    //SFM+
    [_heli, _engNum] call fza_sfmplus_fnc_interactStartSwitch;
} else {
    //HeliSim
    [_heli, _engNum] call fza_helisim_fnc_interactStartSwitch;
};