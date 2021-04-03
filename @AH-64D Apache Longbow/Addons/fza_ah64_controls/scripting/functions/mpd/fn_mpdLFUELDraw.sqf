params["_heli"];
#include "\fza_ah64_controls\headers\selections.h"

//Lbs
#define FORWARD_FUEL_CELL_WEIGHT 1041
#define AFT_FUEL_CELL_WEIGHT 1534
#define TOTAL_FUEL_CELL_WEIGHT 2575
#define KGTOLBS 2.20462

private _fuelWeight = if (isObjectRTD _heli) then {
	(weightRTD _heli # 2) * KGTOLBS;
} else {
	TOTAL_FUEL_CELL_WEIGHT * (fuel _heli)
};

private _forwardCellWeight = (FORWARD_FUEL_CELL_WEIGHT / TOTAL_FUEL_CELL_WEIGHT) * _fuelWeight;
private _aftCellWeight = (AFT_FUEL_CELL_WEIGHT / TOTAL_FUEL_CELL_WEIGHT) * _fuelWeight;

private _enginesOn = if (isObjectRTD _heli && difficultyEnabledRTD && local _heli) then {
	private _engines = enginesIsOnRTD _heli;
	_engines resize 2;
	_engines apply {[_x, false] select isNil "_x"};
} else {
	[[false, false], [true, true]] select isEngineOn _heli;
};

private _FFVal = [_heli] call fza_fnc_sfmplusGetData select 2;
_FFVal = _FFVal * 7936.64;
private _engineFuelConsumption = _enginesOn apply {[0, (_FFVal / 2)] select _x};
private _totalFuelConsumption  = _engineFuelConsumption # 0 + _engineFuelConsumption # 1;

private _enduranceNumber = if(_totalFuelConsumption > 0) then {
	private _enduranceTotal = _fuelWeight / _totalFuelConsumption * 60; //Minutes
	private _enduranceMinutes = _enduranceTotal % 60;
	private _enduranceHours = floor(_enduranceTotal / 60);
	100 * _enduranceHours + _enduranceMinutes;
} else {999;};

[_heli, _forwardCellWeight, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_PL_FWD_FUEL] call fza_fnc_drawNumberSelections;
[_heli, _aftCellWeight, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_PL_AFT_FUEL] call fza_fnc_drawNumberSelections;
[_heli, 0, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_PL_IAFS_FUEL] call fza_fnc_drawNumberSelections;

[_heli, _engineFuelConsumption # 0, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_PL_FLOW1_FUEL] call fza_fnc_drawNumberSelections;
[_heli, _engineFuelConsumption # 1, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_PL_FLOW2_FUEL] call fza_fnc_drawNumberSelections;
[_heli, _totalFuelConsumption, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_PL_TFLOW_FUEL] call fza_fnc_drawNumberSelections;

[_heli, _fuelWeight, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_PL_INT_FUEL] call fza_fnc_drawNumberSelections;
[_heli, _fuelWeight, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_PL_TOT_FUEL] call fza_fnc_drawNumberSelections;

[_heli, _enduranceNumber, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_PL_IEND_FUEL] call fza_fnc_drawNumberSelections;
[_heli, _enduranceNumber, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_PL_TEND_FUEL] call fza_fnc_drawNumberSelections;
