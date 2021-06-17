/* ----------------------------------------------------------------------------
Function: BMK_fn_setArrayEngineController

Description:

Parameters:
  ...

Returns:
  ...

Examples:
  ...

Author:
  BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_deltaTime"];

private _intHvrTQTable    = [_heli getVariable "fza_ah64_hvrTqTable", getMass _heli] call fza_fnc_linearInterp;
private _intCruiseTQTable = [_heli getVariable "fza_ah64_cruiseTable", getMass _heli] call fza_fnc_linearInterp;
private _hvrIGE    = _intHvrTQTable select 1;
private _hvrOGE    = _intHvrTQTable select 2;
private _baseTQ    = _heli getVariable "fza_ah64_baseTQ";
private _hvrTQ     = linearConversion [15.24, 1.52, getPos _heli select 2, _hvrOGE, _hvrIGE, true];

private _hvrTQTable    = [[ 0.0, _baseTQ],
                          [ 0.7,  _hvrTQ],
                          [ 1.0,    1.34]];

private _cruiseTQTable = [[ 0.00, 		                  0.03],
                          [ 0.67, _intCruiseTQTable select 4],
                          [ 0.70, _intCruiseTQTable select 5],
                          [ 0.89, _intCruiseTQTable select 7],
                          [ 1.00, _intCruiseTQTable select 9]];

private _curHvrTQ = [_hvrTQTable,    fza_ah64_collectiveOutput] call fza_fnc_linearInterp select 1;
private _cruiseTQ = [_cruiseTQTable, fza_ah64_collectiveOutput] call fza_fnc_linearInterp select 1;

private _V_mps = abs vectorMagnitude [velocity _heli select 0, velocity _heli select 1];
private _engPctTQ = linearConversion [0.00, 12.35, _V_mps, _curHvrTQ, _cruiseTQ, true];

private _engStartSwitchState = _heli getVariable "fza_ah64_engStartSwitchState";
private _engPowerLeverState  = _heli getVariable "fza_ah64_engPowerLeverState";
private _engState            = _heli getVariable "fza_ah64_engState";
//Ng variables
private _engStartNg = _heli getVariable "fza_ah64_engStartNg";
private _engIdleNg  = _heli getVariable "fza_ah64_engIdleNg";
private _engFlyNg   = _heli getVariable "fza_ah64_engFlyNg";
//Np variables
private _engStartNp = _heli getVariable "fza_ah64_engStartNp";
private _engIdleNp  = _heli getVariable "fza_ah64_engIdleNp";
private _engFlyNp   = _heli getVariable "fza_ah64_engFlyNp"; 

//--------------------Engine 1--------------------//
private _eng1StartSwitchState = _engStartSwitchState select 0;
private _eng1PowerLeverState  = _engPowerLeverState select 0;
private _eng1State            = _engState select 0;

if (_eng1StartSwitchState == "START" && _eng1State == "OFF") then {
    _eng1State = "STARTING";
    [_heli, "fza_ah64_engStartSwitchState", 0, "OFF"] call fza_fnc_sfmplusSetArrayVariable;
};
//Ng variables
private _eng1BaseNG           = _heli getVariable "fza_ah64_engBaseNG" select 0;
private _eng1PctNG            = _heli getVariable "fza_ah64_engPctNG" select 0;
private _eng1NgMaxVal         = 0;
private _eng1NgCurVal         = 0;
private _eng1NgTimeToVal      = 0;
private _eng1NgValPerUnitTime = 0;
//Np variables
private _eng1PctNp            = 0;
private _eng1NpMaxVal         = 0;
private _eng1NpCurVal         = 0;
private _eng1NpTimeToVal      = 0;
private _eng1NpValPerUnitTime = 0;

if (_eng1State in ["OFF", "DEST"]) then {
  _eng1NgMaxVal         = 0;
  _eng1NgCurVal         = _eng1PctNG;
  _eng1NgTimeToVal      = 10;
  _eng1NgValPerUnitTime = _eng1NgCurVal / _eng1NgTimeToVal;
};

if (_eng1State == "STARTING" && _eng1PowerLeverState == "OFF") then {
  _eng1NgMaxVal         = _engStartNg;
  _eng1NgCurVal         = _eng1PctNG;
  _eng1NgTimeToVal      = 10;
  _eng1NgValPerUnitTime = _eng1NgMaxVal / _eng1NgTimeToVal;
};

if (_eng1State in ["STARTING", "ON"] && _eng1PowerLeverState == "IDLE") then {
  _eng1NgMaxVal         = _engIdleNg;
  _eng1NgCurVal         = _eng1PctNG;
  _eng1NgTimeToVal      = 24;
  _eng1NgValPerUnitTime = _eng1NgMaxVal / _eng1NgTimeToVal;
};

if (_eng1PctNG >= 0.52) then {
  _eng1State = "ON";
};

if (_eng1State == "ON" && _eng1PowerLeverState == "FLY") then {
  _eng1NgMaxVal         = _eng1PctNG;
  _eng1NgCurVal         = _engFlyNg;
  _eng1NgTimeToVal      = 1.5;
  _eng1NgValPerUnitTime = _eng1NgMaxVal / _eng1NgTimeToVal;
};

if (_eng1State == "ON" && _eng1PowerLeverState == "OFF") then {
  _eng1State = "OFF";
};

_eng1BaseNG = [_eng1NgMaxVal, _eng1NgCurVal, _deltaTime, _eng1NgValPerUnitTime] call fza_fnc_sfmplusClampedMove;

//--------------------Engine 2--------------------//
private _eng2StartSwitchState = _engStartSwitchState select 1;
private _eng2PowerLeverState  = _engPowerLeverState select 1;
private _eng2State            = _engState select 1;

if (_eng2StartSwitchState == "START" && _eng2State == "OFF") then {
  _eng2State = "STARTING";
  [_heli, "fza_ah64_engStartSwitchState", 1, "OFF"] call fza_fnc_sfmplusSetArrayVariable;
};
//Ng variables
private _eng2BaseNG           = _heli getVariable "fza_ah64_engBaseNG" select 1;
private _eng2PctNG            = _heli getVariable "fza_ah64_engPctNG" select 1;
private _eng2NgMaxVal         = 0;
private _eng2NgCurVal         = 0;
private _eng2NgTimeToVal      = 0;
private _eng2NgValPerUnitTime = 0;
//Np variables
private _eng2PctNp            = 0;
private _eng2NpMaxVal         = 0;
private _eng2NpCurVal         = 0;
private _eng2NpTimeToVal      = 0;
private _eng2NpValPerUnitTime = 0;

//---------------Combined Variables---------------//
private _pctNR = _eng1PctNP max _eng2PctNP;

//----------------Update Variables----------------//
//Engine 1
[_heli, "fza_ah64_engState",  0, _eng1State] call fza_fnc_sfmplusSetArrayVariable;
[_heli, "fza_ah64_engBaseNG", 0, _eng1BaseNG] call fza_fnc_sfmplusSetArrayVariable;

//Engine 2
[_heli, "fza_ah64_engState",  1, _eng2State] call fza_fnc_sfmplusSetArrayVariable;
[_heli, "fza_ah64_engBaseNG", 1, _eng2BaseNG] call fza_fnc_sfmplusSetArrayVariable;

//Debuging 
hintSilent format ["Ng = %1,
                    \nEng State = %2,
                    \nSwitch State = %3
                    \nPwr Lvr State = %4",  _heli getVariable "fza_ah64_engPctNG",
                                            _heli getVariable "fza_ah64_engState",
                                            _heli getVariable "fza_ah64_engStartSwitchState",
                                            _heli getVariable "fza_ah64_engPowerLeverState"] 