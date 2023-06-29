/* ----------------------------------------------------------------------------
Function: fza_fnc_loadoutImportJson

Description:
    Import of website heicopter configuration and apply it to the helicopter
    
Parameters:
    _heli - The helicopter to get information from [Unit].
    _json - the Json string output from the website

Returns:

Examples:
    [vehicle player, Json Data] call fza_loadoutImportJson

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli","_json"];
if (_json == "") exitwith {};
if (_json == "true") exitwith {};

private _settings = [_json] call CBA_fnc_parseJSON;
private _nameCheck = ["M151","M229","M261","M257","M255","AGM114A","AGM114C","AGM114K","AGM114L","AGM114M","AGM114N"];
private _pylonArraycheck  = ["pylon1","pylon2","pylon3","pylon4"];
private _pylonRktCheck = ["zoneE","zoneB","zoneA"];
private _pylonMslCheck = ["lr","ll","ur","ul"];
private _magazineIndex = 16;

//System Settings
private _fcrState = [0, 1] select (_settings getVariable "fcrInstalled");
_heli animateSource ["fcr_enable", _fcrState];

private _iafsState = [1, 0] select (_settings getVariable "iafsInstalled");
[_heli, _iafsState] call fza_fnc_weaponSwapM230Mag;

//SFM Weight sim
[_heli] call fza_sfmplus_fnc_coreConfig;
private _fuelKg = _settings getVariable "fuel";
private _iafsState = [0, 1] select (_settings getVariable "iafsInstalled");
private _sfmPlusCfg = configFile >> "CfgVehicles" >> typeOf _heli >> "Fza_SfmPlus";
private _tankCapacityKg = getNumber (_sfmPlusCfg >> "maxFwdFuelMass") + getNumber (_sfmPlusCfg >> "maxAftFuelMass") + _iafsState * getNumber (_sfmPlusCfg >> "maxCtrFuelMass");
_heli setFuel (_fuelKg / _tankCapacityKg);

//SFM Weight sim
[_heli] call fza_sfmplus_fnc_fuelSet;

//Loadout settings
{
    private _pylonNumber = _x;
    private _pylonInfo = _settings getVariable _X;
    private _pylonType = _pylonInfo getVariable "type";
    switch _pylonType do {
        case "none": {
            for "_i" from 0 to 3 do {
                _heli setPylonLoadout [_magazineIndex, "", true, [0]]; 
                _magazineIndex = _magazineIndex - 1;
            };
        };
        case "rocket": {
            _heli setPylonLoadout [_magazineIndex, "", true, [0]]; 
            _magazineIndex = _magazineIndex - 1;
            {
                private _pylonZone = _x;
                private _ammoName = _pylonInfo getVariable _x;
                if (_ammoName in _nameCheck) then {
                    private _magName = "fza_275_" + _ammoName + "_" + _pylonZone;
                    _heli setPylonLoadout [_magazineIndex, _magName, true, [0]];
                    _magazineIndex = _magazineIndex - 1;
                } else {
                    _heli setPylonLoadout [_magazineIndex, "", true, [0]];
                    _magazineIndex = _magazineIndex - 1;
                };
            } foreach _pylonRktCheck;
        };
        case "hellfire": {
            {
                private _ammoName = _pylonInfo getVariable _x;
                _ammoName = [_ammoName] call BIS_fnc_filterString;
                if (_ammoName in _nameCheck) then {
                    private _magName = "fza_" + _ammoName + "_" + _x; 
                    _heli setPylonLoadout [_magazineIndex, _magName, true, [0]];
                    _magazineIndex = _magazineIndex - 1;
                } else {
                    _heli setPylonLoadout [_magazineIndex, "", true, [0]];
                    _magazineIndex = _magazineIndex - 1;
                };
            } foreach _pylonMslCheck;
        };
        default {
            ["Unknown pylon type %1", _pylonType] call BIS_fnc_error;
        };
    };
} foreach _pylonArraycheck;