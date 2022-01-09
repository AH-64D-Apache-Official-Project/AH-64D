params["_heli", "_mpdIndex"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

//Lbs
//#define FORWARD_FUEL_CELL_WEIGHT 1041
//#define AFT_FUEL_CELL_WEIGHT 1534
//#define TOTAL_FUEL_CELL_WEIGHT 2575


[_heli] call fza_mpd_fnc_fuelGetData params ["_forwardCellWeight", "_aftCellWeight", "_totFuelCellWeight", "_eng1FuelCons", "_eng2FuelCons", "_totalFuelConsumption", "_enduranceNumber"];

_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_FWD), _forwardCellWeight toFixed 0];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_AFT), _aftCellWeight toFixed 0];

_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_FLOW_1), _eng1FuelCons toFixed 0];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_FLOW_2), _eng2FuelCons toFixed 0];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_FLOW_TOT), _totalFuelConsumption toFixed 0];

_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_INT), _totFuelCellWeight toFixed 0];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_ENDR_INT), _enduranceNumber];