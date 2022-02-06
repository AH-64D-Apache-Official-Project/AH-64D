/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_perfData

Description:
	Updates performance tables for the aircraft based on Pressure Altitude in
	feet, Temperature in deg C and aircraft gross weight in kg.

Parameters:
	_heli - The helicopter to get information from [Unit].

Returns:
	...

Examples:
	...

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

private _PA     = 0;  //feet
private _temp   = 20; //deg C
private _config = configFile >> "CfgVehicles" >> typeof _heli >> "Fza_SfmPlus";

//Max TQ DE and SE
private _intMaxTQTable  = [getArray (_config >> "maxTqTable"), _PA] call fza_fnc_linearInterp;
private _intMaxTQTable2 = [[-40, _intMaxTQTable select 1, _intMaxTQTable select 2],
						   [-20, _intMaxTQTable select 3, _intMaxTQTable select 4],
						   [  0, _intMaxTQTable select 5, _intMaxTQTable select 6],
						   [ 20, _intMaxTQTable select 7, _intMaxTQTable select 8],
						   [ 40, _intMaxTQTable select 9, _intMaxTQTable select 10]];
private _intMaxTQTable3 = [_intMaxTQTable2, _temp] call fza_fnc_linearInterp;
_heli setVariable ["fza_sfmplus_maxTQ_DE", _intMaxTQTable3 select 1];
_heli setVariable ["fza_sfmplus_maxTQ_SE", _intMaxTQTable3 select 2];

//Max GWT IGE and OGE
private _intMaxGWTTable  = [getArray (_config >> "maxGwtTable"), _PA] call fza_fnc_linearInterp;
private _intMaxGWTTable2 = [[-40, _intMaxGWTTable select 1, _intMaxGWTTable select 2],
						    [-20, _intMaxGWTTable select 3, _intMaxGWTTable select 4],
						    [  0, _intMaxGWTTable select 5, _intMaxGWTTable select 6],
						    [ 20, _intMaxGWTTable select 7, _intMaxGWTTable select 8],
						    [ 40, _intMaxGWTTable select 9, _intMaxGWTTable select 10]];
private _intMaxGWTTable3 = [_intMaxGWTTable2, _temp] call fza_fnc_linearInterp;
_heli setVariable ["fza_sfmplus_maxGWT_IGE", _intMaxGWTTable3 select 1];
_heli setVariable ["fza_sfmplus_maxGWT_OGE", _intMaxGWTTable3 select 2];

//Go/No-Go TQ IGE and OGE
private _intGoNoGoTable  = [getArray (_config >> "goNoGoTqTable"), _PA] call fza_fnc_linearInterp;
private _intGoNoGoTable2 = [[-40, _intGoNoGoTable select 1, _intGoNoGoTable select 2],
						    [-20, _intGoNoGoTable select 3, _intGoNoGoTable select 4],
						    [  0, _intGoNoGoTable select 5, _intGoNoGoTable select 6],
						    [ 20, _intGoNoGoTable select 7, _intGoNoGoTable select 8],
						    [ 40, _intGoNoGoTable select 9, _intGoNoGoTable select 10]];
private _intGoNoGoTable3 = [_intGoNoGoTable2, _temp] call fza_fnc_linearInterp;
_heli setVariable ["fza_sfmplus_goNoGoTQ_IGE", _intGoNoGoTable3 select 1];
_heli setVariable ["fza_sfmplus_goNoGoTQ_OGE", _intGoNoGoTable3 select 2];

//Hover TQ IGE and OGE
private _curGWT_kg     = getMass _heli;
private _intHvrTQTable = [getArray (_config >> "hvrTqTable"), _curGWT_kg] call fza_fnc_linearInterp;
_heli setVariable ["fza_sfmplus_hvrTQ_IGE", _intHvrTQTable select 1];
_heli setVariable ["fza_sfmplus_hvrTQ_OGE", _intHvrTQTable select 2];