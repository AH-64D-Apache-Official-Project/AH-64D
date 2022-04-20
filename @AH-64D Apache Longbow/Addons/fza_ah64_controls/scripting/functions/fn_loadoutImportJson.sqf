/* ----------------------------------------------------------------------------
Function: fza_fnc_loadoutImportJson

Description:
	Import of website heicopter configuration and apply it to the helicopter
	
Parameters:
	_heli - The helicopter to get information from [Unit].

Returns:

Examples:
	[vehicle player, Json Data] call fza_loadoutImportJson

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli","_json"];
if (_json == "") exitwith {};
private _settings = [_json] call CBA_fnc_parseJSON;
private _PylonArraycheck  = ["pylon1","pylon2","pylon3","pylon4"];
private _pylonRktCheck = ["zoneA","zoneB","zoneE"];
private _pylonMslCheck = ["ul","ur","ll","lr"];
private _MagazineArray = [];
private _MagazineIndex = 16;

//System Settings
private _FCRstate = _settings getVariable "fcrInstalled";
private _FCRstate = [0, 1] select _FCRstate;
_heli animateSource ["fcr_enable", _FCRstate];

private _IAFSstate = _settings getVariable "iafsInstalled";
private _IAFSstate = [1, 0] select _IAFSstate;
[_heli, _IAFSstate] call fza_fnc_weaponSwapM230Mag;

//SFM Weight sim
[_heli] call fza_sfmplus_fnc_coreConfig;

private _fuelKg = _settings getVariable "fuel";
if (_IAFSstate == 0) then { 
    _fuelWeightPercentage = _fuelKg / 1443; 
} else { 
    _fuelWeightPercentage = _fuelKg / 1142; 
}; 
_heli setfuel _fuelWeightPercentage;

//SFM Weight sim
[_heli] call fza_sfmplus_fnc_fuelSet;

//Loadout settings
{
    private _pylonnumber = _x;
    private _pyloninfo = _settings getVariable _X;
    private _pylontype = _pyloninfo getVariable "type";
    if (_pylontype == "None") then {
            for "_i" from 0 to 3 do {
            _MagazineArray pushback [_MagazineIndex,""];
            _MagazineIndex = _MagazineIndex - 1;
        };
        continue;
    };
    if (_pylontype == "rocket") then {
        {
            private _Pylonzone = _x;
            private _ammoname = _pyloninfo getVariable _x;
            private _magname = "fza_275_" + _ammoname + "_" + _Pylonzone;
            _MagazineArray pushback [_MagazineIndex,_magname];
            _MagazineIndex = _MagazineIndex - 1;
        } foreach _pylonRktCheck;
        _MagazineArray pushback [_MagazineIndex,""];
        _MagazineIndex = _MagazineIndex - 1;
        continue;
    };
    if (_pylontype == "hellfire") then {
        {
            private _ammoname = _pyloninfo getVariable _x;
            _ammoname = [_ammoname] call BIS_fnc_filterString;
            private _magname = "fza_" + _ammoname + "_" + _x; 
            _MagazineArray pushback [_MagazineIndex,_magname];
            _MagazineIndex = _MagazineIndex - 1;
        } foreach _pylonMslCheck;
    };
} foreach _PylonArraycheck;
_MagazineArray;

{    
    _x params ["_Pylonindex","_MagazineName"]; 
    _heli setPylonLoadout [_Pylonindex, _MagazineName, true, [0]]; 
} foreach _MagazineArray;

fza_ah64_pylonsLastCheckMags = getPylonMagazines _heli;