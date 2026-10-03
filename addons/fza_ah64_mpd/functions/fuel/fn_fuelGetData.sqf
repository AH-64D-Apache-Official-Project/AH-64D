#include "\bmkhs_helisim\functions\core\core.hpp"
#include "\bmkhs_helisim\functions\fuel\fuel.hpp"
params ["_heli"];

//Defaults on every read: these run before coreConfig has populated them on a fresh spawn
//or a JIP client, and a nil here propagates into the arithmetic below.
private _fwdCellWeight       = _heli getVariable ["bmkhs_fwdTankMass", 0];
private _ctrFuelWeight       = _heli getVariable ["bmkhs_ctrTankMass", 0];
private _aftCellWeight       = _heli getVariable ["bmkhs_aftTankMass", 0];

//MAIN endurance is flown on the mains only - the transfer cell and the aux tanks feed them
//rather than the engines. Core publishes which tanks those are, so this does not assume
//that the mains are tanks 1 and 3.
private _fuelTanks          = _heli getVariable ["bmkhs_fuelTanks", []];
private _mainFuelCellWeight = 0;
{
    private _tank = _fuelTanks param [_x, createHashMap];
    private _var  = _tank getOrDefault ["varName", ""];
    if (_var != "") then {
        _mainFuelCellWeight = _mainFuelCellWeight + (_heli getVariable [_var + "Mass", 0]);
    };
} forEach (_heli getVariable ["bmkhs_fuelMains", []]);

//Core already totals every tank that exists, internal and auxiliary. Re-adding a fixed
//seven here would disagree with the flight model the moment a tank is added or removed.
private _totalFuelCellWeight = _heli getVariable ["bmkhs_totFuelMass", 0];
_fwdCellWeight       = _fwdCellWeight * KG_TO_LBS;
_ctrFuelWeight       = _ctrFuelWeight * KG_TO_LBS;
_aftCellWeight       = _aftCellWeight * KG_TO_LBS;
_mainFuelCellWeight  = _mainFuelCellWeight * KG_TO_LBS;
_totalFuelCellWeight = _totalFuelCellWeight * KG_TO_LBS;

//bmkhs_engFuelFlow is kg/s per engine, so the display conversion is seconds-to-hours then kg-to-lbs.
#define KGS_TO_LBS_PER_HOUR (3600 * KG_TO_LBS)

private _engFF  = _heli getVariable ["bmkhs_engFuelFlow", [0, 0]];
private _eng1FF = _engFF param [0, 0];
private _eng2FF = _engFF param [1, 0];

private _eng1FuelCons = 0;
private _eng1State    = (_heli getVariable ["bmkhs_engState", ["OFF", "OFF"]]) param [0, "OFF"];
if (_eng1State == "ON") then {
    _eng1FuelCons = _eng1FF * KGS_TO_LBS_PER_HOUR;
} else {
    _eng1FuelCons = 0;
};

private _eng2FuelCons = 0;
private _eng2State    = (_heli getVariable ["bmkhs_engState", ["OFF", "OFF"]]) param [1, "OFF"];
if (_eng2State == "ON") then {
    _eng2FuelCons = _eng2FF * KGS_TO_LBS_PER_HOUR;
} else {
    _eng2FuelCons = 0;
};
//private _totalFuelConsumption  = _engineFuelConsumption # 0 + _engineFuelConsumption # 1;
private _totalFuelConsumption = _eng1FuelCons + _eng2FuelCons;

private _mainEnduranceNumber = if(_totalFuelConsumption > 0) then {
    private _enduranceTotal = 599 min (_mainFuelCellWeight / _totalFuelConsumption * 60); //Minutes
    private _enduranceMinutes = _enduranceTotal % 60;
    private _enduranceHours = floor(_enduranceTotal / 60);
    format["%1:%2", _enduranceHours toFixed 0, [_enduranceMinutes, 2] call CBA_fnc_formatNumber];
} else {"9:99"};

private _totalEnduranceNumber = if(_totalFuelConsumption > 0) then {
    private _enduranceTotal = 599 min (_totalFuelCellWeight / _totalFuelConsumption * 60); //Minutes
    private _enduranceMinutes = _enduranceTotal % 60;
    private _enduranceHours = floor(_enduranceTotal / 60);
    format["%1:%2", _enduranceHours toFixed 0, [_enduranceMinutes, 2] call CBA_fnc_formatNumber];
} else {"9:99"};

// Specific Fuel Range (nm per lb): airspeed (kts) / fuel flow (lb/hr)
// Shown blank when groundspeed < 10 kts or no fuel flow
private _sfrText = "";
private _groundspeedKts = _heli getVariable ["bmkhs_gndSpeed", 0];
if (_groundspeedKts >= 10 && _totalFuelConsumption > 0) then {
    private _sfr = (_groundspeedKts / _totalFuelConsumption) toFixed 2;
    _sfrText = if (_sfr select [0, 2] == "0.") then { _sfr select [1] } else { _sfr };
};

[_fwdCellWeight, _ctrFuelWeight, _aftCellWeight, _mainFuelCellWeight, _totalFuelCellWeight, _eng1FuelCons, _eng2FuelCons, _totalFuelConsumption, _mainEnduranceNumber, _totalEnduranceNumber, _sfrText]
