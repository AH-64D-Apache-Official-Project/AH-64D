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
#include "\fza_ah64_sfmplus\headers\core.hpp"
#define SCALE_METERS_FEET 3.28084

private _config  = configFile >> "CfgVehicles" >> typeof _heli >> "fza_sfmplus";

private _baroAlt = getPosASL _heli # 2 * SCALE_METERS_FEET;
private _baseAlt = 0.0;//getElevationOffset * SCALE_METERS_FEET;
private _baseFAT = 0.0;
switch (fza_ah64_sfmplusEnvironment) do {
	case ISA_STD: {
		_baseAlt = 0;
		_baseFAT = 15.0;
	};
	case EUROPE_SUMMER: {
		_baseAlt = 800;
		_baseFAT = 20.0;
	};
	case EUROPE_WINTER: {
		_baseAlt = 800;
		_baseFAT = 0.0;
	};
	case MIDDLE_EAST: {
		_baseAlt = 1800;
		_baseFAT = 30.0;
	};
	case CENTRAL_ASIA_SUMMER: {
		_baseAlt = 5000;
		_baseFAT = 30.0;
	};
	case CENTRAL_ASIA_WINTER: {
		_baseAlt = 5000;
		_baseFAT = -5.0;
	};
	case ASIA: {
		_baseAlt = 3100;
		_baseFAT = 25.0;
	};
};
private _pa      = round ((_baseAlt + _baroAlt) / 10) * 10;  //feet
_heli setVariable ["fza_sfmplus_PA", _pa];
private _fat     = _baseFAT - round((_baroAlt / 1000) * 2);//ambientTemperature select 0; //deg C
_heli setVariable ["fza_sfmplus_FAT", _fat];

