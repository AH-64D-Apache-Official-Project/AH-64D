params ["_heli"];
#include "\fza_ah64_sfmplus\headers\core.hpp"

#define KGTOLBS 2.20462
#define FUEL_FLOW_LBS_PER_HOUR 7936.64;

private _fwdCellWeight       = _heli getVariable "fza_sfmplus_fwdFuelMass";
private _ctrFuelWeight       = _heli getVariable "fza_sfmplus_ctrFuelMass";
private _aftCellWeight       = _heli getVariable "fza_sfmplus_aftFuelMass";

private _stn1FuelWeight      = _heli getVariable "fza_sfmplus_stn1FuelMass";
private _stn2FuelWeight      = _heli getVariable "fza_sfmplus_stn2FuelMass";
private _stn3FuelWeight      = _heli getVariable "fza_sfmplus_stn3FuelMass";
private _stn4FuelWeight      = _heli getVariable "fza_sfmplus_stn4FuelMass";

private _mainFuelCellWeight  = _fwdCellWeight + _aftCellWeight;
private _totalFuelCellWeight = _fwdCellWeight + _ctrFuelWeight + _aftCellWeight + _stn1FuelWeight + _stn2FuelWeight + _stn3FuelWeight + _stn4FuelWeight;
_fwdCellWeight   = _fwdCellWeight * KGTOLBS;
_ctrFuelWeight       = _ctrFuelWeight * KGTOLBS;
_aftCellWeight       = _aftCellWeight * KGTOLBS;
_mainFuelCellWeight  = _mainFuelCellWeight * KGTOLBS;
_totalFuelCellWeight = _totalFuelCellWeight * KGTOLBS;

private _eng1FF = _heli getVariable "fza_sfmplus_engFF" select 0;
private _eng2FF = _heli getVariable "fza_sfmplus_engFF" select 1;

private _eng1FuelCons = 0;
private _eng1State    = _heli getVariable "fza_sfmplus_engState_new" select 0;
if (_eng1State == ENG_ON) then {
    _eng1FuelCons = _eng1FF * FUEL_FLOW_LBS_PER_HOUR;
} else {
    _eng1FuelCons = 0;
};

private _eng2FuelCons = 0;
private _eng2State    = _heli getVariable "fza_sfmplus_engState_new" select 1;
if (_eng2State == ENG_ON) then {
    _eng2FuelCons = _eng2FF * FUEL_FLOW_LBS_PER_HOUR;
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

[_fwdCellWeight, _ctrFuelWeight, _aftCellWeight, _mainFuelCellWeight, _totalFuelCellWeight, _eng1FuelCons, _eng2FuelCons, _totalFuelConsumption, _mainEnduranceNumber, _totalEnduranceNumber]