params["_heli", "_mpdIndex"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

//Lbs
//#define FORWARD_FUEL_CELL_WEIGHT 1041
//#define AFT_FUEL_CELL_WEIGHT 1534
//#define TOTAL_FUEL_CELL_WEIGHT 2575

//#define MFD_IND_FUEL_IAFS_INSTALLED 0
//#define MFD_IND_FUEL_IAFS_STATE 1

[_heli] call fza_mpd_fnc_fuelGetData params [ "_forwardCellWeight" 
                                            , "_ctrFuelWeight"
                                            , "_aftCellWeight"
                                            , "_mainFuelCellWeight"
                                            , "_totalFuelCellWeight"
                                            , "_eng1FuelCons"
                                            , "_eng2FuelCons"
                                            , "_totalFuelConsumption"
                                            , "_mainEnduranceNumber"
                                            , "_totalEnduranceNumber"
                                            ];

[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_FWD),      _forwardCellWeight toFixed 0] call fza_mpd_fnc_updateMfdText;
[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_AFT),      _aftCellWeight toFixed 0] call fza_mpd_fnc_updateMfdText;

[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_FLOW_1),   _eng1FuelCons toFixed 0] call fza_mpd_fnc_updateMfdText;
[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_FLOW_2),   _eng2FuelCons toFixed 0] call fza_mpd_fnc_updateMfdText;
[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_FLOW_TOT), _totalFuelConsumption toFixed 0] call fza_mpd_fnc_updateMfdText;

[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_INT),      _mainFuelCellWeight toFixed 0] call fza_mpd_fnc_updateMfdText;
[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_ENDR_INT), _mainEnduranceNumber] call fza_mpd_fnc_updateMfdText;

//Is the IAFS installed?
private _IAFSInstalled = BOOLTONUM(_heli getVariable "fza_ah64_IAFSInstalled" == true);
[_heli, MFD_INDEX_OFFSET(MFD_IND_FUEL_IAFS_INSTALLED), _IAFSInstalled] call fza_mpd_fnc_updateMfdValue;
//Is the IAFS on?
private _IAFSOn = BOOLTONUM(_heli getVariable "fza_ah64_IAFSOn" == true);
[_heli, MFD_INDEX_OFFSET(MFD_IND_FUEL_IAFS_ON), _IAFSOn] call fza_mpd_fnc_updateMfdValue;
//IAFS values
[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_IAFS),     _ctrFuelWeight toFixed 0] call fza_mpd_fnc_updateMfdText;
[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_TOT),      _totalFuelCellWeight toFixed 0] call fza_mpd_fnc_updateMfdText;
[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_FUEL_ENDR_TOT), _totalEnduranceNumber] call fza_mpd_fnc_updateMfdText;