/////////////////////////////////////////////////////////////////////////////////////////////
// Base Data        /////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _perfTable0 = [getArray (_config >> "perfTable0"), _pa] call fza_fnc_linearInterp;
private _perfTable1 = [getArray (_config >> "perfTable1"), _pa] call fza_fnc_linearInterp;
private _perfTable2 = [getArray (_config >> "perfTable2"), _pa] call fza_fnc_linearInterp;
private _perfTable3 = [getArray (_config >> "perfTable3"), _pa] call fza_fnc_linearInterp;
private _perfTable4 = [getArray (_config >> "perfTable4"), _pa] call fza_fnc_linearInterp;
//---------------------|-FAT-0-|----MC TQ-1-----|----MTA DE-2----|----MTA SE-3----|---MGWT DEI-4---|---MGWT DEO-5---|---MGWT SEI-6---|---MGWT SEO-7---|-GO/NOGO IGE-8-|--GO/NOGO OGE-9--|
private _perfTable  = [[    -40, _perfTable0 # 1, _perfTable0 # 2, _perfTable0 # 3, _perfTable0 # 4, _perfTable0 # 5, _perfTable0 # 6, _perfTable0 # 7, _perfTable0 # 8, _perfTable0 # 9],
					   [    -20, _perfTable1 # 1, _perfTable1 # 2, _perfTable1 # 3, _perfTable1 # 4, _perfTable1 # 5, _perfTable1 # 6, _perfTable1 # 7, _perfTable1 # 8, _perfTable1 # 9],
					   [      0, _perfTable2 # 1, _perfTable2 # 2, _perfTable2 # 3, _perfTable2 # 4, _perfTable2 # 5, _perfTable2 # 6, _perfTable2 # 7, _perfTable2 # 8, _perfTable2 # 9],
					   [     20, _perfTable3 # 1, _perfTable3 # 2, _perfTable3 # 3, _perfTable3 # 4, _perfTable3 # 5, _perfTable3 # 6, _perfTable3 # 7, _perfTable3 # 8, _perfTable3 # 9],
					   [     40, _perfTable4 # 1, _perfTable4 # 2, _perfTable4 # 3, _perfTable4 # 4, _perfTable4 # 5, _perfTable4 # 6, _perfTable4 # 7, _perfTable4 # 8, _perfTable4 # 9]];
private _intPerfTable = [_perfTable, _fat] call fza_fnc_linearInterp;
//Set max TQ CONT/DE/SE
_heli setVariable ["fza_sfmplus_maxTQ_CONT",   _intPerfTable select 1];
_heli setVariable ["fza_sfmplus_maxTQ_DE",     _intPerfTable select 2];
_heli setVariable ["fza_sfmplus_maxTQ_SE",     _intPerfTable select 3];
//Set max GWT IGE/OGE
_heli setVariable ["fza_sfmplus_maxGWT_DE_IGE",   _intPerfTable select 4];
_heli setVariable ["fza_sfmplus_maxGWT_DE_OGE",   _intPerfTable select 5];
_heli setVariable ["fza_sfmplus_maxGWT_SE_IGE",   _intPerfTable select 6];
_heli setVariable ["fza_sfmplus_maxGWT_SE_OGE",   _intPerfTable select 7];
//Set go/no-go Torque
_heli setVariable ["fza_sfmplus_goNoGoTQ_IGE", _intPerfTable select 8];
_heli setVariable ["fza_sfmplus_goNoGoTQ_OGE", _intPerfTable select 9];
/////////////////////////////////////////////////////////////////////////////////////////////
// Hover Data       /////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _hoverTable0 = [getArray (_config >> "hoverTable0"), _pa] call fza_fnc_linearInterp;
private _hoverTable1 = [getArray (_config >> "hoverTable1"), _pa] call fza_fnc_linearInterp;
private _hoverTable2 = [getArray (_config >> "hoverTable2"), _pa] call fza_fnc_linearInterp;
private _hoverTable3 = [getArray (_config >> "hoverTable3"), _pa] call fza_fnc_linearInterp;
private _hoverTable4 = [getArray (_config >> "hoverTable4"), _pa] call fza_fnc_linearInterp;
//---------------------|-FAT-0-|-------IGE-1---15K-----OGE-2-------|-------IGE-3---17K-----OGE-4-------|-------IGE-5---19K-----OGE-6------|-------IGE-7---21K-----OGE-8-------|
private _hoverTable = [[    -40, _hoverTable0 # 1, _hoverTable0 # 2, _hoverTable0 # 3, _hoverTable0 # 4, _hoverTable0 #5, _hoverTable0 # 6, _hoverTable0 # 7, _hoverTable0 # 8],
					   [    -20, _hoverTable1 # 1, _hoverTable1 # 2, _hoverTable1 # 3, _hoverTable1 # 4, _hoverTable1 #5, _hoverTable1 # 6, _hoverTable1 # 7, _hoverTable1 # 8],
					   [      0, _hoverTable2 # 1, _hoverTable2 # 2, _hoverTable2 # 3, _hoverTable2 # 4, _hoverTable2 #5, _hoverTable2 # 6, _hoverTable2 # 7, _hoverTable2 # 8],
					   [     20, _hoverTable3 # 1, _hoverTable3 # 2, _hoverTable3 # 3, _hoverTable3 # 4, _hoverTable3 #5, _hoverTable3 # 6, _hoverTable3 # 7, _hoverTable3 # 8],
					   [     40, _hoverTable4 # 1, _hoverTable4 # 2, _hoverTable4 # 3, _hoverTable4 # 4, _hoverTable4 #5, _hoverTable4 # 6, _hoverTable4 # 7, _hoverTable4 # 8]];
private _intHoverTable = [_hoverTable, _fat] call fza_fnc_linearInterp;
 //----------------------|-GWT-0-|-------IGE-1---------------OGE-2-------|
 private _hoverTable_GWT = [[  6804, _intHoverTable # 1, _intHoverTable # 2],
 						    [  7711, _intHoverTable # 3, _intHoverTable # 4],
 						    [  8618, _intHoverTable # 5, _intHoverTable # 6],
 						    [  9525, _intHoverTable # 7, _intHoverTable # 8]];
private _curGWT_kg      = _heli getVariable "fza_sfmplus_GWT";
private _intHoverTable2 = [_hoverTable_GWT, _curGWT_kg] call fza_fnc_linearInterp;
//Set hover TQ IGE/OGE
_heli setVariable ["fza_sfmplus_hvrTQ_IGE", _intHoverTable2 select 1];
_heli setVariable ["fza_sfmplus_hvrTQ_OGE", _intHoverTable2 select 2];
/////////////////////////////////////////////////////////////////////////////////////////////
// Cruise Data      /////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
//-40 deg C
private _cruiseTable00 = [getArray (_config >> "cruiseTable00"), _pa] call fza_fnc_linearInterp;	//15000lbs
private _cruiseTable01 = [getArray (_config >> "cruiseTable01"), _pa] call fza_fnc_linearInterp;	//17000lbs
private _cruiseTable02 = [getArray (_config >> "cruiseTable02"), _pa] call fza_fnc_linearInterp;	//19000lbs
private _cruiseTable03 = [getArray (_config >> "cruiseTable03"), _pa] call fza_fnc_linearInterp;	//21000lbs
//---------------------------|-GWT-0-|-------20kts-1-----|-------40kts-2-----|-------60kts-3-----|-------90kts-4-----|------120kts-5-----|------140kts-6-----|
private _cruiseTable0_GWT = [[   6804, _cruiseTable00 # 1, _cruiseTable00 # 2, _cruiseTable00 # 3, _cruiseTable00 # 4, _cruiseTable00 # 5, _cruiseTable00 # 6],
						 	 [   7711, _cruiseTable01 # 1, _cruiseTable01 # 2, _cruiseTable01 # 3, _cruiseTable01 # 4, _cruiseTable01 # 5, _cruiseTable01 # 6],
						 	 [   8618, _cruiseTable02 # 1, _cruiseTable02 # 2, _cruiseTable02 # 3, _cruiseTable02 # 4, _cruiseTable02 # 5, _cruiseTable02 # 6],
						 	 [   9525, _cruiseTable03 # 1, _cruiseTable03 # 2, _cruiseTable03 # 3, _cruiseTable03 # 4, _cruiseTable03 # 5, _cruiseTable03 # 6]];
private _intCruiseTable0 = [_cruiseTable0_GWT, _curGWT_kg] call fza_fnc_linearInterp;
//-20 deg C
private _cruiseTable10 = [getArray (_config >> "cruiseTable10"), _pa] call fza_fnc_linearInterp;	//15000lbs
private _cruiseTable11 = [getArray (_config >> "cruiseTable11"), _pa] call fza_fnc_linearInterp;	//17000lbs
private _cruiseTable12 = [getArray (_config >> "cruiseTable12"), _pa] call fza_fnc_linearInterp;	//19000lbs
private _cruiseTable13 = [getArray (_config >> "cruiseTable13"), _pa] call fza_fnc_linearInterp;	//21000lbs
//---------------------------|-GWT-0-|-------20kts-1-----|-------40kts-2-----|-------60kts-3-----|-------90kts-4-----|------120kts-5-----|------140kts-6-----|
private _cruiseTable1_GWT = [[   6804, _cruiseTable10 # 1, _cruiseTable10 # 2, _cruiseTable10 # 3, _cruiseTable10 # 4, _cruiseTable10 # 5, _cruiseTable10 # 6],
						 	 [   7711, _cruiseTable11 # 1, _cruiseTable11 # 2, _cruiseTable11 # 3, _cruiseTable11 # 4, _cruiseTable11 # 5, _cruiseTable11 # 6],
						 	 [   8618, _cruiseTable12 # 1, _cruiseTable12 # 2, _cruiseTable12 # 3, _cruiseTable12 # 4, _cruiseTable12 # 5, _cruiseTable12 # 6],
						 	 [   9525, _cruiseTable13 # 1, _cruiseTable13 # 2, _cruiseTable13 # 3, _cruiseTable13 # 4, _cruiseTable13 # 5, _cruiseTable13 # 6]];
private _intCruiseTable1 = [_cruiseTable1_GWT, _curGWT_kg] call fza_fnc_linearInterp;
//  0 deg C
private _cruiseTable20 = [getArray (_config >> "cruiseTable20"), _pa] call fza_fnc_linearInterp;	//15000lbs
private _cruiseTable21 = [getArray (_config >> "cruiseTable21"), _pa] call fza_fnc_linearInterp;	//17000lbs
private _cruiseTable22 = [getArray (_config >> "cruiseTable22"), _pa] call fza_fnc_linearInterp;	//19000lbs
private _cruiseTable23 = [getArray (_config >> "cruiseTable23"), _pa] call fza_fnc_linearInterp;	//21000lbs
//---------------------------|-GWT-0-|-------20kts-1-----|-------40kts-2-----|-------60kts-3-----|-------90kts-4-----|------120kts-5-----|------140kts-6-----|
private _cruiseTable2_GWT = [[   6804, _cruiseTable20 # 1, _cruiseTable20 # 2, _cruiseTable20 # 3, _cruiseTable20 # 4, _cruiseTable20 # 5, _cruiseTable20 # 6],
						 	 [   7711, _cruiseTable21 # 1, _cruiseTable21 # 2, _cruiseTable21 # 3, _cruiseTable21 # 4, _cruiseTable21 # 5, _cruiseTable21 # 6],
						 	 [   8618, _cruiseTable22 # 1, _cruiseTable22 # 2, _cruiseTable22 # 3, _cruiseTable22 # 4, _cruiseTable22 # 5, _cruiseTable22 # 6],
						 	 [   9525, _cruiseTable23 # 1, _cruiseTable23 # 2, _cruiseTable23 # 3, _cruiseTable23 # 4, _cruiseTable23 # 5, _cruiseTable23 # 6]];
private _intCruiseTable2 = [_cruiseTable2_GWT, _curGWT_kg] call fza_fnc_linearInterp;
// 20 deg C
private _cruiseTable30 = [getArray (_config >> "cruiseTable30"), _pa] call fza_fnc_linearInterp;	//15000lbs
private _cruiseTable31 = [getArray (_config >> "cruiseTable31"), _pa] call fza_fnc_linearInterp;	//17000lbs
private _cruiseTable32 = [getArray (_config >> "cruiseTable32"), _pa] call fza_fnc_linearInterp;	//19000lbs
private _cruiseTable33 = [getArray (_config >> "cruiseTable33"), _pa] call fza_fnc_linearInterp;	//21000lbs
//---------------------------|-GWT-0-|-------20kts-1-----|-------40kts-2-----|-------60kts-3-----|-------90kts-4-----|------120kts-5-----|------140kts-6-----|
private _cruiseTable3_GWT = [[   6804, _cruiseTable30 # 1, _cruiseTable30 # 2, _cruiseTable30 # 3, _cruiseTable30 # 4, _cruiseTable30 # 5, _cruiseTable30 # 6],
						 	 [   7711, _cruiseTable31 # 1, _cruiseTable31 # 2, _cruiseTable31 # 3, _cruiseTable31 # 4, _cruiseTable31 # 5, _cruiseTable31 # 6],
						 	 [   8618, _cruiseTable32 # 1, _cruiseTable32 # 2, _cruiseTable32 # 3, _cruiseTable32 # 4, _cruiseTable32 # 5, _cruiseTable32 # 6],
						 	 [   9525, _cruiseTable33 # 1, _cruiseTable33 # 2, _cruiseTable33 # 3, _cruiseTable33 # 4, _cruiseTable33 # 5, _cruiseTable33 # 6]];
private _intCruiseTable3 = [_cruiseTable3_GWT, _curGWT_kg] call fza_fnc_linearInterp;
// 40 deg C
private _cruiseTable40 = [getArray (_config >> "cruiseTable40"), _pa] call fza_fnc_linearInterp;	//15000lbs
private _cruiseTable41 = [getArray (_config >> "cruiseTable41"), _pa] call fza_fnc_linearInterp;	//17000lbs
private _cruiseTable42 = [getArray (_config >> "cruiseTable42"), _pa] call fza_fnc_linearInterp;	//19000lbs
private _cruiseTable43 = [getArray (_config >> "cruiseTable43"), _pa] call fza_fnc_linearInterp;	//21000lbs
//---------------------------|-GWT-0-|-------20kts-1-----|-------40kts-2-----|-------60kts-3-----|-------90kts-4-----|------120kts-5-----|------140kts-6-----|
private _cruiseTable4_GWT = [[   6804, _cruiseTable40 # 1, _cruiseTable40 # 2, _cruiseTable40 # 3, _cruiseTable40 # 4, _cruiseTable40 # 5, _cruiseTable40 # 6],
						 	 [   7711, _cruiseTable41 # 1, _cruiseTable41 # 2, _cruiseTable41 # 3, _cruiseTable41 # 4, _cruiseTable41 # 5, _cruiseTable41 # 6],
						 	 [   8618, _cruiseTable42 # 1, _cruiseTable42 # 2, _cruiseTable42 # 3, _cruiseTable42 # 4, _cruiseTable42 # 5, _cruiseTable42 # 6],
						 	 [   9525, _cruiseTable43 # 1, _cruiseTable43 # 2, _cruiseTable43 # 3, _cruiseTable43 # 4, _cruiseTable43 # 5, _cruiseTable43 # 6]];
private _intCruiseTable4 = [_cruiseTable4_GWT, _curGWT_kg] call fza_fnc_linearInterp;
//--------------------------|-FAT-0-|--------20kts-1------|--------40kts-2------|--------60kts-3------|--------90kts-4------|-------120kts-5-----|------140kts-6-------|
private _cruiseTable_FAT = [[    -40, _intCruiseTable0 # 1, _intCruiseTable0 # 2, _intCruiseTable0 # 3, _intCruiseTable0 # 4, _intCruiseTable0 #5, _intCruiseTable0 # 6],
					        [    -20, _intCruiseTable1 # 1, _intCruiseTable1 # 2, _intCruiseTable1 # 3, _intCruiseTable1 # 4, _intCruiseTable1 #5, _intCruiseTable1 # 6],
					        [      0, _intCruiseTable2 # 1, _intCruiseTable2 # 2, _intCruiseTable2 # 3, _intCruiseTable2 # 4, _intCruiseTable2 #5, _intCruiseTable2 # 6],
					        [     20, _intCruiseTable3 # 1, _intCruiseTable3 # 2, _intCruiseTable3 # 3, _intCruiseTable3 # 4, _intCruiseTable3 #5, _intCruiseTable3 # 6],
					        [     40, _intCruiseTable4 # 1, _intCruiseTable4 # 2, _intCruiseTable4 # 3, _intCruiseTable4 # 4, _intCruiseTable4 #5, _intCruiseTable4 # 6]];
private _cruiseTable = [_cruiseTable_FAT, _fat] call fza_fnc_linearInterp;
//Set cruise table
_heli setVariable ["fza_sfmplus_cruiseTable", _cruiseTable];
/////////////////////////////////////////////////////////////////////////////////////////////
// TAS Data         /////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
private _TASTable0 = [getArray (_config >> "TASTable0"), _pa] call fza_fnc_linearInterp;	//-40 deg C
private _TASTable1 = [getArray (_config >> "TASTable1"), _pa] call fza_fnc_linearInterp;	//-20 deg C
private _TASTable2 = [getArray (_config >> "TASTable2"), _pa] call fza_fnc_linearInterp;	//  0 deg C
private _TASTable3 = [getArray (_config >> "TASTable3"), _pa] call fza_fnc_linearInterp;	// 20 deg C
private _TASTable4 = [getArray (_config >> "TASTable4"), _pa] call fza_fnc_linearInterp;	// 40 deg C
private _TASTable_FAT = [[-40,  _TASTable0 # 1, _TASTable0 # 2, _TASTable0 # 3, _TASTable0 # 4, _TASTable0 # 5, _TASTable0 # 6],
						 [-20,  _TASTable1 # 1, _TASTable1 # 2, _TASTable1 # 3, _TASTable1 # 4, _TASTable1 # 5, _TASTable1 # 6],
						 [  0,  _TASTable2 # 1, _TASTable2 # 2, _TASTable2 # 3, _TASTable2 # 4, _TASTable2 # 5, _TASTable2 # 6],
						 [ 20,  _TASTable3 # 1, _TASTable3 # 2, _TASTable3 # 3, _TASTable3 # 4, _TASTable3 # 5, _TASTable3 # 6],
						 [ 40,  _TASTable4 # 1, _TASTable4 # 2, _TASTable4 # 3, _TASTable4 # 4, _TASTable4 # 5, _TASTable4 # 6]];
private _TASTable = [_TASTable_FAT, _fat] call fza_fnc_linearInterp;
//Set TAS variables
_heli setVariable ["fza_sfmplus_TAS_vne",    _TASTable # 1];
_heli setVariable ["fza_sfmplus_TAS_vsse",   _TASTable # 2];

_heli setVariable ["fza_sfmplus_TAS_rngTAS", _TASTable # 3];
_heli setVariable ["fza_sfmplus_TAS_rngTQ",  _TASTable # 4];
_heli setVariable ["fza_sfmplus_TAS_rngFF",  ([getArray (_config >> "engFFTable"), _TASTable # 4] call fza_fnc_linearInterp select 1) * 2 * 7936.64];

_heli setVariable ["fza_sfmplus_TAS_endTAS", _TASTable # 5];
_heli setVariable ["fza_sfmplus_TAS_endTQ",  _TASTable # 6];
_heli setVariable ["fza_sfmplus_TAS_endFF",  ([getArray (_config >> "engFFTable"), _TASTable # 6] call fza_fnc_linearInterp select 1) * 2 * 7936.64];